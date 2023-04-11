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
# Utility: Terminal List Picking Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
# 
# Description:
# This utility contains scenarios to perform List Picking
#
# Public Scenarios:
#     - Terminal Perform Directed List Pick for Order - Performs Directed List Pick For a Given Order From Directed Work Menu
#     - Terminal Perform Undirected List Pick for Order - Performs Undirected List Pick For a Given Order From Undirected Menu
#     - Terminal Work Assignment Menu - Navigates From Undirected Menu To Work Assignment Menu 
#	  - Terminal Perform Picks for Work Assignment - Performs all the picks to complete a pick list
#
# Assumptions:
# None
#
# Notes:
# - See Scenario Headers for required inputs.
#
############################################################
Feature: Terminal List Picking Utilities

@wip @public
Scenario: Terminal Perform Directed List Pick for Order
#############################################################
# Description: From the Directed Work screen, given an order number/operation code/username, performs the entirety of the associated List Picks.
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

Given I "wait some time for list picks to release" which can take between $wait_long seconds and $max_response seconds 

And I "confirm Directed Work exists"	
	If I see "Pick List At" in terminal within $wait_long seconds 
		Then I echo "I'm good to proceed as there is list pick directed work"
	Else I fail step with error message "ERROR: There are no directed list picks. Exiting..."
	EndIf

When I "perform all associated list Picking"
	Given I assign "FALSE" to variable "lists_done"
	While I see "Pick List At" in terminal within $wait_long seconds 
	And I verify text $lists_done is equal to "FALSE"

	Given I "verify screen has loaded for information to be copied off of it"
		Then I verify screen is done loading in terminal within $max_response seconds

	Then I "copy the list ID from the terminal screen"
		If I verify text $term_type is equal to "handheld"
			Then I copy terminal line 5 columns 1 through 20 to variable "list_id"
		Else I verify text $term_type is equal to "vehicle"
			Then I copy terminal line 3 columns 10 through 40 to variable "list_id"
		EndIf 
			
	When I "perform the List Pick, if applicable"
		And I execute scenario "Check List Pick Directed Work Assignment"
		If I verify MOCA status is 0
			Then I echo "The Current Work is a List Pick. Proceeding...."
           	And I execute scenario "Terminal Acknowledge Work Assignment"
            When I execute scenario "Terminal Perform Picks for Work Assignment"
			If I verify number $picks_confirmed is greater than 0
				   Then I execute scenario "Terminal Deposit"
   			Else I "handle situation in which the first and only pick got canceled"
				If I execute scenario "Assign Work to User by Order and Operation"
				EndIf
				If I see "Completed" in terminal within $wait_med seconds
               		Then I press keys "ENTER" in terminal 
               	EndIf
			EndIf
		Else I echo "The Current Work is not a List Pick or the Work is not assigned to the Current User. Exiting..."
			Then I assign "TRUE" to variable "lists_done"
		EndIf 
	EndWhile
	
@wip @public
Scenario: Terminal Perform Undirected List Pick for Order
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
	While I see "Work Asgnmt" on line 1 in terminal
	And I verify text $lists_done is equal to "FALSE"
		Given I "get the list ID for the list picks"
			Given I execute scenario "Get Pick List ID by Order Number for Undirected Pick"
			
		When I "perform the Undirected List Pick, if applicable"
			If I verify MOCA status is 0
				Given I assign row 0 column "list_id" to variable "list_id"
				And I echo "The Current Work is a List Case Pick. Proceeding...."
                When I execute scenario "Terminal Sign on to Work Assignment"
                When I execute scenario "Terminal Perform Picks for Work Assignment"
				Then I execute scenario "Terminal Deposit"
			Else I echo "No Picks. Exiting..."
				Then I assign "TRUE" to variable "lists_done"
			EndIf
	EndWhile
    Then I unassign variable "lists_done"


@wip @public
Scenario: Terminal Work Assignment Menu
#############################################################
# Description: This scenario navigates to the Work Assignment screen
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

When I "navigates to terminal work assignment menu"	
   Once I see "Undirected Menu" in terminal
   Then I type option for "Picking Menu" menu in terminal
   Once I see "Picking Menu" on line 1 in terminal
   Then I type option for "Work Asgnmt" menu in terminal
   Once I see "Work Asgnmt" on line 1 in terminal

@wip @public
Scenario: Terminal Perform Picks for Work Assignment
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
    And I see "Order Pick" in terminal within $wait_long seconds 
		If I verify variable "cancel_pick_flag" is assigned
		And I verify text $cancel_pick_flag is equal to "TRUE" ignoring case
			Given I "open the Tools Menu"
				When I press keys "F7" in terminal
				Once I see "Tools Menu" in terminal 

			And I "select the Cancel Pick option"
				When I type "5" in terminal
				Once I see "Cancel Pick" on line 1 in terminal 

			When I "type in the code"
                If I verify variable "cancel_code" is assigned
                And I verify text $cancel_code is not equal to ""
                Else I assign "C-N-R" to variable "cancel_code"
                EndIf
				When I enter $cancel_code in terminal

			And I "respond to 'error the location' question"
				If I verify variable "error_location_flag" is assigned
                And I verify text $error_location_flag is equal to "TRUE" ignoring case
				   Then I enter "Y" in terminal
                Else I enter "N" in terminal
				EndIf
                
			And I "cancel the Pick"
				Once I see "OK To Cancel Pick?" in terminal 
				Then I press keys "Y" in terminal
				If I see "Pick Canceled" in terminal within $wait_long seconds
                Elsif I see "Pick Successfully" in terminal within $wait_short seconds
                Else I fail step with error message "ERROR: Error during pick cancellation"
                EndIf
 				Then I press keys "ENTER" in terminal
			
			Then I "validate that the List is complete"
			 	If I see "List Pick Completed" in terminal within $wait_med seconds 
				  	Once I see "Press Enter" in terminal
				  	Then I press keys "ENTER" in terminal
                    And I assign "TRUE" to variable "work_assignment_loop_done"
				EndIf

			Then I "return to the Tools Menu"
				Once I see "Tools Menu" in terminal 
				Then I press keys "F1" in terminal
                
            Then I "clear the cancel variables"
             	Given I unassign variable "cancel_pick_flag"
                And I unassign variable "cancel_code"
                
		Else I wait $wait_short seconds
        	Then I "check to see if I need to set down my list or if my vehicle is full after one pick is complete"
              If I verify number $picks_confirmed is greater than 0
                  If I verify variable "lpck_action" is assigned
                  And I verify text $lpck_action is equal to "VEHICLE_FULL" ignoring case
                  And I verify text $lpck_action_performed is not equal to "DONE" ignoring case
                      Then I execute scenario "Terminal List Pick Vehicle Full"
                      And I assign "DONE" to variable "lpck_action_performed"
                  ElsIf I verify variable "lpck_action" is assigned
                  And I verify text $lpck_action is equal to "SET_DOWN" ignoring case
                  And I verify text $lpck_action_performed is not equal to "DONE" ignoring case
                      Then I execute scenario "Terminal List Pick Set Down"
                      And I assign "TRUE" to variable "lpck_action_performed"
                  EndIf
            EndIf
            
			Given I "verify screen has loaded for information to be copied off of it"
				Then I verify screen is done loading in terminal within $max_response seconds

			Then I "read the source location to pick from"
				If I verify text $term_type is equal to "handheld"
					Then I copy terminal line 2 columns 6 through 20 to variable "srcloc"
				Else I verify text $term_type is equal to "vehicle"
					Then I copy terminal line 2 columns 6 through 29 to variable "srcloc"
			  	EndIf
				Then I execute groovy "srcloc = srcloc.trim()"
                
			And I "read the Part number that needs to be picked"		
			  	If I verify text $term_type is equal to "handheld"
				  	Then I copy terminal line 5 columns 6 through 20 to variable "prtnum"
				Else I verify text $term_type is equal to "vehicle"
					Then I copy terminal line 3 columns 26 through 40 to variable "prtnum"
			  	EndIf
			    Then I execute groovy "prtnum = prtnum.trim()"
                
			And I "read the Item Client that needs to be picked"		
			  	If I verify text $term_type is equal to "handheld"
				  	Then I copy terminal line 11 columns 6 through 20 to variable "client"
				Else I verify text $term_type is equal to "vehicle"
					Then I copy terminal line 7 columns 6 through 20 to variable "client"
			  	EndIf
			  	Then I execute groovy "client = client.trim()"
                
		  	And I "get a Load from the location to pick for the current Item And Client"	
                # This call populates prtnum and srclod
			  	Given I execute scenario "Get Source Subload ID for Terminal List Pick"
			  
		  	When I "enter the Lodnum, if applicable"	
				If I verify text $term_type is equal to "handheld"
					If I see cursor at line 8 column 6 in terminal within $wait_med seconds
                        If I verify variable "override_srclod" is assigned
                           Then I enter $override_srclod in terminal
                           And I unassign variable "override_srclod"
                        Else I enter $srclod in terminal
                        EndIf
						And I wait $wait_med seconds 
					Endif
				Else I verify text $term_type is equal to "vehicle"
					If I see cursor at line 5 column 6 in terminal within $wait_med seconds
                        If I verify variable "override_srclod" is assigned
                           Then I enter $override_srclod in terminal
                           And I unassign variable "override_srclod"                    
						Else I enter $srclod in terminal
                        EndIf
						And I wait $wait_med seconds 
					Endif
				Endif

            When I "enter the Source Location, if applicable"	
                Given I assign $srcloc to variable "verify_location"
                And I execute scenario "Get Location Verification Code"
                If I verify text $term_type is equal to "handheld"
                    If I see cursor at line 9 column 6 in terminal within $wait_med seconds
                        If I verify variable "override_srcloc" is assigned
                           Then I enter $override_srcloc in terminal
                           And I unassign variable "override_srcloc"
                        Else I enter $location_verification_code in terminal
                        EndIf
                        And I wait $wait_med seconds 
                    Endif
                Else I verify text $term_type is equal to "vehicle"
                    If I see cursor at line 5 column 26 in terminal within $wait_med seconds
                        If I verify variable "override_srcloc" is assigned
                           Then I enter $override_srcloc in terminal
                           And I unassign variable "override_srcloc"                    
                        Else I enter $location_verification_code in terminal
                        EndIf
                        And I wait $wait_med seconds 
                    Endif
                Endif

		  	And I "enter the Part Number, if applicable"	
				If I verify text $term_type is equal to "handheld"
					If I see cursor at line 10 column 6 in terminal within $wait_med seconds
                        If I verify variable "override_prtnum" is assigned
                           Then I enter $override_prtnum in terminal
                           And I unassign variable "override_prtnum"                     
                    	Else I enter $prtnum in terminal
                        EndIf
						And I wait $wait_med seconds 
                    EndIf
				Else I verify text $term_type is equal to "vehicle"
					If I see cursor at line 6 column 6 in terminal within $wait_med seconds
                        If I verify variable "override_prtnum" is assigned
                           Then I enter $override_prtnum in terminal
                           And I unassign variable "override_prtnum"                     
                    	Else I enter $prtnum in terminal
                        EndIf
						And I wait $wait_med seconds 
                    EndIf
				Endif
   
		  	And I "enter the Qty To Pick"
				If I verify text $term_type is equal to "handheld"
					Once I see cursor at line 13 column 6 in terminal
			   	Else I verify text $term_type is equal to "vehicle"
					Once I see cursor at line 8 column 6 in terminal
				Endif
				If I verify variable "short_pick_flag" is assigned
				And I verify text $short_pick_flag is equal to "TRUE" ignoring case
					Given I assign "TRUE" to variable "cancel_pick_flag"
					And I execute scenario "Terminal Clear Field"
                    If I verify variable "short_pick_qty" is assigned
                    And I verify text $short_pick_qty is not equal to ""
                    Else I assign "1" to variable "short_pick_qty"
                    EndIf
					When I enter $short_pick_qty in terminal
                    And I unassign variable "short_pick_qty"
                    And I unassign variable "short_pick_flag"
				ElsIf I verify variable "override_pick_qty" is assigned
                    Then I execute scenario "Terminal Clear Field"
                    And I enter $override_pick_qty in terminal 
                    And I unassign variable "override_pick_qty"
                Else I press keys "ENTER" in terminal
				EndIf 
				Then I wait $wait_med seconds 
                
		  	And I "press enter to confirm UOM and complete Pick"	
		  		If I verify text $term_type is equal to "handheld" 
					Once I see cursor at line 13 column 15 in terminal
				Else I verify text $term_type is equal to "vehicle"
					Once I see cursor at line 8 column 15 in terminal
				Endif
                If I verify variable "override_uomcod" is assigned
                   Then I execute scenario "Terminal Clear Field"
                   And I enter $override_uomcod in terminal
                   And I unassign variable "override_uomcod"
				Else I press keys "ENTER" in terminal
                EndIf
				And I wait $wait_med seconds 
		 
            And I "process serialization if required/configured"
				If I see "Serial Numb" on line 1 in terminal within $wait_med seconds 
					Then I execute scenario "Get Item Serialization Type"
					If I verify text $serialization_type is equal to "OUTCAP_ONLY"
						Then I execute scenario "Terminal Scan Serial Number Outbound Capture Picking"
					ElsIf I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
						Then I execute scenario "Terminal Scan Serial Number Cradle to Grave Picking"
                    Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type cannot be determined"
                    EndIf
                EndIf
				
		  	And I "check if I am done with the list and increment the pick counter"	  
            	If I see "List Pick Completed" in terminal within $wait_long seconds 
					Then I press keys "ENTER" in terminal
			  	EndIf
		  		Then I wait $wait_long seconds 
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
#	Terminal Acknowledge Work Assignment - Acknowledge the directed work
#	Get Load Id for Work Assignment - Generate the Pick-To Id for the work assignment picks
#	Terminal Sign on to Work Assignment - Perform an undirect sign onto a work list
#	Get Source Subload ID for Terminal List Pick - Gets a Source Subload ID for Terminal List Pick 
#	Get List Pick Directed Work by Order Number - Checks whether List Picks exist for specified order.
#	Get Pick List ID by Order Number for Undirected Pick - Obtains a List Id associated with a given Order Number
#	Check List Pick Directed Work Assignment - Checks whether there are remaining picks for the assigned user given the specified List Id.
#	Terminal List Pick Vehicle Full - Handles logic to set down list pick pallet using Equipment Full option and resume the remaining picks on a different list.
#	Terminal List Pick Set Down - Handles logic to set down list pick pallet using Set Down option and resume the remaining picks on the same list.
#############################################################

@wip @private
Scenario: Terminal Acknowledge Work Assignment  
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
	When I press keys "ENTER" in terminal
	  
Then I "check to see if I am resuming a list"
	If I verify variable "lpck_action" is assigned
	And I verify text $lpck_action is equal to "SET_DOWN" ignoring case
	And I verify variable "set_down_mode" is assigned
	And I verify text $set_down_mode is equal to "TRUE"
		Once I see "Uncompleted" in terminal
		Then I press keys "Y" in terminal
		And I wait $wait_short seconds

		Then I "am in the load pickup screen, I should pick up the pallet I set down in the PD location. I will input to_id from the last iteration of this scenario which is still on the stack"
			Once I see "Load Pickup" in terminal
			Then I "verify terminal cursor postion"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 10 column 2 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 6 column 6 in terminal
			EndIf
			Then I enter $to_id in terminal
			And I wait $wait_short seconds	
	Else I "enter Work Assignment" 
		Then I see "Work Asgnmt" in terminal within $wait_med seconds 
		Given I execute scenario "Get Load Id for Work Assignment"
		When I enter $to_id in terminal
    EndIf
	Then I press keys "ENTER" in Terminal

@wip @private
Scenario: Get Load Id for Work Assignment
#############################################################
# Description: This scenario generates the pick-to load id for a work assignment
# MSQL Files:
#	None       
# Inputs:
# 	Required:
#		None
# 	Optional:
#		None
# Outputs:
# 	to_id - Pick-to load id
#############################################################

Given I assign next value from sequence "lodnum" to "to_id"

@wip @private
Scenario: Terminal Sign on to Work Assignment
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
	If I see "Work Asgnmt" in terminal within $wait_long seconds 
		Given I "enter the List Id"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 3 column 1 in terminal
			Else I see cursor at line 2 column 15 in terminal
			EndIf
			Then I enter $list_id in terminal
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 6 column 10 in terminal
			Else I see cursor at line 5 column 15 in terminal within $wait_long seconds 
			EndIf

		Then I "enter the Pick-to Id"
			Then I execute scenario "Get Load Id for Work Assignment"
			And I enter $to_id in terminal
			And I wait $wait_short seconds

			Then I press keys "ENTER" in terminal
			And I wait $wait_short seconds

			Then I press keys "F6" in terminal
			And I wait $wait_med seconds
	EndIf

@wip @private
Scenario: Get Source Subload ID for Terminal List Pick
#############################################################
# Description: This scenario performs Get Source Subload ID for Terminal List Pick.
# MSQL Files:
#	get_source_subload_for_terminal_list_pick.msql
# Inputs:
# 	Required:
#		srcloc - the Source Location
#		prtnum - the Part Number
#		list_id - the List Pick ID
# 	Optional:
#		None
# Outputs:
# 	prtnum - Part Number to be entered for pick
#   srclod - Source Load to be entered on pick
#############################################################

Given I "obtain the Source Subload ID based on its source location, part, and pick list ID"
	Then I assign "get_source_subload_for_terminal_list_pick.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	  	Then I assign row 0 column "subnum" to variable "srclod"
	  	And I assign row 0 column "prtnum" to variable "prtnum"
	Else I echo "There is no inventory to pick in this location"
	  	Then I fail step with error message "ERROR: There is no inventory to pick in this location"
	EndIf
    
@wip @private
Scenario: Get List Pick Directed Work by Order Number
#############################################################
# Description: Returns MOCA status of 0 when there are 
# List Picks found in MOCA for this order.
# MSQL Files:
#	get_list_picking_directed_work_by_order_and_operation_code.msql
# Inputs:
# 	Required:
#   	oprcod - Operation Code.
#		ordnum - Order Number associated with this pick.
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

When I "search for any existing List Picks"
	Given I assign "get_list_picking_directed_work_by_order_and_operation_code.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	
@wip @private
Scenario: Get Pick List ID by Order Number for Undirected Pick
############################################################
# Description: Returns MOCA status of 0 when there are 
# List Id values for this order's pick.
# MSQL Files:
#	get_undirected_case_pick_list_id_by_order.msql
# Inputs:
# 	Required:
#		ordnum - Order Number
# 	Optional:
#       None
# Outputs:
#	list_id - List Id for this Pick
#############################################################

When I "search MOCA for a List Id for the pick generated for this order."
	Given I assign "get_undirected_case_pick_list_id_by_order.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	
@wip @private
Scenario: Check List Pick Directed Work Assignment
############################################################
# Description: Returns MOCA status of 0 when there are 
# List Picks remaining given this List Id.
# MSQL Files:
#	check_list_pick_directed_work_assigned_to_user.msql
# Inputs:
# 	Required:
#		oprcod - Operation Code
#		list_id - List Id
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

When I "search MOCA for remaining picks assigned to the user given this List Id."
	Given I assign "check_list_pick_directed_work_assigned_to_user.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    
@wip @private
Scenario: Terminal List Pick Vehicle Full
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
	Then I press keys "F1" in terminal
	And I wait $wait_med seconds

	Once I see "Deposit Options" on line 1 in terminal
	Then I type option for "Equipment Full" menu in terminal

	Once I see "List Pick Completed" in terminal
	And I wait $wait_med seconds
	Then I press keys "ENTER" in terminal
	And I wait $wait_med seconds

Then I "assign the other part of the list pick which is now generated under a new list ID to the same user"
	And I execute scenario "Assign Work to User by Order and Operation"
	Then I execute scenario "Terminal Deposit"

And I "should have the remaining picks in a new list in directed work"
	Once I see "Pick List At" in terminal
	Then I "copy the list ID from the terminal screen"
    And I verify screen is done loading in terminal within $wait_long seconds
		If I verify text $term_type is equal to "handheld"
			Then I copy terminal line 5 columns 1 through 20 to variable "list_id"
		Else I verify text $term_type is equal to "vehicle"
			Then I copy terminal line 3 columns 10 through 40 to variable "list_id"
		EndIf 

	When I execute scenario "Check List Pick Directed Work Assignment"
	And I verify MOCA status is 0

And I echo "The Current Work is a List Pick. Proceeding...."
	And I execute scenario "Terminal Acknowledge Work Assignment"

Once I see "Order Pick" in terminal

@wip @private
Scenario: Terminal List Pick Set Down
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
	Then I press keys "F1" in terminal
	And I wait $wait_med seconds

Once I see "Deposit Options" on line 1 in terminal
Then I type option for "Set Down" menu in terminal
And I wait $wait_med seconds

Then I "select a PD location to set down this pallet"
	And I assign "get_pndloc_for_lpck_set_down.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
	And I assign row 0 column "stoloc" to variable "dep_loc"
	And I execute scenario "Terminal Deposit"
	And I wait $wait_med seconds

Then I "assign the other part of the resume list pick work which is now generated to the same user"
	Given I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	And I assign "RLPCK" to variable "oprcod"
	Then I execute scenario "Assign Work to User by Order and Operation"
	And I execute scenario "Terminal Navigate to Directed Work Menu"
	Once I see "Pick List At" in terminal
    And I verify screen is done loading in terminal within $wait_long seconds
    
And I "copy the list ID from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 5 columns 1 through 20 to variable "list_id"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 3 columns 10 through 40 to variable "list_id"
	EndIf
    
When I execute scenario "Check List Pick Directed Work Assignment"
And I verify MOCA status is 0

Then I "The Current Work is a List Pick. Proceeding...."
	And I assign "TRUE" to variable "set_down_mode"
	And I execute scenario "Terminal Acknowledge Work Assignment"

Once I see "Order Pick" in terminal