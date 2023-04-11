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
# Utility: Mobile List Picking Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
# 
# Description:
# This utility contains scenarios to perform List Picking in the Mobile App
#
# Public Scenarios:
#     - Mobile Perform Directed List Pick for Order - Performs Directed List Pick For a Given Order From Directed Work Menu
#     - Mobile Perform Undirected List Pick for Order - Performs Undirected List Pick For a Given Order From Undirected Menu
#     - Mobile Work Assignment Menu - Navigates From Undirected Menu To Work Assignment Menu 
#	  - Mobile Perform Picks for Work Assignment - Performs all the picks to complete a pick list
#
# Assumptions:
# None
#
# Notes:
# - See Scenario Headers for required inputs.
#
############################################################
Feature: Mobile List Picking Utilities

@wip @public
Scenario: Mobile Perform Directed List Pick for Order
#############################################################
# Description: From the Directed Work screen, given an order number/operation code/username, 
# performs the entirety of the associated List Picks.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		oprcod - set to the List picking operation code
#		username - the user assigned to or user to assign to
#		ordnum - The order that will be List picked
# 	Optional:
#		cancel_and_reallocate - Will cancel the List Pick and reallocate if set to "true"
# Outputs:
# 	None
#############################################################

Given I "wait some time for list picks to release" which can take between $wait_med seconds and $wait_long seconds 

And I "confirm Directed Work exists"	
	If I see "Pick List At" in element "className:appbar-title" in web browser within $wait_long seconds
		Then I echo "I'm good to proceed as there is list pick directed work"
	Else I fail step with error message "ERROR: There are no directed list picks. Exiting..."
	EndIf

When I "perform all associated list Picking"
	Given I assign "FALSE" to variable "lists_done"
	While I see "Pick List At" in element "className:appbar-title" in web browser within $wait_long seconds 
	And I verify text $lists_done is equal to "FALSE"

	Then I "copy the list ID from the Mobile App screen"
		And I copy text inside element "xPath://span[contains(text(),'List ID')]/ancestor::aq-displayfield[contains(@id,'list_id')]/descendant::span[contains(@class,'data')]" in web browser to variable "list_id" within $max_response seconds
			
	When I "perform the List Pick, if applicable"
		And I execute scenario "Check List Pick Directed Work Assignment"
		If I verify MOCA status is 0
			Then I echo "The Current Work is a List Pick. Proceeding...."
           	And I execute scenario "Mobile Acknowledge Work Assignment"
            When I execute scenario "Mobile Perform Picks for Work Assignment"
			If I verify number $picks_confirmed is greater than 0
				   Then I execute scenario "Mobile Deposit"
   			Else I "handle situation in which the first and only pick got canceled"
				If I execute scenario "Assign Work to User by Order and Operation"
				EndIf

                Then I assign "Completed" to variable "mobile_dialog_message"
				And I execute scenario "Mobile Set Dialog xPath"
				If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
               		Then I press keys "ENTER" in web browser 
               	EndIf
			EndIf
		Else I echo "The Current Work is not a List Pick or the Work is not assigned to the Current User. Exiting..."
			Then I assign "TRUE" to variable "lists_done"
		EndIf 
	EndWhile
	
@wip @public
Scenario: Mobile Perform Undirected List Pick for Order
#############################################################
# Description: Given an order number, performs the entirety of the associated Undirected List Picks.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		oprcod - set to the List picking operation code
#		ordnum - The order that will be List picked
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "obtain the List ID"
	When I execute scenario "Get Pick List ID by Order Number for Undirected Pick"
	If I verify MOCA status is 0
		Then I echo "We have got List Picks"
	Else I fail step with error message "ERROR: We do not have any List Picks. Exiting...."
	EndIf

When I "perform Order List picks"
	Then I assign "FALSE" to variable "lists_done"
	While I see "Work Assignment" in element "className:appbar-title" in web browser within $wait_med seconds
	And I verify text $lists_done is equal to "FALSE"
		Given I "get the list ID for the list picks"
			Given I execute scenario "Get Pick List ID by Order Number for Undirected Pick"
			
		When I "perform the Undirected List Pick, if applicable"
			If I verify MOCA status is 0
				Then I assign row 0 column "list_id" to variable "list_id"
				And I echo "The Current Work is a List Case Pick. Proceeding...."

                When I execute scenario "Mobile Sign on to Work Assignment"
                And I execute scenario "Mobile Perform Picks for Work Assignment"
				Then I execute scenario "Mobile Deposit"
			Else I echo "No Picks. Exiting..."
				Then I assign "TRUE" to variable "lists_done"
			EndIf
	EndWhile
    Then I unassign variable "lists_done"

@wip @public
Scenario: Mobile Perform Picks for Work Assignment
#############################################################
# Description: This scenario performs List Picking to completion from the Work Assignment screen.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		list_id - pick list to be picked
# 	Optional:
#		cancel_pick_flag - If "TRUE" then pick will be Cancel with no reallocation
#       cancel_code - Cancel code to enter.  Default C-N-R (cancel no reallocation)
#		error_location_flag - If canceling pick, show location be errored (Default=FALSE)
#		short_pick_flag - should the pick be shorted (default=FALSE) (short pick is automatically followed with a cancel pick)
#		short_pick_qty - Amount to pick when short picking  (default is 1)
#       single_pick_flag - Indicates the utility should exit after first pick is completed
#		override_srclod - Overrides the value entered for source load (unassigned after entry)
#       override_srcloc - Overrides the value entered for the source location (unassigned after entry)
#		override_prtnum - Overrides the value entered for part number (unassigned after entry)
#		override_pick_qty- Overrides the value entered for pick quantity (unassigned after entry)
#		override_uomcod - Overrides the value entered for the UOM code (unassigned after entry)
# Outputs:
# 	picks_confirmed - The number of picks confirm by this call this scenario
#############################################################

Given I assign "FALSE" to variable "work_assignment_loop_done"
And I assign 0 to variable "picks_confirmed"
And I assign "NO" to variable "lpck_action_performed"
When I "perform work assignment picks"
	While I verify text $work_assignment_loop_done is equal to "FALSE"
	And I see "Order Pick" in element "className:appbar-title" in web browser within $wait_med seconds
		If I verify variable "cancel_pick_flag" is assigned
		And I verify text $cancel_pick_flag is equal to "TRUE" ignoring case
			Then I "cancel pick from tools menu"
				And I execute scenario "Mobile Cancel Pick from Tools Menu"

            And I "clear the cancel variables"
				Given I unassign variable "cancel_pick_flag"
				And I unassign variable "cancel_code"
		Else I wait $wait_short seconds
			Then I "check to see if I need to set down my list or if my vehicle is full after one pick is complete"
				If I verify number $picks_confirmed is greater than 0
					If I verify variable "lpck_action" is assigned
					And I verify text $lpck_action is equal to "VEHICLE_FULL" ignoring case
					And I verify text $lpck_action_performed is not equal to "DONE" ignoring case
						Then I execute scenario "Mobile List Pick Vehicle Full"
						And I assign "DONE" to variable "lpck_action_performed"
					ElsIf I verify variable "lpck_action" is assigned
					And I verify text $lpck_action is equal to "SET_DOWN" ignoring case
					And I verify text $lpck_action_performed is not equal to "DONE" ignoring case
						Then I execute scenario "Mobile List Pick Set Down"
						And I assign "TRUE" to variable "lpck_action_performed"
					EndIf
				EndIf
            
			Then I "read the source location to pick from"
				And I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'dsploc')]/descendant::span[contains(@class,'data')]" in web browser to variable "srcloc" within $max_response seconds

			And I "read the Part number that needs to be picked"
				Then I copy text inside element "xPath://span[contains(text(),'Item Number')]/ancestor::aq-displayfield[contains(@id,'dspprt')]/descendant::span[contains(@class,'data')]" in web browser to variable "prtnum" within $max_response seconds

			And I "read the Item Client that needs to be picked"
				Then I copy text inside element "xPath://span[contains(text(),'Item Client ID')]/ancestor::aq-displayfield[contains(@id,'dspprtcli-')]/descendant::span[contains(@class,'data')]" in web browser to variable "client" within $max_response seconds
                
			And I "get a Load from the location to pick for the current Item And Client"	
				# This call populates prtnum and srclod
				Given I execute scenario "Get Source Subload ID for Terminal List Pick"
			  
			When I "enter the Lodnum, if applicable"
				And I assign "Item Identifier" to variable "input_field_with_focus"
				Given I assign variable "mobile_focus_elt" by combining "xPath://div[@class='mat-form-field-infix']/descendant::mat-label[contains(text(),'" $input_field_with_focus "')]"
				If I see element $mobile_focus_elt in web browser within $screen_wait seconds
					If I verify variable "override_srclod" is assigned
						Then I type $override_srclod in web browser
						And I unassign variable "override_srclod"
					Else I type $srclod in web browser
					EndIf
					And I press keys "ENTER" in web browser 
				Endif

			When I "enter the Source Location, if applicable"	
                Given I assign $srcloc to variable "verify_location"
                Then I execute scenario "Get Location Verification Code"

				Then I assign "Source Location" to variable "input_field_with_focus"
				And I assign variable "mobile_focus_elt" by combining "xPath://div[@class='mat-form-field-infix']/descendant::mat-label[contains(text(),'" $input_field_with_focus "')]"
				If I see element $mobile_focus_elt in web browser within $screen_wait seconds
					If I verify variable "override_srcloc" is assigned
						Then I type $override_srcloc in web browser
						And I unassign variable "override_srcloc"
					Else I type $location_verification_code in web browser
					EndIf
					And I press keys "ENTER" in web browser
				Endif

			When I "enter the Part Number, if applicable"
				And I assign "Item Number" to variable "input_field_with_focus"
				Then I execute scenario "Mobile Check for Input Focus Field"

				If I verify variable "override_prtnum" is assigned
					Then I type $override_prtnum in element "name:prtnum" in web browser within $max_response seconds
					And I unassign variable "override_prtnum"                     
				Else I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
				EndIf
				And I press keys "ENTER" in web browser
   
			When I "enter the Qty To Pick"
				And I assign "Quantity" to variable "input_field_with_focus"
				Then I execute scenario "Mobile Check for Input Focus Field"

				If I verify variable "short_pick_flag" is assigned
				And I verify text $short_pick_flag is equal to "TRUE" ignoring case
					Given I assign "TRUE" to variable "cancel_pick_flag"
					If I verify variable "short_pick_qty" is assigned
					And I verify text $short_pick_qty is not equal to ""
					Else I assign "1" to variable "short_pick_qty"
					EndIf
					And I clear all text in element "name:untqty" in web browser within $max_response seconds
					Then I type $short_pick_qty in element "name:untqty" in web browser within $max_response seconds

					Then I unassign variable "short_pick_qty"
					And I unassign variable "short_pick_flag"
				ElsIf I verify variable "override_pick_qty" is assigned
					And I clear all text in element "name:untqty" in web browser within $max_response seconds
					Then I type $override_pick_qty in element "name:untqty" in web browser within $max_response seconds
					And I unassign variable "override_pick_qty"
				EndIf
				And I press keys "ENTER" in web browser
                
			And I "press enter UOM and complete Pick"
				Then I assign "UOM" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"

				If I verify variable "override_uomcod" is assigned
					Then I clear all text in element "name:uomcod" in web browser within $max_response seconds
					And I type $override_uomcod in element "name:uomcod" in web browser within $max_response seconds
					And I unassign variable "override_uomcod"
				EndIf
				And I press keys "ENTER" in web browser 
		 
            And I "process serialization if required/configured"
				If I see "Serial Number" in element "className:appbar-title" in web browser within $screen_wait seconds
					Then I execute scenario "Get Item Serialization Type"
					If I verify text $serialization_type is equal to "OUTCAP_ONLY"
						Then I execute scenario "Mobile Scan Serial Number Outbound Capture Picking"
					ElsIf I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
						Then I execute scenario "Mobile Scan Serial Number Cradle to Grave Picking"
                    Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type cannot be determined"
                    EndIf
                EndIf
				
		  	And I "check if I am done with the list and increment the pick counter"
				Then I assign "List Pick Completed" to variable "mobile_dialog_message"
				And I execute scenario "Mobile Set Dialog xPath"
				If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
					Then I press keys "ENTER" in web browser
				EndIf

		  		Then I wait $screen_wait seconds 
                And I increase variable "picks_confirmed"
		Endif

		If I verify variable "single_pick_flag" is assigned
		And I verify text $single_pick_flag is equal to "TRUE" ignoring case
           Then I assign "TRUE" to variable "work_assignment_loop_done"
           And I unassign variable "single_pick_flag"
        EndIf
        
	EndWhile 
    
#############################################################
# Private Scenarios:
#	Mobile Acknowledge Work Assignment - Acknowledge the directed work
#	Mobile Sign on to Work Assignment - Perform an undirect sign onto a work list
#	Mobile List Pick Vehicle Full - Handles logic to set down list pick pallet using Equipment Full option and resume the remaining picks on a different list.
#	Mobile List Pick Set Down - Handles logic to set down list pick pallet using Set Down option and resume the remaining picks on the same list.
#############################################################

@wip @private
Scenario: Mobile Acknowledge Work Assignment  
#############################################################
# Description: This scenario Acknowledges the assigne work assignment
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "press Enter to Acknowledge"
	Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
	Then I press keys "ENTER" in web browser
	And I wait $screen_wait seconds
	  
Given I "check to see if I am resuming a list"
	If I verify variable "lpck_action" is assigned
	And I verify text $lpck_action is equal to "SET_DOWN" ignoring case
	And I verify variable "set_down_mode" is assigned
	And I verify text $set_down_mode is equal to "TRUE" ignoring case
		Then I assign "Uncompleted" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		Once I see element $mobile_dialog_elt in web browser
		And I press keys "Y" in web browser

		Then I "am in the load pickup screen, I should pick up the pallet I set down in the PD location. I will input to_id from the last iteration of this scenario which is still on the stack"
			Once I see "Load Pickup" in element "className:appbar-title" in web browser

            Then I assign "LPN" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I type $to_id in element "name:lodnum" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
			And I wait $wait_short seconds 
	Else I see "Work Assignment" in element "className:appbar-title" in web browser within $screen_wait seconds
		And I "enter Work Assignment"
        	Given I execute scenario "Get Load Id for Work Assignment"

            Then I assign "To ID" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I type $to_id in element "name:to_id" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
    EndIf

	Then I assign "Pos ID" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"	
	Then I press keys "ENTER" in web browser

@wip @private
Scenario: Mobile Sign on to Work Assignment
#############################################################
# Description: This scenario performs List Picking to completion from the Work Assignment screen.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		list_id - pick list to be picked
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "see the Work Assignment"
	If I see "Work Assignment" in element "className:appbar-title" in web browser within $screen_wait seconds
		Given I "enter the List Id"
			Then I assign "Work Asgnmt" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I type $list_id in web browser
			And I press keys "ENTER" in web browser

		Then I "enter the Pick-to Id"
			And I execute scenario "Get Load Id for Work Assignment"
            
            Then I assign "To ID" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I type $to_id in element "name:to_id" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser

            Then I assign "Pos ID" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I press keys "ENTER" in web browser
			And I wait $wait_short seconds

			Then I press keys "F6" in web browser
			And I execute scenario "Mobile Wait for Processing" 
	EndIf

@wip @private
Scenario: Mobile List Pick Vehicle Full
############################################################
# Description: Sets down the list to pallet LPN to the final staging     
# location with Equipment Full option. Handles logic to perform the      
# remaining picks using directed work.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "press F1 to go to the Deposit Options screen"
	Then I press keys "F1" in web browser
	And I wait $screen_wait seconds

	Once I see "Deposit Options" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Equipment Full') and contains(@class,'label')]" in web browser within $max_response seconds

	Then I assign "List Pick Completed" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "ENTER" in web browser

Then I "assign the other part of the list pick which is now generated under a new list ID to the same user"
	And I "wait some time for work generated to release" which can take between $wait_long seconds and $max_response seconds
	And I execute scenario "Assign Work to User by Order and Operation"
	Then I execute scenario "Mobile Deposit"

And I "should have the remaining picks in a new list in directed work"
	Once I see "Pick List At" in element "className:appbar-title" in web browser
	Then I "copy the list ID from the Mobile App screen"
		And I copy text inside element "xPath://span[contains(text(),'List ID')]/ancestor::aq-displayfield[contains(@id,'list_id')]/descendant::span[contains(@class,'data')]" in web browser to variable "list_id" within $max_response seconds

	When I execute scenario "Check List Pick Directed Work Assignment"
	And I verify MOCA status is 0

	Then I echo "The Current Work is a List Pick. Proceeding...."
		And I execute scenario "Mobile Acknowledge Work Assignment"

Once I see "Order Pick" in element "className:appbar-title" in web browser

@wip @private
Scenario: Mobile List Pick Set Down
############################################################
# Description: Sets down the list to pallet LPN to a PND location        
# with Set Down option. Handles logic to resume the list through         
# directed work.
# MSQL Files:
#	get_pndloc_for_lpck_set_down.msql
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "press F1 to go to the Deposit Options screen"
	Then I press keys "F1" in web browser
	And I wait $screen_wait seconds

Then I "choose setdown from Deposit options"
	Once I see "Deposit Options" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Set Down') and contains(@class,'label')]" in web browser within $max_response seconds

And I "select a PD location to set down this pallet"
	Then I assign "get_pndloc_for_lpck_set_down.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
	And I assign row 0 column "stoloc" to variable "dep_loc"
	Then I execute scenario "Mobile Deposit"
	And I wait $screen_wait seconds

Then I "assign the other part of the resume list pick work which is now generated to the same user"
	And I "wait some time for work generated to release" which can take between $wait_long seconds and $max_response seconds 
	Given I execute scenario "Mobile Navigate Quickly to Undirected Menu"
	And I assign "RLPCK" to variable "oprcod"
	Then I execute scenario "Assign Work to User by Order and Operation"
	And I execute scenario "Mobile Navigate to Directed Work Menu"
	Once I see "Pick List At" in element "className:appbar-title" in web browser
    
And I "copy the list ID from the Mobile App screen"
	Then I copy text inside element "xPath://span[contains(text(),'List ID')]/ancestor::aq-displayfield[contains(@id,'list_id')]/descendant::span[contains(@class,'data')]" in web browser to variable "list_id" within $max_response seconds

	When I execute scenario "Check List Pick Directed Work Assignment"
	And I verify MOCA status is 0

Then I "note, the Current Work is a List Pick. Proceeding...."
	And I assign "TRUE" to variable "set_down_mode"
	Then I execute scenario "Mobile Acknowledge Work Assignment"

Once I see "Order Pick" in element "className:appbar-title" in web browser