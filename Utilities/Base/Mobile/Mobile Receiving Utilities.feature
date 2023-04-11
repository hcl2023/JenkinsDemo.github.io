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
# Utility: Mobile Receiving Utilities.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description:
# This Utility contains common scenarios for Mobile Receiving Features
#
# Public Scenarios:
#	- Mobile Undirected Putaway - performs undirected inbound mobile putaway
#	- Mobile Reverse Receipt - Reverses an order
#	- Mobile Process Product Putaway - Once on Putaway Screen enter putaway method and process
#   - Mobile ASN Receiving - From an opened receipt, performs ASN Receiving
# 	- Mobile Non-ASN Receiving - From an opened receipt, performs non-ASN Receiving
#	- Mobile Receiving Without Order - receives without order
#	- Mobile Unload Shipment - Process the Unload Shipment Screen
#	- Mobile Dispatch Equipment - Process the dispatch equipment receiving screen
#	- Mobile Confirm Dispatch Equipment - condfirm dispatch of equipment
#	- Mobile Complete Receiving - complete the receiving process from the Complete Rcv screen.
#	- Mobile Trigger Product Putaway - Press F6 and move to Putaway screen
#	- Mobile ASN Receiving Non-Trusted Supplier - performs ASN Receiving for a non-trusted supplier
#	- Mobile Enter Receive ID - This scenario enters the receive ID on the Receive Product Screen
#	- Mobile Receiving Product Pickup Directed Work - Process Product Pickup via Directed Work after directed putaway
# 
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Mobile Receiving Utilities

@wip @public
Scenario: Mobile Receiving Product Pickup Directed Work
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
	Once I see "Pickup Product At" in element "className:appbar-title" in web browser
	Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser 
	Then I press keys "ENTER" in web browser

And I "enter LPN"
	Once I see "Product Pickup" in element "className:appbar-title" in web browser
	And I type $lpn in element "name:lodnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "press F6 on directed work screen to start deposit action"
	Once I see "Directed Mode" in element "className:appbar-title" in web browser
	Then I press keys "F6" in web browser
	And I wait $wait_med seconds

@wip @public
Scenario: Mobile Enter Receive ID	
#############################################################
# Description: This scenario enters the receive ID on the 
# Receive Product Screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trknum - receiving truck/ID
#	Optional:
#		None
# Outputs:
# 	None  
#############################################################

Given I "enter the receive ID"
	Once I see "Receive Product" in element "className:appbar-title" in web browser
	Then I type $trknum in element "name:rcv_id" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

@wip @public
Scenario: Mobile Complete Receiving
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

Given I "navigate to the receiving Complete Rcv screen"
	Then I execute scenario "Mobile Complete Receiving Menu"
	Once I see "Complete Receiving" in element "className:appbar-title" in web browser
    
And I "enter the receiving location"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $yard_loc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

   	Then I assign "Inbound Shipment ID" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

And I "process OK to close/equip/cancel screen for 2020+ WMS"
	Then I assign "OK to close? S-Shipment|E-Equip C-Cancel" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		if I verify variable "complete_rcv_close_equipment" is assigned
		And I verify text $complete_rcv_close_equipment is equal to "TRUE"
			Then I press keys "E" in web browser
		ElsIf I verify variable "complete_rcv_close_shipment" is assigned
		And I verify text $complete_rcv_close_shipment is equal to "TRUE"
        	Then I press keys "S" in web browser
		Else I press keys "E" in web browser
		EndIf
		And I wait $wait_med seconds
	EndIf

And I "acknowkledge disrepancies (if anticipated) and complete receiving"
	if I verify variable "expect_discrepancies" is assigned
	And I verify text $expect_discrepancies is equal to "TRUE"
		Then I assign "Discrepancies found. OK to close" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "Y" in web browser
			And I wait $screen_wait seconds
		EndIf
	EndIf
    
And I "close equipment if asked (no discrepancies)"
	Then I assign "OK to close" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
		And I wait $wait_med seconds
	EndIf
    
And I "conduct equipment close workflow if seen"
	If I see "Confirm Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Mobile Process Workflow"
	EndIf

	Then I assign "successfully closed" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "ENTER" in web browser

Once I see "Complete Receiving" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Undirected Putaway
#############################################################
# Description: This scenario executes an inbound putaway through the Mobile App
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

Given I "enter the Lodnum"
	Once I see "Putaway" in element "className:appbar-title" in web browser

	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	Once I do not see $lodnum in web browser
	
  	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 
	And I "address allocation failure, if necessary"
		Then I assign "Could Not Allocate" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
		EndIf

Then I "deposit the Load"
	Once I see " Deposit" in element "className:appbar-title" in web browser
	Once I see $lodnum in web browser
	Then I execute scenario "Mobile Deposit"

@wip @public
Scenario: Mobile Reverse Receipt
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

Given I "perform reverse receipt operation"
	Once I see "Reverse Receipt" in element "className:appbar-title" in web browser

	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

	Then I assign "OK To Reverse?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser

@wip @public
Scenario: Mobile ASN Receiving
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
	Once I see "Receive Product" in element "className:appbar-title" in web browser
	Then I execute scenario "Mobile Receiving Input Load"

And I "process inventory approaching expiration"
	If I see $prtnum in web browser within $screen_wait seconds 
	And I see $asn_lodnum in web browser within $screen_wait seconds
		Then I assign "expire" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds 
			Then I press keys "ENTER" in web browser
			And I wait $screen_wait seconds
		EndIf
	EndIf

	Then I assign "OK to continue?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
	EndIf

And I "process serialization if required/configured"
	If I see "Validate ASN Serial Number" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Mobile Validate ASN Serial Number Cradle to Grave Receiving"
		ElsIf I verify text $serialization_type is equal to "OUTCAP_ONLY"
        Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type was not determined"
        EndIf
    EndIf

And I "answer the any more to receive question"
	Then I assign "Any More To Receive" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		If I verify text $receive_more_flag is equal to "TRUE"
        	Then I press keys "Y" in web browser
        Else I press keys "N" in web browser
        EndIf
	EndIf
    
And I "enter pass error producing pallet label message"
	Then I assign "Error Producing" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
        Then I press keys "Enter" in web browser
	EndIf 

@wip @public
Scenario: Mobile Non-ASN Receiving
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
#		revlvl - Revision Level
# Outputs:
#     None
#############################################################

When I "fill in the Load Number field"
	Once I see "Receive Product" in element "className:appbar-title" in web browser

	If I verify variable "lpn" is assigned
	And I verify text $lpn is not equal to ""
		Then I assign "Inventory Identifier" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $lpn in element "name:invtid" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	Else I "generate a new Load Number"
		Then I press keys "F3" in web browser
		And I wait $screen_wait seconds
		And I press keys "ENTER" in web browser
	EndIf

And I "see if we have the same LPN already, the system will error. Check for this and error the script."
	If I see "Load exists in" in web browser within $wait_med seconds 
		Then I fail step with error message "ERROR: Lodnum already exists nn the system"
	EndIf

And I "fill in the Part Number field"
	And I "may want to test blind parts so I set that in my override variables and use it here"
		Then I assign "Item Number" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		If I verify variable "rcv_prtnum" is assigned
		And I verify text $rcv_prtnum is not equal to ""
			Then I type $rcv_prtnum in element "name:prtnum" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
		Else I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
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
		Then I assign "Item Client ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		And I press keys "ENTER" in web browser
	EndIf

And I "check for pallet tracking/HU"
	If I see "Handling Unit" in web browser within $screen_wait seconds 
		Then I "confirm the HU Type is 'CHEP'"
			And I press keys "ENTER" in web browser
		And I "confirm the client_id is correct"
			And I press keys "ENTER" in web browser
	EndIf

And I "process see blind not allowed"
	If I see "Item Not On Order" in web browser within $screen_wait seconds 
		Then I "have entered a part not on this Inbound Shipment"
		  	And I press keys "ENTER" in web browser
		And I fail step with error message "ERROR: Blind receiving is not allowed"
	EndIf 

And I "process blind receiving if allowed"
	Then I assign "Item is unexpected. Do you want to receive it?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I "have entered a part not on this Inbound Shipment"
			And I press keys "Y" in web browser
			And I "continue as blind receiving is allowed"
	EndIf 

And I "process lot"
	Given I execute scenario "Mobile Receiving Process Lot"

And I "process units per case"
	Then I assign "Units Per" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Given I execute scenario "Get Create Footprint Policy Flag"
    If I verify text $create_footprint_flag is equal to "TRUE"
        Then I press keys "ENTER" in web browser
    EndIf

And I "process rcv qty"
	Then I assign "Receive Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $rcv_qty in element "name:rcvqty" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "process over receipt"
	Given I execute scenario "Mobile Receiving Process Over Receipt"

And I "process UOM"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"

    If I verify variable "rcv_uom" is assigned
    And I verify text $rcv_uom is not equal to ""
    	Then I clear all text in element "name:rcvuom" in web browser within $max_response seconds
    	And I type $rcv_qty in element "name:rcvuom" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
    Else I press keys "ENTER" in web browser
	EndIf

And I "check if part has an aging profile"
	Given I execute scenario "Mobile Receiving Process Aging Profile"

And I "process status"
	Then I assign "Inventory Status" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"

	If I verify variable "qa_sts" is assigned
	And I verify text $qa_sts is not equal to ""
		Then I clear all text in element "name:invsts" in web browser within $max_response seconds
		And I type $qa_sts in element "name:invsts" in web browser within $max_response seconds
	ElsIf I verify variable "age_profile" is assigned
	And I verify text $age_profile is equal to "x"
		Then I type $ap_sts in element "name:invsts" in web browser within $max_response seconds
		If I see "aging" in web browser within $wait_med seconds
			Then I assign "Continue" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I press keys "C" in web browser
			EndIf
		EndIf 
	Else I type $rcvsts in element "name:invsts" in web browser within $max_response seconds
	EndIf
	And I press keys "ENTER" in web browser

And I "process manufacturing date"	
	Then I execute scenario "Mobile Receiving Process Manufacturing Date"

And I "process subload and detail level receiving"
    And I assign "check_lodlvl.msql" to variable "msql_file"
    When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
        Then I assign row 0 column "lodlvl" to variable "load_level"
    Else I fail step with error message "ERROR: failed check of load level"
    EndIf

    If I verify text $load_level is not equal to "L"
        If I see "Identify Sub-LPN" in web browser within $screen_wait seconds
            Then I execute scenario "Mobile Process Subload Receiving"
        EndIf
    EndIf

And I "process revision level"
	If I verify variable "revlvl" is assigned
	And I verify text $revlvl is not equal to ""
    	Then I assign "Revision Level" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $revlvl in element "name:revlvl" in web browser within $max_response seconds
        And I press keys "ENTER" in web browser
	EndIf

And I "process create inventory"
	Given I assign "check_confirm_create.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign "OK To Create Inventory?" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			And I press keys "Y" in web browser
		EndIf
	Endif
    
And I "wait for inventory creation processing" which can take between $wait_med seconds and $wait_long seconds 
    
And I "process serialization if required/configured"
	If I see "Serial Number Capture" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Mobile Scan Serial Number Cradle to Grave Receiving"
		ElsIf I verify text $serialization_type is equal to "OUTCAP_ONLY"
        Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type cannot be determined"
        EndIf
    EndIf

And I "answer the any more to receive question"
	Then I assign "Any More To Receive" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		If I verify text $receive_more_flag is equal to "TRUE"
			Then I press keys "Y" in web browser
		Else I press keys "N" in web browser
		EndIf
	EndIf

And I "enter pass error producing pallet label message"
	Then I assign "Error Producing" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Enter" in web browser
	EndIf

Once I see "Receive Product" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile ASN Receiving Non-Trusted Supplier
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
	Once I see "Receive Product" in element "className:appbar-title" in web browser
	Then I execute scenario "Mobile Receiving Input Load"
	Once I see "Validate ASN" in element "className:appbar-title" in web browser

And I "validate ASN Screen is pre-populated with item number and ASN LPN"
	If I see $prtnum in web browser within $screen_wait seconds 
	And I see $asn_lodnum in web browser within $screen_wait seconds 
	And I see "expire" in web browser within $screen_wait seconds 
		Then I press keys "ENTER" in web browser
	EndIf

And I "cannot change item number on an ASN, so I enter the item number on the ASN"
	Then I assign "Item Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "am not changing client ID and entering through client ID field"
	Given I "check if this environment is multi-client enabled"
		Then I assign "check_3pl.msql" to variable "msql_file"
		And I execute scenario "Perform MSQL Execution"
		If I verify MOCA status is 0
			Then I assign row 0 column "installed" to variable "installed"
			Else I fail step with error message "ERROR: Could not determine if environment is multi-client enabled"
        Endif

	If I verify number $installed is equal to 1
		And I press keys "ENTER" in web browser
	EndIf

And I "process lot"
	Given I execute scenario "Mobile Receiving Process Lot"

And I "process rcv qty"
	And I "may want to change rcv qty for non trusted ASN"
		Then I assign "Receive Quantity" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		If I verify text $chg_qty is equal to "TRUE"
			Then I type $rcv_qty in element "name:rcvqty" in web browser within $max_response seconds
		EndIf
		And I press keys "ENTER" in web browser

And I "process over receipt"
	Given I execute scenario "Mobile Receiving Process Over Receipt"

And I "process UOM"
    Then I "may want to change rcv uom on the non trusted ASN"
		Then I assign "UOM" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
    	If I verify text $chg_uom is equal to "TRUE"
    		Then I type $rcv_uom in element "name:rcvuom" in web browser within $max_response seconds
    	EndIf
		And I press keys "ENTER" in web browser

And I "check if part has an aging profile"
	Given I execute scenario "Mobile Receiving Process Aging Profile"

And I "process status"
	Then I "may want to change inventory status"
		Then I assign "Inventory Status" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"

		If I verify text $chg_sts is equal to "TRUE"
		And I verify variable "rcv_chg_sts" is assigned
		And I verify text $rcv_chg_sts is not equal to ""
			Then I type $rcv_chg_sts in element "name:invsts" in web browser within $max_response seconds
		ElsIf I verify variable "age_profile" is assigned
		And I verify text $age_profile is equal to "x"
			Then I type $ap_sts in element "name:invsts" in web browser within $max_response seconds
			If I see "aging" in web browser within $wait_med seconds 
			And I see "Continue" in web browser within $wait_med seconds 
				Then I type "C" in web browser
			EndIf 
		Else I type $rcvsts in element "name:invsts" in web browser within $max_response seconds
		EndIf
		And I press keys "ENTER" in web browser

And I "process manufacturing date"
	Given I execute scenario "Mobile Receiving Process Manufacturing Date"

And I "process serialization if required/configured"
	If I see "Validate ASN Serial Number" in element "className:appbar-title" in web browser within $wait_med seconds
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Mobile Validate ASN Serial Number Cradle to Grave Receiving"
		ElsIf I verify text $serialization_type is equal to "OUTCAP_ONLY"
        Else I fail step with error message "ERROR: Serial Number screen seen, but serialization type cannot be determined"
        EndIf
    EndIf

And I "answer the any more to receive question"
	Then I assign "Any More To Receive" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		If I verify text $receive_more_flag is equal to "TRUE"
        	Then I press keys "Y" in web browser
        Else I press keys "N" in web browser
        EndIf
	EndIf
    
And I "enter pass error producing pallet label message"
	Then I assign "Error Producing" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
        Then I press keys "ENTER" in web browser
	EndIf 

@wip @public
Scenario: Mobile Unload Shipment
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
	Once I see "Unload Ship" in element "className:appbar-title" in web browser

	Then I assign "Dock" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $yard_loc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
And I "enter the destination location"
	Then I assign "Destination Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $rec_loc in element "name:dstloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "verify it's ok to unload the shipment, answer yes and transition to workflow"
	Then I assign "OK To Unload Shipment?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser
    
@wip @public
Scenario: Mobile Dispatch Equipment
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
    Once I see "Dispatch Equip" in element "className:appbar-title" in web browser

    Given I "handle tracking reference information"
    	If I verify variable "trac_ref" is  assigned
    	And I verify text $trac_ref is not equal to ""
    		Then I type $trac_ref in element "name:tractor_ref" in web browser within $max_response seconds
    	EndIf
        And I press keys "ENTER" in web browser
    
    Given I "handle driver's license information"
    	If I verify variable "driver_lic" is  assigned
    	And I verify text $driver_lic is not equal to ""
   			Then I type $driver_lic in element "name:driver_lic_num" in web browser within $max_response seconds
    	EndIf
        And I press keys "ENTER" in web browser
    
	Given I "handle driver's name information"
    	If I verify variable "driver_nam" is  assigned
    	And I verify text $driver_nam is not equal to ""
   			Then I type $driver_nam in element "name:driver_nam" in web browser within $max_response seconds
    	EndIf
        And I press keys "ENTER" in web browser
        
@wip @public
Scenario: Mobile Confirm Dispatch Equipment
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

Given I "verify it's ok to dispatch equipment, answer yes"
	Then I assign "OK to Dispatch Equip?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
	EndIf

@wip @public
Scenario: Mobile Trigger Product Putaway
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
	If I see "Product Putaway" in web browser within $screen_wait seconds 
		Then I "have reached my vehicle load limit and will not need an F6"
	Else I "will need to trigger a deposit"
		Once I see "Receive Product" in element "className:appbar-title" in web browser
		Then I press keys "F6" in web browser
		And I execute scenario "Mobile Wait for Processing"
	EndIf

@wip @public
Scenario: Mobile Receiving Without Order
#############################################################
# Description: Scenario to perform Receiving without order n Mobile App.
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

Once I see "Receive Without Order" in element "className:appbar-title" in web browser

When I "fill in the Client ID field"
	If I verify text $client_id is not equal to "----"
		Then I assign "Client ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
    	Then I type $client_id in element "name:client_id" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf
	
And I "fill in the Load Number field"
	If I verify variable "lodnum" is assigned
	And I verify text $lodnum is not equal to ""
		Then I assign "LPN" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf

And I "see if we have the same lodnum already, the system will error.  Check for this and error the script."
	If I see "Load exists in" in web browser within $screen_wait seconds 
		Then I fail step with error message "ERROR: lodnum already exists in the system"
	EndIf

And I "Enter the partnumber which should be received" 
	If I verify variable "prtnum" is assigned
	And I verify text $prtnum is not equal to ""
		Then I assign "Item Number" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf 
		
And I "fill in the U/C field"
	Then I assign "Units Per" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "ENTER" in web browser
			
And I "fill in the Receive Quantity field"
	Then I assign "Receive Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $rec_quantity in element "name:rcvqty" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "fill in the UOM field"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "ENTER" in web browser

And I "fill in the Status Field"
	If I verify variable "status" is assigned
	And I verify text $status is not equal to ""
		Then I assign "Inventory Status" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $status in element "name:invsts" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf

And I "fill Rcv w/o Ord Adjustment References"
	Then I assign "Adjustment Reference One" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

	Then I assign "Adjustment Reference Two" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser
	
And I "fill reason code"
	If I verify variable "reason" is assigned
	And I verify text $reason is not equal to ""
		Then I assign "Reason Code" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $reason in element "name:reacod" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf

And I "create Inventory"
	Then I assign "OK To Create Inventory?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
	Else I see "Invalid Response" in web browser within $screen_wait seconds 
		Then I press keys "ENTER" in web browser
		And I fail step with error message "ERROR: lodnum already exists in the system"
	EndIf 

Then I "select the deposit location"
	If I verify text $deposit_loc is equal to "rec_loc"
    	Then I assign $rec_loc to variable "dep_loc"
    	And I echo $dep_loc
    Else I verify text $deposit_loc is equal to "storage_loc"
    	Then I assign $storage_loc to variable "dep_loc"
    	And I echo $dep_loc
	EndIf

Then I "initiate Putaway"
	If I see "Product Putaway" in web browser within $screen_wait seconds 
		Then I "have reached my vehicle load limit and will not need an F6"
	Else I "will need to trigger deposit"
		Once I see "Receive Without Order" in element "className:appbar-title" in web browser
		Then I press keys "F6" in web browser
		And I execute scenario "Mobile Wait for Processing"
		While I see "Product Putaway" in element "className:appbar-title" in web browser within $screen_wait seconds 
			Then I "choose Putaway Method"
				Once I see "Product Putaway" in element "className:appbar-title" in web browser
				Then I type $putaway_method in web browser	
			And I "deposit the load"
				Then I execute scenario "Mobile Deposit"
		EndWhile 
	EndIf

@wip @public
Scenario: Mobile Process Product Putaway
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

Given I "specify the putaway method"
	Once I see "Product Putaway" in element "className:appbar-title" in web browser
	Then I press keys $putaway_method in web browser

And I "address allocation failure, if necessary"
	Then I assign "Could Not Allocate" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
		And I wait $screen_wait seconds
	EndIf

And I "wait for screen to transition out of Putaway"
	Once I do not see "Product Putaway" in element "className:appbar-title" in web browser

#############################################################
# Private Scenarios:
#	Mobile Receiving Process Manufacturing Date - check to see if the part has an aging profile defined
#	Mobile Receiving Process Aging Profile - check to see if the part has an aging profile and handle manufacturing date
#	Mobile Process Subload Receiving - From Product Putaway Screen, input the putaway method and process responses
#	Mobile Process Detail Receiving - Process the capture of detail lpns 
#	Generate Subload LPN for Receiving - Generate a subload LPN for receiving functions
#	Generate Detail LPN for Receiving - Generate Detail LPN for Receiving
#	Mobile Receiving Process Lot - Input lot number if required during Mobile receiving
#	Mobile Receiving Input Load - Input asn load number in the receiving screen
#	Mobile Receiving Process Over Receipt - Process Mobile over-receipt error message
#############################################################

@wip @private
Scenario: Mobile Receiving Input Load
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
	Then I type $asn_lodnum in web browser
	And I press keys "ENTER" in web browser
        
@wip @private
Scenario: Mobile Receiving Process Lot
#############################################################
# Description: Input lot number if required during Mobile receiving
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
		And I assign "check_lot.msql" to variable "msql_file"
		Then I execute scenario "Perform MSQL Execution"
		If  I verify MOCA status is 0
			And I assign row 0 column "lotflg" to variable "lotflg"
			If I verify number $lotflg is equal to 1
				Then I type $lotnum in element "name:lotnum" in web browser within $max_response seconds
				And I press keys "ENTER" in web browser
			Endif
		Else I fail step with error message "ERROR: Failed check to see if part was lot enabled"
        Endif
    
@wip @private
Scenario: Mobile Receiving Process Over Receipt
#############################################################
# Description: Process Mobile over-receipt error message
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

	And I assign "Over-receipt is not allowed" to variable "mobile_dialog_message"
	Then I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I "have entered too much quantity"
			And I press keys "ENTER" in web browser
		And I fail step with error message "ERROR: Over Receiving is not allowed"
	EndIf

@wip @private
Scenario: Mobile Receiving Process Manufacturing Date
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
		Then I press keys "ENTER" in web browser

		Once I see "default status" in web browser
		And I assign "manufacturing" to variable "mobile_dialog_message"
		Then I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "C" in web browser
		EndIf
	EndIf

@wip @private
Scenario: Mobile Receiving Process Aging Profile
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
	And I assign "check_aging.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "age_profile" to variable "age_profile"
		And I press keys "ENTER" in web browser
	EndIf

@wip @private   
Scenario: Mobile Process Subload Receiving
#############################################################
# Description: Process the capture of sub lpns
# TODO - need to trigger condition and determin xPath to copy of web screen
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
     
Given I "capture all the subload LPNs"
	Then I assign "Sub-LPN" to variable "input_field_with_focus" 
    And I execute scenario "Mobile Check for Input Focus Field"
	While I see "Identify Sub-LPN" in web browser within $screen_wait seconds
	And I do not see "OK To Create Inventory?" in web browser within $screen_wait seconds
        Then I execute scenario "Generate Subload LPN for Receiving"
        And I type $subload_lpn in web browser
		And I press keys "ENTER" in web browser
        If I see "Identify Dtl LPN" in web browser within $screen_wait seconds
    		Then I execute scenario "Mobile Process Detail Receiving"
     	EndIf
	EndWhile    
    
Then I "perform cleanup"
	Given I unassign variable "subload_lpn"  
    
@wip @private    
Scenario: Mobile Process Detail Receiving
#############################################################
# Description: Process the capture of detail lpns
# TODO - Need to reproduce and get XPaths and wait sequence
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

When I "capture all the detail LPNs"
    While I do not see "Subload Is Complete" in web browser within $screen_wait seconds
    And I see "Identify Dtl LPN" in web browser within $screen_wait seconds
	And I do not see "Identify Sub-LPN" in web browser within $screen_wait seconds
        Then I execute scenario "Generate Detail LPN for Receiving"
        And I type $detail_lpn in web browser
		And I press keys "ENTER" in web browser
        And I wait $wait_short seconds
    EndWhile
    
Then I "confirm the completion of the carton"
	Given I see "Subload Is Complete" in web browser within $screen_wait seconds
	Then I press keys "ENTER" in web browser
    
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