###########################################################
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
# Utility: Mobile Trailer Utilities.feature
# 
# Functional Area: Outbound Trailer
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Mobile
# 
# Description:
# This Utility stores Trailer Utility functions for the Mobile App
# 
#  Public Scenarios:
#	- Mobile Outbound Trailer Close - Closes a trailer using the Mobile App
#	- Mobile Outbound Trailer Dispatch - Dispatches a trailer using the Mobile App
#	- Mobile Outbound Trailer Reopen - This scenario will reopen closed transport equipment
#
# Assumptions:
# None
#
# Notes:
# None
############################################################ 
Feature: Mobile Trailer Utilities

@wip @public
Scenario: Mobile Outbound Trailer Dispatch
#############################################################
# Description: This scenario dispatches an outbound trailer using the Mobile App
# MSQL Files:
#	None
# Inputs:
#	Required:
#		dock_door - Dock Door where tailier is being dispatch
#	Optional:
#		trac_ref - tracking reference for dispatch information
#		driver_lic - drivers license for dispatch information
#		driver_nam - drivers name for dispatch information
# Outputs:
# 	None           
#############################################################

Given I "check I am on the correct screen to dispatch equipment"
	Once I see "Dispatch Equip" in element "className:appbar-title" in web browser

Then I "enter the location"
	And I assign "Location" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $dock_door in element "name:yard_loc" in web browser within $max_response seconds
	Then I press keys "ENTER" in web browser

Then I "handle tractor reference information"
	And I assign "Tractor Reference" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	If I verify variable "trac_ref" is  assigned
	And I verify text $trac_ref is not equal to ""
    	Then I type $trac_ref in element "name:tractor_ref" in web browser within $max_response seconds
	EndIf
	And I press keys "ENTER" in web browser
    
And I "handle driver's license information"
	And I assign "Driver License" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	If I verify variable "driver_lic" is assigned
	And I verify text $driver_lic is not equal to ""
		Then I type $driver_lic in element "name:driver_lic_num" in web browser within $max_response seconds
	EndIf
	And I press keys "ENTER" in web browser
    
And I "handle driver's name information"
	And I assign "Driver Name" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	If I verify variable "driver_nam" is assigned
	And I verify text $driver_nam is not equal to ""
		Then I type $driver_nam in element "name:driver_nam" in web browser within $max_response seconds
	EndIf
	And I press keys "ENTER" in web browser
        
And I "verify it's ok to dispatch equipment, answer yes"
	And I assign "OK to Dispatch" to variable "mobile_dialog_message"
	Then I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser

Once I see "Dispatch Equip" in element "className:appbar-title" in web browser
	
@wip @public
Scenario: Mobile Outbound Trailer Close
#############################################################
# Description: This scenario closes a trailer using the Mobile App
# MSQL Files:
#	None
# Inputs:
#	Required:
#		dock_door - Dock Door being closed
#	Optional:
#		seal_num1 - Seal Number 1
#		seal_num2 - Seal Number 2
#		seal_num3 - Seal Number 3
#		seal_num4 - Seal Number 3
# Outputs:
# 	None           
#############################################################

Given I "verify I am in the Close Equip screen"
	Once I see "Close Equip" in element "className:appbar-title" in web browser

Then I "enter the dock door"
	And I assign "Dock" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $dock_door in element "name:yard_loc" in web browser within $max_response seconds
	Then I press keys "ENTER" in web browser

When I "verify cursor is on the Load field and press enter to accept"
	And I assign "Load ID" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

Then I "answer No to OK to split shipment if prompted"
	And I assign "OK to split shipment" to variable "mobile_dialog_message"
	Then I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "N" in web browser
	EndIf

Then I "enter the stop seal if prompted"
	If I see "Stop Seal" in web browser within $screen_wait seconds 
	And I see "Stop:" in web browser within $wait_short seconds 
	And I see "Seal:" in web browser within $wait_short seconds 
		Then I type "STOPSEAL" in web browser
		And I press keys "ENTER" in web browser
	EndIf

Then I "enter the trailer seals"
	Once I see "Close Equip" in element "className:appbar-title" in web browser  

	Then I "am in the Seal 1 field and proceed to enter the seal numbers"
		And I assign "Transport Equipment Seal 1" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		If I verify variable "seal_num1" is assigned
		And I verify text $seal_num1 is not equal to ""
			Then I type $seal_num1 in element "name:trlr_seal1" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
		Else I echo "No Seal 1 to be entered"
			Then I press keys "ENTER" in web browser
		EndIf 

	Then I "am in the Seal 2 field and proceed to enter the seal numbers"
		And I assign "Transport Equipment Seal 2" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		If I verify variable "seal_num2" is assigned
		And I verify text $seal_num2 is not equal to ""
			Then I type $seal_num2 in element "name:trlr_seal2" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
		Else I echo "No Seal 2 to be entered"
			Then I press keys "ENTER" in web browser
		EndIf 

	Then I "am in the Seal 3 field and proceed to enter the seal numbers"
		And I assign "Transport Equipment Seal 3" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		If I verify variable "seal_num3" is assigned
		And I verify text $seal_num3 is not equal to ""
			Then I type $seal_num3 in element "name:trlr_seal3" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
		Else I echo "No Seal 3 to be entered"
			Then I press keys "ENTER" in web browser
		EndIf 

	Then I "am in the Seal 4 field and proceed to enter the seal numbers"
		And I assign "Transport Equipment Seal 4" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		If I verify variable "seal_num4" is assigned
		And I verify text $seal_num4 is not equal to ""
			Then I type $seal_num4 in element "name:trlr_seal4" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
		Else I echo "No Seal 4 to be entered"
			Then I press keys "ENTER" in web browser
		EndIf

And I "check to see if we have a workflow and process the workflow"
	If I see "Confirm Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Mobile Process Workflow"
	EndIf

Then I "check if paperwork is required and if printing was successful. Continue execution if paperwork is not required."
	Given I execute scenario "Check Shipping Paperwork Required Policy"     
	If I see "Not all shipments" in web browser within $screen_wait seconds 
	And I see "paperwork" in web browser within $wait_short seconds 
	And I verify text $pprwrk_req is equal to "1"
		Then I "acknowledge that paperwork has not been printed and trailer cannot be closed"
			And I assign variable "error_message" by combining "ERROR: Outbound paperwork has not been printed. Cannot close trailer"
			And I fail step with error message $error_message
	EndIf
    
And I "conduct trailer close workflow if seen"
	If I see "Confirm" in web browser within $wait_med seconds 
		Then I execute scenario "Mobile Process Workflow"
	EndIf

Then I "return to the Close Equip Screen"
	Once I see "Close Equip" in element "className:appbar-title" in web browser 

@wip @public
Scenario: Mobile Outbound Trailer Reopen 
#############################################################
# Description: This scenario will reopen the closed Transport Equipment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_id - Trailer ID
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "verify I am in the Reopen Equip screen"
	Once I see "Reopen Equip" in element "className:appbar-title" in web browser

Then I "enter the Equipment Number"
	And I assign "Transport Equipment Number" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $trlr_id in element "name:trlr_num" in web browser within $max_response seconds
	Then I press keys "ENTER" in web browser
    
And I "answer Yes to reopen closed transport equipment"
	Then I assign "OK To Reopen the Equip?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
	Else I type "N" in web browser
	EndIf

Then I "type enter to open transport equipment"
	And I assign "Equip is Open" to variable "mobile_dialog_message"
	Then I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	EndIf

#############################################################
# Private Scenarios:
#	Mobile Outbound Trailer Document Entry - Enters document numbers using the Mobile App
#	Mobile Outbound Trailer Complete Stop - Completes an outbound stop using the Mobile App
#############################################################

@wip @private
Scenario: Mobile Outbound Trailer Document Entry
#############################################################
# Description: This scenario enters document numbers
# MSQL Files:
#	None
# Inputs:
#	Required:
#		bol_num - Bill of Lading number
#		pro_num - WMS Pro Num
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "check for document entry"
	If I see "Document Numbers" in element "className:appbar-title" in web browser within $screen_wait seconds 
		Then I "enter the BOL number"
			And I assign "Document Number" to variable "input_field_with_focus"
			Then I execute scenario "Mobile Check for Input Focus Field"

			If I verify variable "bol_num" is assigned
			And I verify text $bol_num is not equal to ""
				Then I type $bol_num in element "name:doc_num" in web browser within $max_response seconds
			Else I type "12345" in element "name:doc_num" in web browser within $max_response seconds
			EndIf
			And I press keys "ENTER" in web browser
		
		Then I "enter the PRO number"
			And I assign "Pro Number" to variable "input_field_with_focus"
			Then I execute scenario "Mobile Check for Input Focus Field"

			If I verify variable "pro_num" is assigned
			And I verify text $pro_num is not equal to ""
				Then I type $pro_num in element "name:track_num" in web browser within $max_response seconds
			Else I type "67890" in element "name:track_num" in web browser within $max_response seconds
			EndIf
			And I press keys "ENTER" in web browser
	EndIf 

@wip @private
Scenario: Mobile Outbound Trailer Complete Stop
#############################################################
# Description: This scenario completes an outbound stop
# MSQL Files:
#	None
# Inputs:
#	Required:
#		seal_num - Seal number
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "enter the seal number if prompted and complete stop"
	If I see "Complete Stop" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I assign "Stop Seal" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"

		If I verify variable "seal_num" is assigned
		And I verify text $seal_num is not equal to ""
			Then I type $seal_num in element "name:stop_seal" in web browser within $max_response seconds
		Else I type "24680" in element "name:stop_seal" in web browser within $max_response seconds
		EndIf
		And I press keys "ENTER" in web browser

		Then I assign "Stop is complete" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		Once I see element $mobile_dialog_elt in web browser
		Then I press keys "ENTER" in web browser
	EndIf
	
And I "do not close the equipment if prompted. We are only completing the stop."
	Then I assign "All stops complete.  Close equip?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "N" in web browser
	EndIf	