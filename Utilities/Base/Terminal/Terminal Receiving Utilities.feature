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
# Utility: Terminal Receiving Utilities.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# This Utility contains common scenarios for Terminal Receiving Features
#
# Public Scenarios:
#	- Terminal Putaway Menu - Navigate to the Undirected Putwaway screen
#	- Terminal Undirected Putaway - performs undirected inbound terminal putaway
#	- Terminal LPN Receiving Menu - navigates to LPN Receiving menu
#	- Terminal LPN Reverse Receipt Menu - navigates to the Reverse Order screen
#	- Terminal Reverse Receipt - Reverses an order
#	- Terminal Process Product Putaway - Once on Putaway Screen enter putaway method and process
#   - Terminal ASN Receiving - From an opened receipt, performs ASN Receiving
# 	- Terminal Non-ASN Receiving - From an opened receipt, performs non-ASN Receiving
#	- Validate Putaway Was Successful - validates a load is at a location
#   - Terminal Receiving Without Order Menu - navigates to the Receive Without Order screen 
#	- Terminal Receiving Without Order - receives without order
#	- Terminal Unload Shipment - Process the Unload Shipment Screen
#	- Terminal Dispatch Equipment - Process the dispatch equipment receiving screen
#	- Terminal Confirm Dispatch Equipment - confirm dispatch of equipment
#	- Cancel Cycle Count - Cancel a Cycle count relative to a location
#	- Terminal Complete Receiving - complete the receiving process from the Complete Rcv screen.
#	- Terminal Trigger Product Putaway - Press F6 and move to Putaway screen
#	- Get Create Footprint Policy Flag - Read the CREATE-FOOTPRINT receiving policy
#	- Terminal ASN Receiving Non-Trusted Supplier - performs ASN Receiving for a non-trusted supplier
#	- Terminal Receiving Product Pickup Directed Work - Process Product Pickup via Directed Work after directed putaway
# 
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Terminal Receiving Utilities

@wip @public
Scenario: Terminal Receiving Product Pickup Directed Work
#############################################################
# Description: Process Product Pickup via Directed Work after directed
# putaway
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lpn - LPN of inventory being picked up and deposited after directed putaway
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "pickup directed work"
	Once I see "Pickup Product At" on line 1 in terminal
	Once I see "Press Enter To Ack" in terminal
	Then I press keys "ENTER" in terminal

And I "enter LPN"
	Once I see "Product Pickup" on line 1 in terminal
	And I enter $lpn in terminal

And I "press F6 on directed work screen to start deposit action"
	Once I see "Directed Mode" on line 1 in terminal
	Then I press keys "F6" in terminal
	And I wait $screen_wait seconds

@wip @public
Scenario: Terminal Complete Receiving
#############################################################
# Description: This scenario completes the receiving process from
# the Complete Rcv screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		yard_loc - yard location, receiving dock door
#		trlr_num - trailer number
#	Optional:
#		expect_discrepancies - should we expect descepancies when completing receive
#		complete_rcv_close_equipment - close equipment on complete receiving (default)
#		complete_rcv_close_shipment - close shipment on complete receiving
# Outputs:
# 	None  
#############################################################

Given I "navigate to the terminal receiving Complete Rcv screen"
	Then I execute scenario "Terminal Receiving Complete Receiving Menu"
    Once I see "Complete Rec" on line 1 in terminal
    
And I "enter the receiving location"
	Then I enter $yard_loc in terminal
    Once I see $yard_loc in terminal
    Once I see $trlr_num in terminal

And I "acknowkledge disrepancies (if anticipated) and complete receiving"
	Then I press keys "ENTER" in terminal
	If I verify variable "expect_discrepancies" is assigned
	And I verify text $expect_discrepancies is equal to "TRUE"
		If I see "OK to close?" in terminal within $wait_med seconds
			Once I see "(S|E|C)" in terminal

			If I verify variable "complete_rcv_close_equipment" is assigned
			And I verify text $complete_rcv_close_equipment is equal to "TRUE"
				Then I press keys "E" in terminal
			ElsIf I verify variable "complete_rcv_close_shipment" is assigned
			And I verify text $complete_rcv_close_shipment is equal to "TRUE"
				Then I press keys "S" in terminal
			Else I press keys "E" in terminal
			EndIf

			If I see "Equip successfully" in terminal within $wait_med seconds
				Then I press keys "ENTER" in terminal
			EndIf
		EndIf
    	Once I see "Discrepancies found" in terminal
		If I see "OK to close equip" in terminal within $wait_med seconds
        	Once I see "(Y|N)" in terminal
        	Then I press keys "Y" in terminal
		EndIf
		And I wait $wait_med seconds
		And I verify screen is done loading in terminal within $wait_long seconds
	EndIf
    
    And I "close equipment if asked (no discrepancies)"
		If I see "OK to close equip" in terminal within $wait_med seconds
		And I see "(Y|N)" in terminal within $wait_med seconds
			Then I press keys "Y" in terminal
			And I wait $wait_med seconds
			And I verify screen is done loading in terminal within $wait_long seconds
		ElsIf I see "OK to close?" in terminal within $wait_med seconds
			And I see "(S|E|C)" in terminal within $wait_med seconds

			If I verify variable "complete_rcv_close_equipment" is assigned
			And I verify text $complete_rcv_close_equipment is equal to "TRUE"
				Then I press keys "E" in terminal
			ElsIf I verify variable "complete_rcv_close_shipment" is assigned
			And I verify text $complete_rcv_close_shipment is equal to "TRUE"
				Then I press keys "S" in terminal
			Else I press keys "E" in terminal
			EndIf

			If I see "Equip successfully" in terminal within $wait_med seconds
				Then I press keys "ENTER" in terminal
				And I wait $wait_med seconds
				And I verify screen is done loading in terminal within $wait_long seconds
			EndIf
		EndIf

	And I "conduct equipment close workflow if seen"
		If I see "Confirm Workflow" in terminal within $wait_med seconds 
			Then I execute scenario "Terminal Process Workflow"
	EndIf

	If I see "Equip successfully" in terminal within $wait_med seconds
	And I see "closed - Press Enter" in terminal within $wait_med seconds
		Then I press keys "ENTER" in terminal
	EndIf

	Once I see "Complete Rec" on line 1 in terminal

@wip @public
Scenario: Terminal Putaway Menu
#############################################################
# Description: This scenario will navigate to the Undirected
# Putaway Screen (from the top-level undirected menu)
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	None  
#############################################################

Given I "Navigate to the Putaway Screen"
	Once I see "Receiving Menu" in terminal
	Given I type option for "Inventory Menu" menu in terminal
	If I see "Next" in terminal within $screen_wait seconds 
		And I type option for "Next" menu in terminal
	EndIf 
	Once I see "Putaway" in terminal  
	When I type option for "Putaway" menu in terminal
	Once I see "Putaway" on line 1 in terminal 
	Once I see "ID:" in terminal 

@wip @public
Scenario: Terminal Undirected Putaway
#############################################################
# Description: This scenario executes an inbound putaway through the terminal
# Assumes you are on the undirected Putaway Screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - the LPN that was deposited
#	Optional:
#		dep_loc - the deposit location
# Outputs:
# 	None  
#############################################################

Given I "Enter the Lodnum"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 12 in terminal 
	EndIf

	Then I enter $lodnum in terminal
	Once I see "Putaway" on line 1 in terminal
	Once I do not see $lodnum in terminal
	
  	Then I press keys "F6" in terminal
	If I see "Could Not Allocate" in terminal within $wait_long seconds 
		Then I press keys "ENTER" in terminal
	EndIf

Then I "Deposit the Load"
	Once I see "Deposit" on line 1 in terminal
	Once I see $lodnum in terminal
	Then I execute scenario "Terminal Deposit"
    
@wip @public
Scenario: Terminal LPN Receiving Menu
#############################################################
# Description: This scenario navigates to the LPN Receiving Menu
# from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Once I see "Undirected Menu" in terminal 
Given I type option for "Receiving Menu" menu in terminal within $wait_short seconds
Once I see "LPN Receive" in terminal
Once I see "Receiving Menu" in terminal
When I type option for "LPN Receive" menu in terminal
Once I see "Receive Product" in terminal
Once I see cursor at line 2 column 9 in terminal

@wip @public
Scenario: Terminal LPN Reverse Receipt Menu
#############################################################
# Description: This scenario navigates to the Reverse Order Menu
# from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Once I see "Receiving Menu" in terminal 
Given I type option for "Receiving Menu" menu in terminal
Once I see "Reverse Order" in terminal  
Once I see "Receiving Menu" in terminal 
When I type option for "Reverse Order" menu in terminal
Once I see "Reverse Receipt" in terminal

@wip @public
Scenario: Terminal Reverse Receipt
#############################################################
# Description: This scenario reverses an order given a load number.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	lodnum - the load to reverse
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Once I see "Reverse Receipt" in terminal
Given I enter $lodnum in terminal
Once I see "OK To Reverse?" in terminal 
Then I enter "Y" in terminal

@wip @public
Scenario: Validate Putaway Was Successful
#############################################################
# Description: This scenario verifies that a given lodnum is in
# the expected location after depositing.
# MSQL Files:
#	validate_inventory_location_by_lodnum.msql
# Inputs:
#	Required:
#		lodnum - the LPN that was deposited
#		dep_loc - the location where the lodnum was deposited
#	Optional:
#		None
# Outputs:
# 	error_message - string containing the error message        
#############################################################

Given I "Validate the Load Was Deposited"
	Given I assign $dep_loc to variable "validate_dstloc"
    And I assign $lodnum to variable "validate_lodnum"
	And I assign "validate_inventory_location_by_lodnum.msql" to variable "msql_file"
	If I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
		Then I echo "Lodnum " $lodnum " found in the expected location!"
	Else I assign variable "error_message" by combining "ERROR: lodnum " $lodnum " not found in expected location " $dep_loc
		Then I fail step with error message $error_message
	EndIf

Then I "unassign validation input variables"
	Given I unassign variables "validate_dstloc,validate_lodnum"
    
@wip @public
Scenario: Terminal ASN Receiving
#############################################################
# Description: From an opened receipt, performs ASN Receiving.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		asn_lodnum - The ASN Load to receive
#		prtnum - The part being received
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "input the load"
	Then I execute scenario "Terminal Receiving Input Load"

And I "process inventory approaching expiration"
	If I see $prtnum in terminal within $screen_wait seconds 
	And I see $asn_lodnum in terminal within $screen_wait seconds 
	And I see "expire" in terminal within $screen_wait seconds 
		Then I press keys "ENTER" in terminal
	EndIf

	If I see "OK to continue" in terminal within $screen_wait seconds 
	And I see "receiving" in terminal within $screen_wait seconds 
		Then I type "Y" in terminal
	EndIf

And I "process serialization if required/configured"
	Then I verify screen is done loading in terminal within $max_response seconds
	If I see "Validate ASN Serial" on line 1 in terminal within $wait_med seconds
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Terminal Validate ASN Serial Number Cradle to Grave Receiving"
		ElsIf I verify text $serialization_type is equal to "OUTCAP_ONLY"
        Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type cannot be determined"
        EndIf
    EndIf

And I "answer the any more to receive question"
	If I see "Any More To Receive" in terminal within $wait_short seconds
		If I verify text $receive_more_flag is equal to "TRUE"
        	Then I type "Y" in terminal
        Else I type "N" in terminal
        EndIf
	EndIf
    
And I "enter pass error producing pallet label message"
	If I see "Error Producing" in terminal within $wait_short seconds
        Then I press keys "Enter" in terminal
	EndIf 

@wip @public
Scenario: Terminal Non-ASN Receiving
#############################################################
# Description: From an opened receipt, performs non-ASN Receiving.
# MSQL Files: 
# 	check_3pl.msql
#	check_confirm_create.msql
#   check_lodlvl.msql
# Inputs:
# 	Required:
#   	rcv_qty - the number to receive 
#		prtnum - the part to receive
#	Optional:
#		lpn - the load to associate the received goods with, if not populated, will be auto-generated
#		rcv_prtnum - a prtnum to test blind receiving
#		lotnum - a Lot Number to associate with the received prtnum if lot enabled
#		receive_more_flag - TRUE/FALSE determine if screen press Y/N to possible "Receive More" prompts (Def:FALSE)
#		revlvl - revision level
# Outputs:
#     None
#############################################################

When I "fill in the Load Number field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 6 in terminal 
	EndIf 

	If I verify variable "lpn" is assigned
	And I verify text $lpn is not equal to ""
		Then I enter $lpn in terminal
	Else I "generate a new Load Number"
		Then I press keys "F3" in terminal
		And I press keys "ENTER" in terminal
	EndIf

And I "see if we have the same LPN already, the system will error. Check for this and error the script."
	If I see "Load exists in" in terminal within $wait_med seconds 
		Then I fail step with error message "ERROR: Lodnum Already Exists In The System"
	EndIf

And I "fill in the Part Number field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 6 in terminal 
	EndIf  
	
	And I "may want to test blind parts so I set that in my override variables and use it here"
		If I verify variable "rcv_prtnum" is assigned
		And I verify text $rcv_prtnum is not equal to ""
			Then I enter $rcv_prtnum in terminal
		Else I enter $prtnum in terminal
		EndIf 

And I "handle the Client field"
	Given I "check if this environment is multi-client enabled"
		Then I assign "check_3pl.msql" to variable "msql_file"
		And I execute scenario "Perform MSQL Execution"
		If I verify MOCA status is 0
			Then I assign row 0 column "installed" to variable "installed"
		Else I fail step with error message "ERROR: Could not determine if environment is multi-client enabled"
        Endif

	If I verify number $installed is equal to 1
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 7 column 6 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 4 column 28 in terminal 
		EndIf 
		And I press keys "ENTER" in terminal
	EndIf

And I "check for pallet tracking/HU"
	If I see "Handling Unit" in terminal within $wait_med seconds 
		Then I "confirm the HU Type is 'CHEP'"
			And I press keys "ENTER" in terminal
		And I "confirm the client_id is correct"
			And I press keys "ENTER" in terminal
	EndIf

And I "process see blind not allowed"
	If I see "Item Not On Order" in terminal within $wait_med seconds 
		Then I "have entered a part not on this Inbound Shipment"
		  	And I press keys "ENTER" in terminal
		And I fail step with error message "ERROR: Blind receiving is not allowed"
	EndIf 

And I "process see blind allowed"
	If I see "Item is unexpected" in terminal within $wait_med seconds 
		Then I "have entered a part not on this Inbound Shipment"
			And I type "y" in terminal
			And I "continue as blind receiving is allowed"
	EndIf 

And I "process lot"
	Given I execute scenario "Terminal Receiving Process Lot"

And I "process units per case"
	Given I execute scenario "Get Create Footprint Policy Flag"
    If I verify text $create_footprint_flag is equal to "TRUE"
        If I verify text $term_type is equal to "handheld"
            Once I see cursor at line 11 column 6 in terminal
        Else I verify text $term_type is equal to "vehicle"
            Once I see cursor at line 6 column 22 in terminal 
        EndIf 
        Then I press keys "ENTER" in terminal
    EndIf

And I "process rcv qty"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 8 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 8 in terminal 
	EndIf 
	Then I enter $rcv_qty in terminal

And I "process over receipt"
	Given I execute scenario "Terminal Receiving Process Over Receipt"

And I "process UOM"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 17 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 18 in terminal 
	EndIf 
    If I verify variable "rcv_uom" is assigned
    And I verify text $rcv_uom is not equal to ""
    	Then I execute scenario "Terminal Clear Field"
    	And I enter $rcv_uom in terminal
    Else I press keys "ENTER" in terminal
	EndIf

And I "check if part has an aging profile"
	Given I execute scenario "Terminal Receiving Process Aging Profile"

And I "process status"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 14 column 16 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 37 in terminal  
	EndIf

	If I verify variable "qa_sts" is assigned
	And I verify text $qa_sts is not equal to ""
        Then I execute scenario "Terminal Clear Field"
		And I enter $qa_sts in terminal
	ElsIf I verify variable "age_profile" is assigned
	And I verify text $age_profile is equal to "x"
		Then I enter $ap_sts in terminal
		If I see "aging" in terminal within $wait_med seconds 
		And I see "Continue" in terminal within $wait_med seconds 
			Then I type "C" in terminal
		EndIf 
	Else I enter $rcvsts in terminal
	EndIf 

And I "process manufacturing date"	
	Then I execute scenario "Terminal Receiving Process Manufacturing Date"

And I "process subload and detail level receiving"
    Then I assign "check_lodlvl.msql" to variable "msql_file"
    When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
        Then I assign row 0 column "lodlvl" to variable "load_level"
    Else I fail step with error message "ERROR: failed check of load level"
    EndIf
    If I verify text $load_level is not equal to "L"
        If I see "Identify Sub-LPN" in terminal within $wait_long seconds
            Then I execute scenario "Terminal Process Subload Receiving"
        EndIf
    EndIf

And I "process revision level"
	If I verify variable "revlvl" is assigned
	And I verify text $revlvl is not equal to ""
		Once I see "Rev:" in terminal
		Then I enter $revlvl in terminal
	EndIf

And I "process create inventory"
	Given I assign "check_confirm_create.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Once I see "OK To Create" in terminal 
		And I type "Y" in terminal
	Endif
    
And I "wait for inventory creation processing" which can take between $wait_long seconds and $max_response seconds 
    
And I "process serialization if required/configured"
	Then I verify screen is done loading in terminal within $max_response seconds
	If I see "Serial Numb" on line 1 in terminal within $wait_short seconds 
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Terminal Scan Serial Number Cradle to Grave Receiving"
		ElsIf I verify text $serialization_type is equal to "OUTCAP_ONLY"
        Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type cannot be determined"
        EndIf
    EndIf

And I "answer the any more to receive question"
	If I see "Any More To Receive" in terminal within $wait_short seconds
		If I verify text $receive_more_flag is equal to "TRUE"
			Then I type "Y" in terminal
		Else I type "N" in terminal
		EndIf
	EndIf

And I "enter pass error producing pallet label message"
	If I see "Error Producing" in terminal within $wait_short seconds
		Then I press keys "Enter" in terminal
	EndIf

@wip @public
Scenario: Terminal ASN Receiving Non-Trusted Supplier
#############################################################
# Description: From an opened receipt, performs ASN Receiving for a non-trusted supplier
# MSQL Files:
#	check_3pl.msql
# Inputs:
# 	Required:
#   	rcv_qty - the number to receive 
#		prtnum - the part to receive
#		asn_lodnum - the load number associated to the ASN
#	Optional:
#		rcv_prtnum - the prtnum to be changed on the ASN LPN.
#   	rcv_chg_sts - Valid Inv Status, if the inventory status needs to be changed on receipt
#   	rcv_qty - quantity to receive, if quantity needs to be changed on receipt
#		rcv_uom - receieve unit of measure
#		chg_qty - flag that prompts recieve quantity to be overriden, if receive quantity needs to be changed upon receipt
#		chg_uom - flag that prompts uom to be overriden, if unit of measure needs to be changed on receipt
#		chg_sts - flag that prompts invsts to be overriden, if the inventory status needs to be changed on receipt
#		lotnum - a Lot Number to associate with the received prtnum if lot enabled
#		ap_sts - Valid Aging profile status, if the part has an aging profile
#		expqty - The number expected- to be inputted as receive quantity
# Outputs:
#     None
#############################################################

Given I "input the load"
	Then I execute scenario "Terminal Receiving Input Load"

And I "should expect the cursor to be in the part number field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 6 in terminal 
	EndIf  

And I "validate ASN Screen is pre-populated with item number and ASN LPN"
	If I see $prtnum on line 6 in terminal within $screen_wait seconds 
	And I see $asn_lodnum on line 3 in terminal within $screen_wait seconds 
	And I see "expire" in terminal within $screen_wait seconds 
		Then I press keys "ENTER" in terminal
	EndIf

And I "cannot change item number on an ASN, so I enter the item number on the ASN"
	Then I enter $prtnum in terminal
	And I wait $screen_wait seconds

And I "am not changing client ID and entering through client ID field"
	Given I "check if this environment is multi-client enabled"
		Then I assign "check_3pl.msql" to variable "msql_file"
		And I execute scenario "Perform MSQL Execution"
		If I verify MOCA status is 0
			Then I assign row 0 column "installed" to variable "installed"
		Else I fail step with error message "ERROR: Could not determine if environment is multi-client enabled"
        Endif

	If I verify number $installed is equal to 1
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 7 column 6 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 4 column 28 in terminal 
		EndIf 
		And I press keys "ENTER" in terminal
	EndIf

And I "process lot"
	Given I execute scenario "Terminal Receiving Process Lot"

And I "process rcv qty"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 8 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 8 in terminal 
	EndIf 
    
    And I "may want to change rcv qty for non trusted ASN"
		If I verify text $chg_qty is equal to "TRUE"
			Then I enter $rcv_qty in terminal
		Else I press keys "ENTER" in terminal
		EndIf

And I "process over receipt"
	Given I execute scenario "Terminal Receiving Process Over Receipt"

And I "process UOM"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 17 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 18 in terminal 
	EndIf 
    And I "may want to change rcv uom on the non trusted ASN"
    	If I verify text $chg_uom is equal to "TRUE"
    		Then I enter $rcv_uom in terminal
		Else I press keys "ENTER" in terminal
    	EndIf

And I "check if part has an aging profile"
	Given I execute scenario "Terminal Receiving Process Aging Profile"

And I "process status"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 14 column 16 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 37 in terminal  
	EndIf

And I "may want to change inventory status"
	If I verify text $chg_sts is equal to "TRUE"
	And I verify variable "rcv_chg_sts" is assigned
	And I verify text $rcv_chg_sts is not equal to ""
		Then I enter $rcv_chg_sts in terminal
	ElsIf I verify variable "age_profile" is assigned
	And I verify text $age_profile is equal to "x"
		Then I enter $ap_sts in terminal
		If I see "aging" in terminal within $wait_med seconds 
		And I see "Continue" in terminal within $wait_med seconds 
			Then I type "C" in terminal
		EndIf 
	Else I enter $rcvsts in terminal
	EndIf 

And I "process manufacturing date"
	Given I execute scenario "Terminal Receiving Process Manufacturing Date"

And I "process serialization if required/configured"
	Then I verify screen is done loading in terminal within $max_response seconds
	If I see "Validate ASN Serial" on line 1 in terminal within $wait_med seconds
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Terminal Validate ASN Serial Number Cradle to Grave Receiving"
		ElsIf I verify text $serialization_type is equal to "OUTCAP_ONLY"
        Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type cannot be determined"
        EndIf
    EndIf

And I "answer the any more to receive question"
	If I see "Any More To Receive" in terminal within $wait_short seconds
		If I verify text $receive_more_flag is equal to "TRUE"
			Then I type "Y" in terminal
		Else I type "N" in terminal
		EndIf
	EndIf
    
And I "enter pass error producing pallet label message"
	If I see "Error Producing" in terminal within $wait_short seconds
		Then I press keys "Enter" in terminal
	EndIf 

@wip @public
Scenario: Terminal Unload Shipment
#############################################################
# Description: Process the Unload shipment screen for reveiving.
# On completion transition to confirmation of trailer workflow.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		yard_loc - Receiving door
#		rec_loc - Location to receive shipment to
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "check I am on the correct screen and enter the dock door information"
	Then I verify screen is done loading in terminal within $wait_long seconds
	Once I see "Unload Ship" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 12 in terminal 
	EndIf 
	And I enter $yard_loc in terminal
    
And I "enter the destination location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 12 in terminal 
	EndIf 
	And I enter $rec_loc in terminal

And I "verify it's ok to unload the shipment, answer yes and transition to workflow"
	Once I see "OK To Unload" in terminal
    Once I see "(Y|N)" on last line in terminal
    Then I press keys "Y" in terminal
    #Once I see "Confirm Workflow" in terminal
    
@wip @public
Scenario: Terminal Dispatch Equipment
#############################################################
# Description: Process the dispatch equipment screen.
# On completion confirm the dispatch operation.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		trac_ref - tracking reference information
#		driver_lic  - drivers license information
#		driver_nam - drivers name information
# Outputs:
#     None
#############################################################

Given I "check I am on the correct screen to dispatch equipment"
	Then I verify screen is done loading in terminal within $wait_long seconds
	Once I see "Dispatch Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 3 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 11 in terminal 
	EndIf

    Given I "handle tracking reference information"
    	If I verify variable "trac_ref" is  assigned
    	And I verify text $trac_ref is not equal to ""
    		Then I enter $trac_ref in terminal
    	Else I press keys "ENTER" in terminal
    	EndIf
    
    Given I "handle driver's license information"
    	If I verify variable "driver_lic" is  assigned
    	And I verify text $driver_lic is not equal to ""
    		Then I enter $driver_lic in terminal
      Else I press keys "ENTER" in terminal
      EndIf
    
	Given I "handle driver's name information"
    	If I verify variable "driver_nam" is  assigned
    	And I verify text $driver_nam is not equal to ""
    		Then I enter $driver_nam in terminal
    	Else I press keys "ENTER" in terminal
    	EndIf

    And I "verify it's ok to dispatch equipment, answer yes"
		Then I execute scenario "Terminal Confirm Dispatch Equipment"
    
    And I "return to Unload Shipment Screen"
    	Once I see "Unload Ship" in terminal
        
@wip @public
Scenario: Terminal Confirm Dispatch Equipment
#############################################################
# Description: Answer Y to dispatch question.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

And I "verify it's ok to dispatch equipment, answer yes"
	Once I see "OK to Dispatch" in terminal
    Once I see "(Y|N)" on last line in terminal
    Then I press keys "Y" in terminal

@wip @public
Scenario: Cancel Cycle Count
#############################################################
# Description: Cancel a Cycle Count relative to a location
# MSQL Files:
#	cancel_cycle_count.msql
# Inputs:
#	Required:
#		count_location - location where you want count canceled
#		wh_id - warehouse id
#	Optional:
#		None
# Outputs:
#	None
##############################################################

Given I "cancel a cycle count"
	Then I assign "cancel_cycle_count.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	Else I assign variable "error_message" by combining "ERROR: Count not cancel cycle count at location: " $count_location
		Then I fail step with error message $error_message
	EndIf

@wip @public
Scenario: Terminal Trigger Product Putaway
#############################################################
# Description: Press F6 and move to the Product Putaway Screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	None
#	Optional:
#		None
# Outputs:
#     None
#############################################################
    
Given I "initiate a Product Putaway"
	If I see "Product Putaway" in terminal within $screen_wait seconds 
		Then I "have reached my vehicle load limit and will not need an F6"
	Else I "will need to trigger a deposit"
		Once I see "Receive Product" in terminal
		Then I press keys "F6" in terminal
        And I wait $wait_med seconds
		While I see "Processing Request" in terminal within $screen_wait seconds 
			Then I echo "Processing Request"
			And I wait $screen_wait seconds 
		EndWhile
	EndIf
	
@wip @public
Scenario: Terminal Receiving Without Order Menu 
########################################################################
# Description: This scenario navigates to the Receive Without Order Menu from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		None
# Outputs:
#     None
########################################################################

Once I see "Receiving Menu" in terminal 
Given I type option for "Receiving Menu" menu in terminal
Once I see "LPN Receive" in terminal
And I see "Next" in terminal  
Then I type option for "Next" menu in terminal
Once I see "Rcv w/o Order" in terminal
Once I see "Receiving Menu" in terminal 
When I type option for "Rcv w/o Order" menu in terminal
Once I see "Rcv w/o Order" in terminal

@wip @public
Scenario: Terminal Receiving Without Order
#############################################################
# Description: Terminal Receiving Without Order.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	rec_quantity - the quantity to be receive 
#		lodnum - the load to associate the received goods with
#		prtnum - the part to receive
#	    reason - reason for receiveing
#		status - a valid inventory status
#	    putaway_method - 1 is Directed, 2 is Sorted, 3 is Undirected.
#		deposit_loc - If it is Storage location provide:storage_loc
#					- Else for Receive Stage location provide:rec_loc	
#	Optional:
#		None
# Outputs:
#     None
#############################################################

When I "fill in the Client ID field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 2 column 10 in terminal within $max_response seconds 
	EndIf  
    Then I enter $client_id in terminal
	
And I "fill in the Load Number field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 4 column 10 in terminal within $max_response seconds 
	EndIf 
	If I verify variable "lodnum" is assigned
	And I verify text $lodnum is not equal to ""
		Then I enter $lodnum in terminal
	EndIf

And I "see if we have the same lodnum already, the system will error.  Check for this and error the script."
	If I see "Load exists in" in terminal within $wait_med seconds 
		Then I fail step with error message "ERROR: lodnum already exists in the system"
	EndIf

And I "enter the partnumber which should be received"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 5 column 10 in terminal within $max_response seconds 
	EndIf  
	If I verify variable "prtnum" is assigned
	And I verify text $prtnum is not equal to ""
		Then I enter $prtnum in terminal
	EndIf 
		
And I "fill in the U/C field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 6 column 10 in terminal within $max_response seconds 
	EndIf 
	Then I press keys "ENTER" in Terminal
			
And I "fill in the Receive Quantity field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 8 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 7 column 12 in terminal within $max_response seconds 
	EndIf 
	Then I enter $rec_quantity in terminal
	And I press keys "ENTER" in Terminal

And I "fill in the Status Field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 7 column 26 in terminal within $max_response seconds 
	EndIf 
	If I verify variable "status" is assigned
	And I verify text $status is not equal to ""
		Then I enter $status in terminal
	EndIf

And I "fill Rcv w/o Ord Ref"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 5 column 10 in terminal within $max_response seconds 
	EndIf 
	And I press keys "ENTER" in terminal 2 times with 2 seconds delay
	
And I "fill reason code"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 7 column 10 in terminal within $max_response seconds 
	EndIf 
	If I verify variable "reason" is assigned
		Then I verify text $reason is not equal to ""
		And I enter $reason in terminal
	EndIf

And I "create Inventory"
	If I see "OK To Create" in terminal within $wait_med seconds 
		Then I press keys "Y" in terminal
	Else I see "Invalid Response" in terminal within $wait_med seconds 
		Then I press keys "ENTER" in terminal
		And I fail step with error message "ERROR: lodnum already exists in the system"
	EndIf 

Then I "select The deposit location"
	If I verify text $deposit_loc is equal to "rec_loc"
    	Then I assign $rec_loc to variable "dep_loc"
    	And I echo $dep_loc
    Else I verify text $deposit_loc is equal to "storage_loc"
    	Then I assign $storage_loc to variable "dep_loc"
    	And I echo $dep_loc
	EndIf

Then I "initiate Putaway"
	If I see "Product Putaway" in terminal within $screen_wait seconds 
		Then I "have reached my vehicle load limit and will not need an F6"
	Else I "will need to trigger deposit"
		Once I see "Rcv w/o Order" in terminal
		Then I press keys "F6" in terminal
		While I see "Product Putaway" in terminal within $screen_wait seconds 
			Then I "choose Putaway Method"
				Once I see "Product Putaway" in terminal
				Then I type $putaway_method in terminal	
			And I "deposit the load"
				Then I execute scenario "Terminal Deposit"
		EndWhile 
	EndIf

@wip @public
Scenario: Get Create Footprint Policy Flag
#############################################################
# Description: Get Create Footprint Policy 
# MSQL Files: 
# 	list_policy_data.msql
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#     create_footprint_flag - Policy value
#############################################################

Given I "assign policy values"
    Given I assign "IDENTIFY" to variable "polcod"
    And I assign "MISCELLANEOUS" to variable "polvar"
    And I assign "CREATE-FOOTPRINT" to variable "polval"

When I "run the command"
    Given I assign "list_policy_data.msql" to variable "msql_file"
    Then I execute scenario "Perform MSQL Execution"

Then I "set the return value"
    Given I verify MOCA status is 0
    Then I assign row 0 column "rtnum1" to variable "create_footprint_flag"
    If I verify "1" in row 0 column "rtnum1" in result set
        Then I assign "TRUE" to variable "create_footprint_flag"
    Else I assign "FALSE" to variable "create_footprint_flag"
    EndIf
    
Then I "unassign policy variables"
	Given I unassign variables "polcod,polvar,polval"

@wip @public
Scenario: Terminal Process Product Putaway
#############################################################
# Description: From Product Putaway Screen, input the putaway method
# and process responses
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	putaway_method - 1 is Directed, 2 is Sorted, 3 is Undirected
#	Optional:
#		None
# Outputs:
#     None
#############################################################

	Once I see "Product Putaway" in terminal
	Then I type $putaway_method in terminal

	And I "address allocation failure, if necessary"
	If I see "Could Not Allocate" in terminal within $screen_wait seconds 
		Then I press keys "ENTER" in terminal
	EndIf

#############################################################
# Private Scenarios:
#	Terminal Receiving Process Manufacturing Date - check to see if the part has an aging profile defined
#	Terminal Receiving Process Aging Profile - check to see if the part has an aging profile and handle manufacturing date
#	Terminal Process Subload Receiving - From Product Putaway Screen, input the putaway method and process responses
#	Terminal Process Detail Receiving - Process the capture of detail lpns 
#	Generate Subload LPN for Receiving - Generate a subload LPN for receiving functions
#	Generate Detail LPN for Receiving - Generate Detail LPN for Receiving
#	Terminal Receiving Process Lot - Input lot number if required during Mobile receiving
#	Terminal Receiving Input Load - Input asn load number in the receiving screen
#	Terminal Receiving Process Over Receipt - Process Terminal over-receipt error message
#############################################################

@wip @private
Scenario: Terminal Receiving Input Load
#############################################################
# Description: Input asn load number in the receiving screen
# MSQL Files:
#	None
# Inputs:
# 	Required: asn_lodnum - load number to be input in the receiving screen
#   	None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "input the load"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 6 in terminal 
	EndIf 
	And I enter $asn_lodnum in terminal
        
@wip @private
Scenario: Terminal Receiving Process Lot
#############################################################
# Description: Input lot number if required during terminal receiving
# MSQL Files:
#	check_lot.msql
# Inputs:
# 	Required: 
#		lotnum - lot number to be inputted if part is lot enabled. 
#   	prtnum - part number to check lot on
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "check if this part is lot enabled"
	Then I assign "check_lot.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	And I assign row 0 column "lotflg" to variable "lotflg"
		If I verify number $lotflg is equal to 1
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 9 column 6 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 6 column 6 in terminal 
			EndIf 
			Then I enter $lotnum in terminal
		Endif
	Else I fail step with error message "ERROR: Failed check to see if part was lot enabled"
	Endif
    
@wip @private
Scenario: Terminal Receiving Process Over Receipt
#############################################################
# Description: Process Terminal over-receipt error message
# MSQL Files:
#	None
# Inputs:
# 	Required: 
#   	None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

If I see "Over-receipt" in terminal within $screen_wait seconds 
	And I see "is not" in terminal within $screen_wait seconds 
	And I see "allowed" in terminal within $screen_wait seconds 
		Then I "have entered too much quantity"
			And I press keys "ENTER" in terminal
		And I fail step with error message "ERROR: Over Receiving is not allowed"
	EndIf 


@wip @private
Scenario: Terminal Receiving Process Manufacturing Date
#############################################################
# Description: Check to see if the part has an aging profile defined, and 
# handle manufacturing date and default status accordingly.
# MSQL Files:
#	None
# Inputs:
# 	Required: 
#   	age_profile - age profile
#	Optional:
#		None
# Outputs:
#     None
#############################################################

If I verify variable "age_profile" is assigned
And I verify text $age_profile is equal to "x"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 15 column 10 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 31 in terminal 
	EndIf 
	And I press keys "ENTER" in terminal

	If I see "default status" in terminal within $screen_wait seconds 
	And I see "manufacturing" in terminal within $screen_wait seconds 
		Then I type "C" in terminal
	EndIf 
EndIf

@wip @private
Scenario: Terminal Receiving Process Aging Profile
#############################################################
# Description: Check to see if the part has an aging profile defined, and handle accordingly.
# MSQL Files:
#	check_aging.msql
# Inputs:
# 	Required: 
#   	prtnum - part number
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "check if this part has an aging profile"
	Then I assign "check_aging.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "age_profile" to variable "age_profile"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 14 column 5 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 8 column 28 in terminal 
		EndIf 
		And I press keys "ENTER" in terminal
	EndIf

@wip @private   
Scenario: Terminal Process Subload Receiving
#############################################################
# Description: Process the capture of sub lpns
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "set the cursor positions"
	If I verify text $term_type is equal to "handheld"
		Then I assign 11 to variable "sub_line"
        And I assign 1 to variable "sub_column"
	Else I verify text $term_type is equal to "vehicle"
		Then I assign 7 to variable "sub_line"
        And I assign 17 to variable "sub_column"
	EndIf 
     
Then I "capture all the subload LPNs"
    While I see "Identify Sub-LPN" in terminal within $screen_wait seconds
    And I see cursor at line $sub_line column $sub_column in terminal within $screen_wait seconds      
        Then I execute scenario "Generate Subload LPN for Receiving"
        And I enter $subload_lpn in terminal
        If I see "Identify Dtl LPN" in terminal within $screen_wait seconds
    		Then I execute scenario "Terminal Process Detail Receiving"
     	EndIf
	EndWhile    
    
Then I "perform cleanup"
	Given I unassign variables "sub_line,sub_column,subload_lpn"  
    
@wip @private    
Scenario: Terminal Process Detail Receiving
#############################################################
# Description: Process the capture of detail lpns
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "set the cursor positions"
	If I verify text $term_type is equal to "handheld"
		Then I assign 13 to variable "dtl_line"
        And I assign 1 to variable "dtl_column"
	Else I verify text $term_type is equal to "vehicle"
		Then I assign 7 to variable "dtl_line"
        And I assign 17 to variable "dtl_column"
	EndIf 

When I "capture all the detail LPNs"
	Then I "verify the screen has loaded"
		And I verify screen is done loading in terminal within $max_response seconds

    While I do not see "Subload Is Complete" in terminal
    And I see "Identify Dtl LPN" in terminal within $wait_med seconds
    And I see cursor at line $dtl_line column $dtl_column in terminal within $wait_med seconds
        Then I execute scenario "Generate Detail LPN for Receiving"
        And I enter $detail_lpn in terminal
        And I wait $wait_short seconds
        
		Then I "verify the screen has loaded"
			And I verify screen is done loading in terminal within $max_response seconds
    EndWhile
    
Then I "confirm the completion of the carton"
	Given I see "Subload Is Complete" in terminal within $screen_wait seconds
	Then I press keys "ENTER" in terminal
    
Then I "perform cleanup"
	Given I unassign variables "dtl_line,dtl_column,detail_lpn"
    
@wip @private
Scenario: Generate Subload LPN for Receiving
#############################################################
# Description: Generate a subload LPN for receiving functions
# MSQL Files: 
# 	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#     subload_lpn - detail lpn for receiving
#############################################################  

Given I assign next value from sequence "subnum" to "subload_lpn"

@wip @private
Scenario: Generate Detail LPN for Receiving
#############################################################
# Description: Generate a subload LPN for receiving functions
# MSQL Files: 
# 	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#     detail_lpn - detail lpn for receiving
#############################################################

Given I assign next value from sequence "dtlnum" to "detail_lpn"