############################################################
# Copyright 2020, Tryon Solutions, Inc.
# All rights reserved.  Proprietary and confidential.
#
# This file is subject to the license terms found at 
# https://www.cycleautomation.com/end-user-license-agreement/
#
# The methods and techniques described herein are considered
# confidential and/or trade secrets. 
# No part of this file may be copied, modified, propagated,
# or distributed except as authorized by the license.
############################################################ 
# Utility: Mobile Serialization Utilities.feature
#
# Functional Area: Serialization
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Mobile
# 
# Description: This utility contains scenarios with mobile steps performing serial number capture and confirmation actions
# both for Picking, Receiving, and Adjustment scenarios
#
# Public Scenarios:
#	- Mobile Scan Serial Number Outbound Capture Picking - perform OUTCAP_ONLY serial number processing for picking
#	- Mobile Scan Serial Number Cradle to Grave Picking - perform CRDL_TO_GRAVE serial number processing for picking
#	- Mobile Scan Serial Number Cradle to Grave Receiving - perform CRDL_TO_GRAVE receiving serial number processing
#	- Mobile Validate ASN Serial Number Cradle to Grave Receiving - If ASN receiving serialization, lookup and validate assigned serial numbers
#
# Assumptions:
# - The MOCA and NON User Interface Utility Scenarios are in the Terminal version of this Utility (Terminal Serilization Utilities.feature)
# - There are several prerequisites in order to test items with serialization enabled.
#   The data required for testing serialized items is dependent upon the serialization type assigned to the item
#   (seq_typ) as well as the serial number types assigned to those items.
# - Picking for Outbound Capture items
#   - A list of valid serial numbers needs to be available for cycle to support picking with 
#     outbound capture serial capture 
#   - The serial numbers in this file must conform to the serial mask set up for the serial number type
#   - The serial number files need to be stored the top-level sub-directory Data/Serial Numbers
#   - The file should be named as follows: Serial_List_Outcap_(Serial Number Type).txt 
#	  where (Serial Number Type) is replaced by a valid serial number type
#       Examples:  Serial List Outcap CYCCS01.txt
#                  Serial List Outcap CYCCS02.txt
#   - Each file should include unique serial number ranges for the serial number type to ensure proper 
#	  function of the picking scenarios
# - Picking for Cradle to Grave items
#   - Cradle to grave serialized items require serial numbers to be assigned to the inventory being picked
#   - The cradle to grave scenarios retrieve the serial numbers from the pick source location and 
#	  use those values for confirmation
# - Receiving for Cradle to Grave items
#   - If ASN, the serial numbers need to be assigned to the ASN (or for CNT inventory). This can be done with 
#     "Add Serial Numbers for Cradle to Grave" scenario (in this Utility) after the dataset has been loaded.
#   - If non-ASN, serial numbers will be captured after inventory has been created.
#	- Serial number files for EACH and CASE (for Receiving) are in the Data/Serial Numbers directory.
#     Each file has a max of 100 serial numbers. More can be added if needed. Serial numbers used in
#	  Picking and Receiving have different starting numbers (00 for Picking and 99 for Receiving)
#   - When inventory is cleaned up the associated serial numbers should also be cleaned up by the test
#
# Notes:
# None
# 
############################################################ 
Feature: Mobile Serialization Utilities

@wip @public
Scenario: Mobile Scan Serial Number Outbound Capture Picking
#############################################################
# Description: For OUTCAP_ONLY serialization, for each part
# extract the serial number type from the screen. Then from
# serial number file, extract the next serial number and use as 
# input on for screen. Check for errors from that output.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	serial_num_type - serial number type (i.e CYCEA01)
#	serialization_phase - set to PCK
#############################################################

Given I "perform OUTCAP_ONLY picking serialization, look for serial number (from file) and enter/validate that serial number"
	Given I assign "PCK" to variable "serialization_phase"
	While I see "Serial Number Capture" in element "className:appbar-title" in web browser within $wait_med seconds
    	Then I "capture serial number Type ID from the Mobile screen"
			And I copy text inside element "xPath://span[contains(text(),'Serial Number Type ID')]/ancestor::aq-displayfield[contains(@id,'SERIAL_NUMBER')]/descendant::span[contains(@class,'data')]" in web browser to variable "serial_num_type"
			And I verify variable "serial_num_type" is assigned
			And I verify text $serial_num_type is not equal to ""
 
		And I "get serial number relative to Serial Number Type ID"       
			Given I execute scenario "Create Variable outbound_cap_serial_file"
			Then I assign $outbound_cap_serial_file to variable "serial_num_file"
			And I execute scenario "Get Serial Number from Serial Number File"

		And I "enter the provided serial number"          
			Then I type $serial_scan in element "name:ser_num" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser

			And I execute scenario "Mobile Check for Serial Capture Errors"

		And I wait $wait_short seconds
	EndWhile
    
@wip @public
Scenario: Mobile Scan Serial Number Cradle to Grave Receiving
#############################################################
# Description: For CRDL_TO_GRAVE receiving serialization, for each part
# extract the serial number type from the screen. Then from
# serial number file, extract the next serial number and use as 
# input. Check for errors from that output.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	serial_num_type - serial number type (i.e CYCEA01)
#	serialization_phase - set to RCV
#############################################################

Given I "perform CRDL_TO_GRAVE receiving serialization, look for serial number (from file) and enter/validate that serial number"
    Then I assign "RCV" to variable "serialization_phase"
	While I see "Serial Number Capture" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I "capture serial number Type ID from the Mobile screen"
			And I copy text inside element "xPath://span[contains(text(),'Serial Number Type ID')]/ancestor::aq-displayfield[contains(@id,'SERIAL_NUMBER')]/descendant::span[contains(@class,'data')]" in web browser to variable "serial_num_type"
			And I verify variable "serial_num_type" is assigned
			And I verify text $serial_num_type is not equal to ""

		And I "get serial number relative to Serial Number Type ID"
			Then I execute scenario "Create Variable cradle_to_grave_rcv_serial_file"
			And I assign $crdle_to_grave_rcv_serial_file to variable "serial_num_file"
			And I execute scenario "Get Serial Number from Serial Number File"

		And I "enter the provided serial number"
			Then I type $serial_scan in element "name:ser_num" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser

			Then I execute scenario "Mobile Check for Serial Capture Errors"

		And I wait $wait_short seconds
	EndWhile

@wip @public
Scenario: Mobile Scan Serial Number Cradle to Grave Picking
#############################################################
# Description: For CRDL_TO_GRAVE serialization, call utility scenario
# Get Serial Number List for Cradle to Grave who's results
# will have information about the srcloc/prtnum's lookup of inv_ser_num
# table results. Use that data and the serial number from the query to enter into the
# Mobile App screens serial number input and look for errors.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#	serialization_phase - set to PCK
#############################################################

Given I "perform CRDL_TO_GRAVE picking serialization, enter the serial number stored with the part as it's serial number"
	Given I assign "PCK" to variable "serialization_phase"
	Then I execute scenario "Get Serial Number List for Cradle to Grave"
	And I assign 0 to variable "serial_rownum"
	While I see "Confirm Serial Number" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I assign row $serial_rownum column "ser_num" to variable "serial_scan"
		And I type $serial_scan in element "name:ser_num" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser

		If I see "Confirmed" in web browser within $screen_wait seconds 
			Then I press keys "ENTER" in web browser
			And I wait $wait_short seconds 
		Else I execute scenario "Mobile Check for Serial Capture Errors"
		EndIf
	
		And I increase variable "serial_rownum" by 1
		And I wait $wait_short seconds
	EndWhile
    
@wip @public
Scenario: Mobile Validate ASN Serial Number Cradle to Grave Receiving
#############################################################
# Description: For CRDL_TO_GRAVE serialization, call utility scenario
# Get Serial Number List for Cradle to Grave for ASN Receiving who's results
# will have information about the srcloc/prtnum's lookup of inv_ser_num
# table results. Use that data and the serial number from the query to enter into the
# Mobile App screens serial number input and look for errors.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#	serialization_phase - set to RCV
#############################################################

Given I "perform CRDL_TO_GRAVE ASN RCV serialization, validate the serial number stored with the part as it's serial number"
	Given I assign "RCV" to variable "serialization_phase"
	Then I execute scenario "Get Serial Number List for Cradle to Grave"
	And I assign 0 to variable "serial_rownum"
	While I see "Validate ASN Serial Number" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I assign row $serial_rownum column "ser_num" to variable "serial_scan"
		And I type $serial_scan in element "name:ser_num" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser

		If I see "Validate ASN Serial" in element "className:appbar-title" in web browser within $screen_wait seconds
			Then I wait $screen_wait seconds 
		Else I execute scenario "Mobile Check for Serial Capture Errors"
		EndIf
	
		And I increase variable "serial_rownum" by 1
		And I wait $wait_short seconds
	EndWhile

############################################################
# Private Scenarios:
#	Mobile Check for Serial Capture Errors - check for screen errors after input of serial number information
############################################################

@wip @private
Scenario: Mobile Check for Serial Capture Errors
#############################################################
# Description: Scenario will look for strings in the mobile and
# detect error conditions for a serialization input/action 
# and fail the step.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "check for errors after entering serial number"
	Then I assign "Serial number entered/scanned doesn't conform to serial mask specifications" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I fail step with error message "ERROR: Serial number entered does not match serial mask for the item and serial number type"
	ElsIf I assign "The serial number scanned is already confirmed" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I fail step with error message "ERROR: Serial number entered has already been confirmed"
		EndIf
    ElsIf I assign "Duplicate serial number" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I fail step with error message "ERROR: Serial number entered has already been scanned"
		EndIf
	ElsIf I assign "Invalid serial number" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I fail step with error message "ERROR: Serial number entered is Invalid"
		EndIf
	ElsIf I see "Entry" in web browser
		Then I fail step with error message "ERROR: Serial number entry required"
	EndIf