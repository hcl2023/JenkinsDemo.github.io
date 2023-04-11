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
# Utility: Terminal Trailer Utilities.feature
# 
# Functional Area: Outbound Trailer
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
# 
# Description:
# This Utility stores Terminal Trailer Utility functions
# 
#  Public Scenarios:
#	- Terminal Outbound Trailer Close - Closes a trailer using the terminal
#	- Terminal Outbound Trailer Dispatch - Dispatches a trailer using the terminal
#	- Terminal Outbound Trailer Reopen - This scenario will reopen the closed Transport Equipment
#	- Validate Trailer Closed - Will validate that the trailer is closed or not
#	- Validate Trailer Dispatched - Will validate that the trailer is dispatched or not
#	- Validate Trailer Open - Will validate that the trailer is open or not
#	- Validate Trailer Reopened - Will validate that the trailer has been reopened
#
# Assumptions:
# None
#
# Notes:
# None
############################################################ 
Feature: Terminal Trailer Utilities

@wip @public
Scenario: Terminal Outbound Trailer Dispatch
#############################################################
# Description: This scenario dispatches an outbound trailer using the terminal
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
	Then I verify screen is done loading in terminal within $wait_long seconds
	Once I see "Dispatch Equip" on line 1 in terminal

Then I "enter the location"
	Once I see "Loc:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 3 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 2 column 11 in terminal
	EndIf 
    Then I enter $dock_door in terminal

Then I "handle tracking reference information"
	If I verify variable "trac_ref" is  assigned
	And I verify text $trac_ref is not equal to ""
		Then I enter $trac_ref in terminal
	Else I press keys "ENTER" in terminal
	EndIf
    
And I "handle driver's license information"
	If I verify variable "driver_lic" is assigned
	And I verify text $driver_lic is not equal to ""
		Then I enter $driver_lic in terminal
	Else I press keys "ENTER" in terminal
	EndIf
    
And I "handle driver's name information"
	If I verify variable "driver_nam" is assigned
	And I verify text $driver_nam is not equal to ""
		Then I enter $driver_nam in terminal
	Else I press keys "ENTER" in terminal
	EndIf
        
And I "verify it's ok to dispatch equipment, answer yes"
	Once I see "OK to Dispatch" in terminal
	Once I see "(Y|N)" on last line in terminal
	Then I press keys "Y" in terminal
	
@wip @public
Scenario: Terminal Outbound Trailer Close
#############################################################
# Description: This scenario closes a trailer using the terminal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		dock_door - Dock Door where tailier is being closed
#	Optional:
#		seal_num1 - Seal Number 1
#		seal_num2 - Seal Number 2
#		seal_num3 - Seal Number 3
#		seal_num4 - Seal Number 3
# Outputs:
# 	None           
#############################################################

Given I "verify I am in the Close Equip screen"
	Once I see "Close Equip" in terminal
	Once I see "Dock" in terminal  
	Once I see "Load" in terminal  
	Once I see "Car Cod" in terminal  

Then I "enter the dock door"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 3 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 20 in terminal
	EndIf 
	Then I enter $dock_door in terminal

When I "verify cursor is on the Load field and press enter to accept"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 3 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 20 in terminal
	EndIf 
	Then I press keys "ENTER" in terminal

Then I "answer No to OK to split shipment if prompted"
	If I see "OK to split shipment" in terminal within $screen_wait seconds 
		And I press keys "N" in terminal
	EndIf

Then I "enter the stop seal if prompted"
	If I see "Stop Seal" in terminal within $screen_wait seconds 
	And I see "Stop:" in terminal within $wait_short seconds 
	And I see "Seal:" in terminal within $wait_short seconds 
		And I enter "STOPSEAL" in terminal
	EndIf

Then I "enter the trailer seals"
	Once I see "Close Equip" in terminal  
	Once I see "Eq Num:" in terminal  
	Once I see "Seal 1" in terminal  
	Once I see "Seal 2" in terminal  
	Once I see "Seal 3" in terminal  
	Once I see "Seal 4" in terminal  

	Then I "am in the Seal 1 field and proceed to enter the seal numbers"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 8 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 5 column 10 in terminal
		EndIf 
		If I verify variable "seal_num1" is assigned
		And I verify text $seal_num1 is not equal to ""
			Then I enter $seal_num1 in terminal
		Else I echo "No Seal 1 to be entered"
			Then I press keys "ENTER" in terminal
		EndIf 

	Then I "am in the Seal 2 field and proceed to enter the seal numbers"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 10 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 6 column 10 in terminal
		EndIf 
		If I verify variable "seal_num2" is assigned
		And I verify text $seal_num2 is not equal to ""
			Then I enter $seal_num2 in terminal
		Else I echo "No Seal 2 to be entered"
			Then I press keys "ENTER" in terminal
		EndIf 

	Then I "am in the Seal 3 field and proceed to enter the seal numbers"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 12 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 7 column 10 in terminal
		EndIf 
		If I verify variable "seal_num3" is assigned
		And I verify text $seal_num3 is not equal to ""
			Then I enter $seal_num3 in terminal
		Else I echo "No Seal 3 to be entered"
			Then I press keys "ENTER" in terminal
		EndIf 

	Then I "am in the Seal 4 field and proceed to enter the seal numbers"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 14 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 8 column 10 in terminal
		EndIf 
		If I verify variable "seal_num4" is assigned
		And I verify text $seal_num4 is not equal to ""
			Then I enter $seal_num4 in terminal
		Else I echo "No Seal 4 to be entered"
			Then I press keys "ENTER" in terminal
		EndIf
    
Then I "perform Trailer Safety Check"
	If I see "Confirm" in terminal within $wait_med seconds 
		Then I execute scenario "Terminal Process Workflow"
	EndIf

Then I "check if paperwork is required and if printing was successful. Continue execution if paperwork is not required."
	Given I execute scenario "Check Shipping Paperwork Required Policy"     
	If I see "Not all shipments" in terminal within $screen_wait seconds 
	And I see "paperwork" in terminal within $wait_short seconds 
	And I verify text $pprwrk_req is equal to "1"
		Then I "acknowledge that paperwork has not been printed and trailer cannot be closed"
		And I assign variable "error_message" by combining "ERROR: Outbound paperwork has not been printed. Cannot close trailer"
		And I fail step with error message $error_message
	EndIf

Then I "perform Trailer Safety Check"
	If I see "Confirm" in terminal within $wait_med seconds 
		Then I execute scenario "Terminal Process Workflow"
	EndIf

Then I "return to the Close Equip Screen"
	Once I see "Close Equip" in terminal 
	Once I see "Dock" in terminal
	Once I see "Load" in terminal
	Once I see "Car Cod" in terminal

@wip @public
Scenario: Terminal Outbound Trailer Reopen 
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
	Once I see "Reopen Equip" in terminal
	Once I see "Eq Num:" in terminal  
	Once I see "Dock:" in terminal  

Then I "enter the Equipment Number"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 10 in terminal
	EndIf 
	Then I enter $trlr_id in terminal
	
And I "answer Yes to reopen closed transport equipment"
	If I see "OK To Reopen" in terminal within $screen_wait seconds 
		And I press keys "Y" in terminal
	Else I press keys "N" in terminal
	EndIf

Then I "type enter to open transport equipment"
	If I see "Equip is Open" in terminal within $screen_wait seconds 
		And I press keys "ENTER" in terminal
	EndIf

@wip @public
Scenario: Validate Trailer Reopened
#############################################################
# Description: This scenario will verify that the closed transport equipment has been re-opened
# MSQL Files:
#	validate_trailer.msql
# Inputs:
#	Required:
#		trlr_id - Trailer ID
#	Optional:
#		None
# Outputs:
#	None            
#############################################################

Given I "verify the closed transport equipment has been re-opened"
	Then I assign "validate_trailer.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "trlr_stat" to variable "trlr_stat"
		If I verify text $trlr_stat is equal to "L" ignoring case
			Then I echo "Closed transport equipment has been reopened successfully"
		Else I fail step with error message "ERROR: Closed transport equipment has not been reopened"    
		EndIf       	
	Else I fail step with error message "ERROR: validate_trailer.msql failed"
	Endif

@wip @public
Scenario: Validate Trailer Closed
#############################################################
# Description: This scenario will verify that the transport equipment has been closed or not
# MSQL Files:
#	validate_trailer_closed.msql
# Inputs:
#	Required:
#		trlr_id - Trailer ID
#	Optional:
#		None
# Outputs:
#	None            
#############################################################

Given I "verify the closed transport equipment has been closed"
	Then I assign "validate_trailer_closed.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I echo "Transport equipment has been closed successfully" 
	Else I fail step with error message "ERROR: Transport equipment has NOT been closed successfully or validate_trailer_closed.msql failed"
	Endif

@wip @public
Scenario: Validate Trailer Dispatched
#############################################################
# Description: This scenario will verify that the transport equipment has been dispatched or not
# MSQL Files:
#	validate_trailer_dispatched.msql
# Inputs:
#	Required:
#		trlr_id - Trailer ID
#	Optional:
#		None
# Outputs:
#	None            
#############################################################

Given I "verify the closed transport equipment has been dispatched"
	Then I assign "validate_trailer_dispatched.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I echo "Transport equipment has been dispatched successfully" 
	Else I fail step with error message "ERROR: Transport equipment has NOT been dispatched successfully or validate_trailer_dispatched.msql failed"
	Endif

#############################################################
# Private Scenarios:
#	Check Shipping Paperwork Required Policy - Run MSQL to read the check shipping paperwork
#	Terminal Outbound Trailer Document Entry - Enters document numbers using the terminal
#	Terminal Outbound Trailer Complete Stop - Completes an outbound stop using the terminal
#############################################################

@wip @private
Scenario: Check Shipping Paperwork Required Policy
#############################################################
# Description: 
# Run MSQL to read the check shipping paperwork required
# policy from the policy table
# MSQL Files:
#	check_shipping_paperwork_required.msql
# Inputs:
#	Required:
#		wh_id -	Warehouse Id  (wh_id)
#	Optional:
#		None
# Outputs:
# 	pprwrk_req - Paperwork Required Flag        
#############################################################

Given I assign "check_shipping_paperwork_required.msql" to variable "msql_file"
When I execute scenario "Perform MSQL Execution"
And I verify MOCA status is 0
Then I assign row 0 column "pprwrk_req" to variable "pprwrk_req"

@wip @private
Scenario: Terminal Outbound Trailer Document Entry
#############################################################
# Description: This scenario enters document numbers
# MSQL Files:
#	None
# Inputs:
#	Required:
#		term_type - Terminal type
#		bol_num - Bill of Lading number
#		pro_num - WMS Pro Num
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "check for document entry"
	If I see "Document Numbers" in terminal within $screen_wait seconds 
	And I see "BOL:" in terminal within $wait_short seconds 
	And I see "Pro" in terminal within $wait_short seconds
		Then I "enter the BOL number"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 4 column 1 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 3 column 20 in terminal
			EndIf 
			If I verify variable "bol_num" is assigned
			And I verify text $bol_num is not equal to ""
				Then I enter $bol_num in terminal
			Else I enter "12345" in terminal
			EndIf 
		
		Then I "enter the PRO number"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 6 column 1 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 5 column 20 in terminal
			EndIf 
			If I verify variable "pro_num" is assigned
			And I verify text $pro_num is not equal to ""
				Then I enter $pro_num in terminal
			Else I enter "67890" in terminal
			EndIf 
	EndIf 

@wip @private
Scenario: Terminal Outbound Trailer Complete Stop
#############################################################
# Description: This scenario completes an outbound stop
# MSQL Files:
#	None
# Inputs:
#	Required:
#		term_type - Terminal type
#		seal_num - Seal number
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "enter the seal number if prompted and complete stop"
	If I see "Complete Stop" in terminal within $screen_wait seconds 
	And I see "Stop:" in terminal within $wait_short seconds
	And I see "Seal" in terminal within $wait_short seconds
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 8 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 6 column 10 in terminal
		EndIf 
		If I verify variable "seal_num" is assigned
		And I verify text $seal_num is not equal to ""
			Then I enter $seal_num in terminal
		Else I enter "24680" in terminal
		EndIf 
		Once I see "Stop is complete" in terminal
		Once I see "Press Enter" in terminal
		Then I press keys "ENTER" in terminal
	EndIf
	
And I "do not close the equipment if prompted. We are only completing the stop."
	If I see "Complete Stop" in terminal within $screen_wait seconds 
	And I see "All stops complete" in terminal within $wait_short seconds 
	And I see "Close equip?" in terminal within $wait_short seconds 
		Then I press keys "N" in terminal
	EndIf 	
    