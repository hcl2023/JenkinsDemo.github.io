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
# Utility: Terminal Serialization Utilities.feature
#
# Functional Area: Serialization
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
# 
# Description: This utility contains scenarios with MOCA commands
# and terminal steps performing serial number capture and confirmation actions
# both for Picking and Receiving scenarios
#
# Public Scenarios:
#	- Get Item Serialization Type - return seq_typ prtnum attribute of CRDL_TO_GRAVE, OUTCAP_ONLY, or NONE
#	- Terminal Scan Serial Number Outbound Capture Picking - perform OUTCAP_ONLY serial number processing for picking
#	- Terminal Scan Serial Number Cradle to Grave Picking - perform CRDL_TO_GRAVE serial number processing for picking
#	- Terminal Scan Serial Number Cradle to Grave Receiving - perform CRDL_TO_GRAVE receiving serial number processing
#	- Add Serial Numbers for Cradle to Grave - Add serial numbers to ASN receiving case
#	- Terminal Validate ASN Serial Number Cradle to Grave Receiving - If ASN receiving serialization, lookup and validate assigned serial numbers
#
# Assumptions:
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
Feature: Terminal Serialization Utilities
	   
@wip @public
Scenario: Get Item Serialization Type
#############################################################
# Description: This scenario will call a MSQL script to look
# at the specified part and look at seq_typ attribute to determine if
# CRDL_TO_GRAVE or OUTCAP_ONLY is set and return. 
# If not set, MSQL and scenario will return "NONE"
# MSQL Files:
#	get_item_serialization_type.msql
# Inputs:
# 	Required:
#   	prtnum - part number
#		wh_id - warehouse ID
#		client_id - Client ID
#	Optional:
#		None
# Outputs:
# 	ser_typ - CRDL_TO_GRAVE, OUTCAP_ONLY, or NONE
#############################################################

Given I "get the serialization type relative to the part"
	Then I assign "get_item_serialization_type.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
		Then I assign row 0 column "ser_typ" to variable "serialization_type"
	Else I fail step with error message "ERROR: Could not get serialization_type from prtnum"
    EndIf
    
@wip @public
Scenario: Terminal Scan Serial Number Outbound Capture Picking
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
	And I execute scenario "Terminal Set Serial Scan Cursor Positions"
	While I see "Serial" on line 1 in terminal within $wait_med seconds
	And I see cursor at line $cursor_line column $cursor_column in terminal
		Then I "verify screen has loaded for information to be copied off of it"
			And I verify screen is done loading in terminal within $max_response seconds

		If I verify text $term_type is equal to "handheld"
			Then I copy terminal line 11 columns 2 through 11 to variable "serial_num_type"
		Else I verify text $term_type is equal to "vehicle"
        	And I copy terminal line 6 columns 10 through 19 to variable "serial_num_type"
		EndIf
        
		Given I execute scenario "Create Variable outbound_cap_serial_file"
        Then I assign $outbound_cap_serial_file to variable "serial_num_file"
        And I execute scenario "Get Serial Number from Serial Number File"
            
		When I enter $serial_scan in terminal
		Then I execute scenario "Terminal Check for Serial Capture Errors"
	EndWhile
    
@wip @public
Scenario: Terminal Scan Serial Number Cradle to Grave Receiving
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
    And I execute scenario "Terminal Set Serial Scan Cursor Positions"

	Then I "verify screen has loaded for information to be copied off of it"
		And I verify screen is done loading in terminal within $max_response seconds

	While I see "Serial Numb" on line 1 in terminal within $wait_med seconds
	And I see cursor at line $cursor_line column $cursor_column in terminal within $wait_med seconds
		Then I "verify screen has loaded for information to be copied off of it"
			And I verify screen is done loading in terminal within $max_response seconds

		If I verify text $term_type is equal to "handheld"
			Then I copy terminal line 11 columns 2 through 11 to variable "serial_num_type"
		Else I verify text $term_type is equal to "vehicle"
        	And I copy terminal line 6 columns 10 through 19 to variable "serial_num_type"
		EndIf

        Given I execute scenario "Create Variable cradle_to_grave_rcv_serial_file"
		Then I assign $crdle_to_grave_rcv_serial_file to variable "serial_num_file"
        And I execute scenario "Get Serial Number from Serial Number File"

		When I enter $serial_scan in terminal
		Then I execute scenario "Terminal Check for Serial Capture Errors"

		Then I "verify screen has loaded for information to be copied off of it"
			And I verify screen is done loading in terminal within $max_response seconds
		And I wait $wait_short seconds
	EndWhile

@wip @public
Scenario: Terminal Scan Serial Number Cradle to Grave Picking
#############################################################
# Description: For CRDL_TO_GRAVE serialization, call utility scenario
# Get Serial Number List for Cradle to Grave who's results
# will have information about the srcloc/prtnum's lookup of inv_ser_num
# table results. Use that data and the serial number from the query to enter into the
# terminal screens serial number input and look for errors.
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
	And I execute scenario "Terminal Set Serial Scan Cursor Positions"
	Then I execute scenario "Get Serial Number List for Cradle to Grave"
	And I assign 0 to variable "serial_rownum"
	
    Given I verify screen is done loading in terminal within $max_response seconds
	While I see "Confirm Serial" on line 1 in terminal within $wait_med seconds
	And I see cursor at line $cursor_line column $cursor_column in terminal
		Then I assign row $serial_rownum column "ser_num" to variable "serial_scan"
		And I enter $serial_scan in terminal

		If I verify screen is done loading in terminal within $max_response seconds
		EndIf

		If I see "Confirmed" in terminal within $wait_med seconds 
			Then I press keys "ENTER" in terminal
			And I wait $screen_wait seconds 
		Else I execute scenario "Terminal Check for Serial Capture Errors"
		EndIf
	
		And I increase variable "serial_rownum" by 1
	EndWhile
    
@wip @private
Scenario: Add Serial Numbers for Cradle to Grave
#############################################################
# Description: For CRDL_TO_GRAVE serialization and ASN receiving,
# add serial numbers relative to the lodnum/prtnum in the ASN. This is not done
# in the dataset, but in this standalone scenario to support 
# serialized and non-serialized cases and usually called in the test
# case Background scenario.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	prtnum - part number
#		wh_id - warehouse ID
#		client_id - Client ID
#		lodnum - the ASN lodnum
#	Optional:
#		None
# Outputs:
#	serialization_phase - set to RCV
#############################################################

Given I "assign serial numbers to ASN generated inventory before ASN receiving process"
	Then I assign "RCV" to variable "serialization_phase"    
    And I "get the Serial Number Type IDs relative the prtnum"
		Then I execute scenario "Get Serial Number Type IDs"

	And I "get information relative to the lodnum required to be able to add a Serial Number"
    	Then I execute scenario "Get Detail from Lodnum"
    	And I assign "0" to variable "detail_row_counter"
        And I assign $row_count to variable "detail_row_count"
    	And I convert string variable "detail_row_counter" to integer variable "detail_row_counter_num"
    	While I verify number $detail_row_counter_num is less than $detail_row_count
			Then I assign row $detail_row_counter_num column "catch_qty" to variable "catch_qty"
        	And I assign row $detail_row_counter_num column "untqty" to variable "untqty"
			And I assign row $detail_row_counter_num column "subnum" to variable "subnum"
			And I assign row $detail_row_counter_num column "dtlnum" to variable "dtlnum"
			And I assign row $detail_row_counter_num column "untcas" to variable "untcas"

			Given I "process each serial number type ID, determining file for serial numbers and adding serial numbers"
				Then I assign 1 to variable "ser_num_typ_cnt"
 				While I assign $ser_num_typ_cnt th item from "," delimited list $ser_typ_list to variable "serial_num_type"
    				And I execute scenario "Create Variable cradle_to_grave_rcv_serial_file"
					And I assign $crdle_to_grave_rcv_serial_file to variable "serial_num_file"
        			And I execute scenario "Get Serial Number from Serial Number File"
        			When I execute scenario "Add Serial Numbers to ASN Inventory"

					And I increase variable "ser_num_typ_cnt" by 1
            	EndWhile

			And I "increment loop counts and get lodnum information again"
				Then I increase variable "detail_row_counter_num" by 1
            	And I execute scenario "Get Detail from Lodnum"
		EndWhile
        
	Given I unassign variables "detail_row_count,detail_row_counter,detail_row_counter_num"

@wip @public
Scenario: Terminal Validate ASN Serial Number Cradle to Grave Receiving
#############################################################
# Description: For CRDL_TO_GRAVE serialization, call utility scenario
# Get Serial Number List for Cradle to Grave for ASN Receiving who's results
# will have information about the srcloc/prtnum's lookup of inv_ser_num
# table results. Use that data and the serial number from the query to enter into the
# terminal screens serial number input and look for errors.
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
	And I execute scenario "Terminal Set Serial Scan Cursor Positions"
	Then I execute scenario "Get Serial Number List for Cradle to Grave"
	And I assign 0 to variable "serial_rownum"
	
    Given I verify screen is done loading in terminal within $max_response seconds
	While I see "Validate ASN Serial" on line 1 in terminal within $wait_med seconds
	And I see cursor at line $cursor_line column $cursor_column in terminal
		Then I assign row $serial_rownum column "ser_num" to variable "serial_scan"
		And I enter $serial_scan in terminal

		If I verify screen is done loading in terminal within $max_response seconds
		EndIf

		If I see "Validate ASN Serial" on line 1 in terminal within $wait_med seconds
			Then I wait $screen_wait seconds 
		Else I execute scenario "Terminal Check for Serial Capture Errors"
		EndIf
	
		And I increase variable "serial_rownum" by 1
	EndWhile

############################################################
# Private Scenarios:
# 	Terminal Set Serial Scan Cursor Positions - get line and column locations 
#	Terminal Check for Serial Capture Errors - check for screen errors after input of serial number information
#	Create Variable outbound_cap_serial_file - determine location for OUTCAP_ONLY serial number files
#	Create Variable cradle_to_grave_rcv_serial_file - determine location for CRDL_TO_GRAVE Receiving serial number files
#	Get Serial Number List for Cradle to Grave - get serial number info from inv_sum_num table
#	Get Serial Number Type IDs - get the list of serial number type IDs relative to prtnum
#	Add Serial Numbers to ASN Inventory - MSQL to add a serial number to a prtnum/lodnum that is part of ASN Reveiving
#	Get Detail from Lodnum - MSQL to get info from a loadnum to use in adding ASN serial numbers
#	Get Serial Number from Serial Number File - get a serial number from a serial number file for use
############################################################
	
@wip @private
Scenario: Get Serial Number Type IDs
#############################################################
# Description: For CRDL_TO_GRAVE and ASN Receiving,
# get the list of serial number type IDs relative to the
# lodnum/prtnumm, return all in a comma separted formated variable
# MSQL Files:
#	get_serial_num_type_id.msql
# Inputs:
# 	Required:
#   	prtnum - part number
#		wh_id - warehouse ID
#		lodnum - ASN lodnum
#	Optional:
#		None
# Outputs:
#	ser_typ_list - comma separated list of serial number types for this part
#############################################################

Given I "determine Serial Number Types"
	Then I assign "get_serial_num_type_id.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
		And I assign "0" to variable "cur_cnt"
        And I convert string variable "cur_cnt" to integer variable "cur_cnt_num"
    	And I convert string variable "row_count" to integer variable "row_count_num"
        And I assign "" to variable "ser_typ_list" 
    	While I verify number $cur_cnt_num is less than $row_count_num
        	Then I assign row $cur_cnt_num column "ser_num_typ_id" to variable "serial_num_typ_id"
			If I verify text $ser_typ_list is not equal to ""
            	Then I assign variable "ser_typ_list" by combining $ser_typ_list "," $serial_num_typ_id
			Else I assign variable "ser_typ_list" by combining $serial_num_typ_id
            EndIf
			And I increase variable "cur_cnt_num" by 1
		EndWhile
        And I echo $ser_typ_list
	Else I fail step with error message "ERROR: Failed to get serial number type IDs"
    EndIf
    
	And I unassign variables "cur_cnt,cur_cnt_num,row_count_num"
    
@wip @private
Scenario: Add Serial Numbers to ASN Inventory
#############################################################
# Description: For CRDL_TO_GRAVE and ASN Receiving,
# call MSQL to add a new serial number to the ASN.
# This is done by calling Process Host Receipt Serial Number
# inside MSQL file.
# MSQL Files:
#	ASN_add_serial_numbers.msql
# Inputs:
# 	Required:
#		prtnum - part number
#		wh_id - warehouse id
# 		client_id - client id
#		lodnum - ASN lodnum
#		catch_qty - catch quantity
#		untqty - unit quantity
#		subnum - sub number
#		dtlnum - detail number
#		untcas - unit case
#		serial_scan - serial number to add
#		serial_num_type - serial number type id
#	Optional:
#		None
# Outputs:
#	serial_num_typ_id_1 - first serial number type ID 
#	serial_num_typ_id_2 - second serial number type ID 
#############################################################

Given I "add serial numbers to the ASN"
    Then I assign $serial_scan to variable "ser_num"
    And I assign $serial_num_type to variable "ser_num_typ_id"
	And I assign "ASN_add_serial_numbers.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
	Else I fail step with error message "ERROR: Failed to add serial number for ASN Receiving"
    EndIf
    
@wip @private
Scenario: Get Detail from Lodnum
#############################################################
# Description: For CRDL_TO_GRAVE amd ASN Receiving,
# call MSQL to pull information from inventory_view
# information relative to the ASN lodnum. This information is used
# in Add Serial Numbers to ASN Inventory to add serial numbers
# to the ASN
# MSQL Files:
#	ASN_serial_number_find_detail_from_lodnum.msql
# Inputs:
# 	Required:
#   	prtnum - part number
#		wh_id - warehouse ID
#		lodnum - ASN lodnum
#	Optional:
#		None
# Outputs:
#	NOTE: the recorded rows are available for traversal and used in
#         "Add Serial Numbers for Cradle to Grave" scenario
#############################################################

Given I "get detailed information realtive to the lodnum"
	And I assign "ASN_serial_number_find_detail_from_lodnum.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
	Else I fail step with error message "ERROR: Could not get inventory information relative to the lodnum"
    EndIf

@wip @private
Scenario: Get Serial Number from Serial Number File
#############################################################
# Description: For serializations requiring access to serial numbers,
# look up list of serial numbers and cycle through that list
# until one is not used by the system and return it
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	serial_num_file - file containing serial numbers for use
#		wh_id - warehouse ID
#		lodnum - ASN lodnum
#	Optional:
#		None
# Outputs:
#	serial_scan - available serial number for use
#############################################################

Given I "open serial number file, choose line, and check to see if it's in use"
	Then I assign "0" to variable "ser_num_max_loop_counter" 
    And I assign "100" to variable "ser_num_max_numbers"
    And I convert string variable "ser_num_max_loop_counter" to integer variable "ser_num_max_loop_counter_num"
	And I convert string variable "ser_num_max_numbers" to integer variable "ser_num_max_numbers_num"
 
	Then I assign next line from $serial_num_file to variable "serial_scan"
 	And I execute scenario "Check if Serial Number is in Use"
	While I verify text $serial_number_in_use is equal to "TRUE" ignoring case
	And I verify number $ser_num_max_loop_counter_num is less than $ser_num_max_numbers_num
		Then I assign variable "message_string" by combining "Serial Number is already in use (" $serial_scan "). Trying another one"
   		And I echo $message_string
                
       	Then I assign next line from $serial_num_file to variable "serial_scan"
		And I execute scenario "Check if Serial Number is in Use"
        
        Then I increase variable "ser_num_max_loop_counter_num" by 1
	EndWhile
    
    And I "check to see if all serial numbers have been used"
    	if I verify number $ser_num_max_loop_counter_num is equal to $ser_num_max_numbers_num
    		Then I assign variable "error_string" by combining "ERROR: All serial numbers in serial number file (" $serial_num_file ") are in use. Please add more or check on ones that are in use"
    		Then I fail step with error message $error_string
		EndIf

@wip @private
Scenario: Terminal Set Serial Scan Cursor Positions
#############################################################
# Description: For CRDL_TO_GRAVE and OUTCAP_ONLY serialization
# types and screens, set locations for the cursor and column locations.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	serialization_type - CRDL_TO_GRAVE or OUTCAP_ONLY
#	Optional:
#		serialization_phase - RCV for receiving, PCK for picking
# Outputs:
# 	cursor_line - based on terminal type and serialization type, 
#				  return screen cursor line relative to input serial number location
#	cursor_column - based on terminal type and serialization type, 
#				    return location column location relative to input serial number location
#############################################################

Given I "get valid cursor positions depending on serilization type and phase"
	If I verify text $serialization_type is equal to "OUTCAP_ONLY"
		If I verify text $term_type is equal to "handheld"
			Then I assign 13 to variable "cursor_line"
			And I assign 2 to variable "cursor_column"
		Else I verify text $term_type is equal to "vehicle"
	   		And I assign 7 to variable "cursor_line"
	   		And I assign 10 to variable "cursor_column"
		EndIf
	EndIf
	
	If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
   		If I verify text $term_type is equal to "handheld"
			Then I assign 7 to variable "cursor_line"
			And I assign 2 to variable "cursor_column"
		Else I verify text $term_type is equal to "vehicle"
	   		Then I assign 5 to variable "cursor_line"
	   		And I assign 14 to variable "cursor_column"
		EndIf
	EndIf
    
    # A cradle to grave for receiving looks like an OUTCAP screen in 
    # terms of collecting serial numbers.
	If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
	And I verify text $serialization_phase is equal to "RCV"
		If I verify text $term_type is equal to "handheld"
			Then I assign 13 to variable "cursor_line"
			And I assign 2 to variable "cursor_column"
		Else I verify text $term_type is equal to "vehicle"
	   		Then I assign 7 to variable "cursor_line"
	   		And I assign 10 to variable "cursor_column"
		EndIf
	EndIf

@wip @private
Scenario: Terminal Check for Serial Capture Errors
#############################################################
# Description: Scenario will look for strings in the terminal and
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
	If I see "doesn't" in terminal within $wait_short seconds 
	And I see "conform" in terminal
		Then I fail step with error message "ERROR: Serial number entered does not match serial mask for the item and serial number type"
	ElsIf I see "Duplicate" in terminal
		Then I fail step with error message "ERROR: Duplicate serial number entered"
	ElsIf I see "Invalid" in terminal
		Then I fail step with error message "ERROR: Invalid serial number scanned"
	ElsIf I see "was already scanned" in terminal
		Then I fail step with error message "ERROR: Serial number was already scanned"
	ElsIf I see "Entry" in terminal
		Then I fail step with error message "ERROR: Serial number entry required"
	EndIf
    
@wip @private
Scenario: Create Variable cradle_to_grave_rcv_serial_file
#############################################################
# Description: For Receiving CRADE_TO_GRAVE serialization, determine and return
# the location of where the serial number files are located relative to 
# standard location base, serial number type, and optional suffix.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	serial_num_type - serial number type (i.e. CYCEA01)
#		serial_numbers_directory_location - location of serial numbers (set in Environment)
#	Optional:
#		serial_num_file_suffix - suffix to apply to serial number file
# Outputs:
# 	crdle_to_grave_rcv_serial_file - location of serial numbers files
#############################################################

Given I "create variable as file pointer to serial number file for CRDL_TO_GRAVE Receiving"
	Then I assign "verify_serial_number_type_id.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "ser_num_typ_id" to variable "serial_num_type"
	Else I fail step with error message "ERROR: Could not verify serial number type"
	EndIf
	
	If I verify variable "serial_num_file_suffix" is assigned
		Then I "include the serial_num_file_suffix in the filename to allow multiple simultaneous sessions to access their own serial lists"
			And I assign variable "crdle_to_grave_rcv_serial_file" by combining $serial_numbers_directory_location "Serial List Receive CRDL_TO_GRAVE " $serial_num_type "_" $serial_num_file_suffix ".txt"
	Else I assign variable "crdle_to_grave_rcv_serial_file" by combining $serial_numbers_directory_location "Serial List Receive CRDL_TO_GRAVE " $serial_num_type ".txt"
	EndIf

@wip @private
Scenario: Create Variable outbound_cap_serial_file
#############################################################
# Description: For OUTCAP_ONLY serialization, determine and return
# the location of where the serial number files are located relative to 
# standard location base, serial number type, and optional suffix.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	serial_num_type - serial number type (i.e. CYCEA01)
#		serial_numbers_directory_location - location of serial numbers (set in Environment)
#	Optional:
#		serial_num_file_suffix - suffix to apply to serial number file
# Outputs:
# 	outbound_cap_serial_file - location of serial numbers files
#############################################################

Given I "create variable as file pointer to serial number file for OUTCAP_ONLY Picking"
	Then I assign "verify_serial_number_type_id.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
		Then I assign row 0 column "ser_num_typ_id" to variable "serial_num_type"
	Else I fail step with error message "ERROR: Could not verify serial number type"
	EndIf
	
	If I verify variable "serial_num_file_suffix" is assigned
		Then I "include the serial_num_file_suffix in the filename to allow multiple simultaneous sessions to access their own serial lists"
			And I assign variable "outbound_cap_serial_file" by combining $serial_numbers_directory_location "Serial List Outcap " $serial_num_type "_" $serial_num_file_suffix ".txt"
	Else I assign variable "outbound_cap_serial_file" by combining $serial_numbers_directory_location "Serial List Outcap " $serial_num_type ".txt"
	EndIf

@wip @private
Scenario: Get Serial Number List for Cradle to Grave
#############################################################
# Description: For CRDLE_TO_CRAVE serialization, relative to 
# source location and part number look up information in the 
# inventory serial number table (inv_ser_num). Those results
# will be used in the Terminal Scan Serial Number Cradle to Grave Picking
# utility scenario.
# MSQL Files:
#	get_serial_number_list_for_cradle_to_grave_picking.msql
# Inputs:
# 	Required:
#   	srcloc - source location for the part
#		prtnum - part number
#		wh_id - warehouse ID
#		client_id - Client ID
#	Optional:
#		None
# Outputs:
# 	Implicitly the table results returned from this scenario
#	will be used in the Terminal Scan Serial Number Cradle to Grave Picking
#	utility scenario, but no explicit variable will be "returned"
#############################################################

When I assign "get_serial_number_list_for_cradle_to_grave_picking.msql" to variable "msql_file"
Then I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check if Serial Number is in Use
#############################################################
# Description: check the inv_ser_num table and look to see if the 
# proposed serial number is already in use
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	serial_scan - serial number scanned from serial number file
#	Optional:
#		None
# Outputs:
# 	serial_number_in_use - TRUE|FALSE if serial number if in use
#############################################################

	Given I assign $serial_scan to variable "serial_num"
	And I assign "check_if_serial_number_is_in_use.msql" to variable "msql_file"
	If I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
        And I assign "TRUE" to variable "serial_number_in_use"
	Else I assign "FALSE" to variable "serial_number_in_use"
    EndIf