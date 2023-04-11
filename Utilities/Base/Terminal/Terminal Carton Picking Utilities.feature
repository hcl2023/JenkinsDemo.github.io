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
# Utility: Terminal Carton Picking Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
# 
# Description: Utilities to perform Carton Picking in the terminal
#
# Public Scenarios:
# 	- Terminal Navigate to Carton Pick Menu - From the Undirected Menu, goes to the Carton Pick screen
# 	- Terminal Perform Carton Picks for Order - Given an Order Number, performs ever Carton Pick for it
#	- Terminal Undirected Carton Picking - Performs an entire batch of carton picking
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Carton Picking Utilities

@wip @public
Scenario: Terminal Navigate to Carton Pick Menu
#############################################################
# Description: This scenario navigates to the Carton Pick screen from the Undirected Menu.
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

When I "navigate to the Carton Picking Menu"
	Once I see "Undirected Menu" in terminal
	And I type option for "Picking Menu" menu in terminal
	Once I see "Carton Pick" in terminal
	When I type option for "Carton Pick" menu in terminal

@wip @public
Scenario: Terminal Perform Carton Picks for Order
#############################################################
# Description: From the Build Batch screen, given an order number, performs the entirety of 
# the associated carton picks.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	ordnum - The order that will be carton picked
#   Optional:
#       cancel_pick_flag
#		cancel_code
# Outputs:
#	None
#############################################################

Once I see "Build Batch" in terminal

And I "wait some time for carton pick kit to release" which can take between $wait_long seconds and $max_response seconds 

When I "verify that Carton Picking work exists for this Order, add it to the Batch, and perform Carton Picking, if applicable"
	Given I assign 0 to variable "loop_done"
	While I see "Build Batch" in terminal within $wait_med seconds 
	And I verify number $loop_done is not equal to 1
		Given I execute scenario "Get Carton Number by Order for Undirected Carton Picking"
		If I verify MOCA status is 0
			When I execute scenario "Terminal Build Batch for Undirected Carton Picking"
			And I press keys "F6" in terminal
			Then I execute scenario "Terminal Undirected Carton Picking"
		Else I echo "No Picks found"
			And I assign 1 to variable "loop_done"
		EndIf
	EndWhile
	
And I "move back to undirected menu to logout"
	Given I press keys "F1" in terminal
	And I wait $wait_short seconds
	
	If I see "Picking Menu" in terminal within $wait_med seconds
		Then I press keys "F1" in terminal
	EndIf

@wip @public
Scenario: Terminal Undirected Carton Picking
#############################################################
# Description: This scenario performs Carton Picking to completion from the Order Pick screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		cancel_pick_flag - If "TRUE" then pick will be Cancel with no reallocation
#       cancel_code - Cancel code to enter.  Default C-N-R (cancel no reallocation)
#		error_location_flag - If canceling pick, show location be errored (Default=FALSE)
#		short_pick_flag - should the pick be shorted (default=FALSE) (short pick is automatically followed with a cancel pick)
#		short_pick_qty - Amount to pick when short picking  (default is 1)
#       single_pick_flag - Indicates the utility should exit after first pick is completed
#		override_srcloc - Overrides the valued enterd for source location (unassigned after entry)
#		override_src_id - Overrides the valued enterd for source Id (unassigned after entry)
#		override_prtnum - Overrides the valued enterd for part number (unassigned after entry)
#		override_pick_qty- Overrides the valued enterd for pick quantity (unassigned after entry)
#		override_uomcod - Overrides the valued enterd for the UOM code (unassigned after entry)
#		skip_deposit_flag - Indicates the scenario should return before performing deposit logic (unassigned after use)(default=FALSE)
# Outputs:
# 	picks_confirmed - The number of picks confirm by this call this scenario
#############################################################

Given I assign "FALSE" to variable "carton_loop_done"
And I assign 0 to variable "picks_confirmed"
When I "perform every Carton Pick in the batch"
	While I verify text $carton_loop_done is equal to "FALSE" 
    And I see "Order Pick" in terminal within $wait_med seconds
		Given I "verify screen has loaded for information to be copied off of it"
			Then I verify screen is done loading in terminal within $max_response seconds

		Given I "check if the test needs to cancel the current pick"
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
                    Then I type "Y" in terminal
                    If I see "Pick Canceled" in terminal within $wait_long seconds
                    Elsif I see "Pick Successfully" in terminal within $wait_short seconds
                    Else I fail step with error message "ERROR: Error during pick cancellation"
                    EndIf
                    Then I press keys "ENTER" in terminal

                Then I "return to the Tools Menu"
                    Once I see "Tools Menu" in terminal 
                    Then I press keys "F1" in terminal

                Then I "clear the cancel variables"
                    Given I unassign variable "cancel_pick_flag"
                    And I unassign variable "cancel_code"

                Then I "validate that the carton is complete"
                    If I see "Carton Is Complete" in terminal within $wait_short seconds 
                        Then I press keys "ENTER" in terminal
                    EndIf

                And I "validate that the batch is complete"
                    If I see "Batch is Complete" in terminal within $wait_short seconds 
                        Then I press keys "ENTER" in terminal
                        If I see " Deposit" in terminal within $wait_long seconds
							If I verify variable "skip_deposit_logic" is assigned
							And I verify text $skip_deposit_logic is equal to "TRUE"
                            	Then I assign "TRUE" to variable "carton_loop_done"
                                And I unassign variable "skip_deposit_logic"
                        	Else I execute scenario "Deposit After Carton Picking"
                            EndIf
                        EndIf
                    EndIf

			Else I "perform the normal pick confirmation"
 
                Then I "read the source location to pick from"
                    Then I wait $wait_med seconds
                    If I verify text $term_type is equal to "handheld"
                        Then I copy terminal line 2 columns 5 through 20 to variable "srcloc"
                    Else I verify text $term_type is equal to "vehicle"
						Then I copy terminal line 2 columns 5 through 29 to variable "srcloc"
                    EndIf
                    Then I execute groovy "srcloc = srcloc.trim()"

                And I "read the Carton ID that needs to be picked"
                    If I verify text $term_type is equal to "handheld"
                        Then I copy terminal line 4 columns 6 through 20 to variable "ctnnum"
                    Else I verify text $term_type is equal to "vehicle"
						Then I copy terminal line 3 columns 6 through 20 to variable "ctnnum"
                    EndIf
                    Then I execute groovy "ctnnum = ctnnum.trim()"

                And I "read the Part number that needs to be picked"
                    If I verify text $term_type is equal to "handheld"
                        Then I copy terminal line 5 columns 6 through 20 to variable "prtnum"
                    Else I verify text $term_type is equal to "vehicle"
						Then I copy terminal line 3 columns 26 through 40 to variable "prtnum"
                    EndIf
                    Then I execute groovy "prtnum = prtnum.trim()"

                And I "read the Item Client that needs to be picked"
                    If I verify text $term_type is equal to "handheld"
                        Then I copy terminal line 11 columns 5 through 20 to variable "client"
                    Else I verify text $term_type is equal to "vehicle"
						Then I copy terminal line 7 columns 5 through 20 to variable "client"
                    EndIf
                    Then I execute groovy "client = client.trim()"

                    When I "enter the Source Id, if applicable"	
                    	# This logic gets both src_id and prtnum
                        Then I execute scenario "Get Source ID for Carton Pick"
                        If I verify text $term_type is equal to "handheld"
                            If I see cursor at line 8 column 6 in terminal within $wait_med seconds
                                If I verify variable "override_src_id" is assigned
                                   Then I enter $override_src_id in terminal
                                   And I unassign variable "override_src_id"
                                Else I enter $src_id in terminal
                                EndIf
                                And I wait $wait_med seconds 
                            Endif
                        Else I verify text $term_type is equal to "vehicle"
                            If I see cursor at line 5 column 6 in terminal within $wait_med seconds
                                If I verify variable "override_src_id" is assigned
                                   Then I enter $override_src_id in terminal
                                   And I unassign variable "override_src_id"                    
                                Else I enter $src_id in terminal
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

                    When I "enter the Part Number, if applicable"	
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

                    When I "enter the Qty To Pick"
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
        
                    And I "enter the Carton Number"
                        If I verify text $term_type is equal to "handheld"
                        And I see cursor at line 15 column 6 in terminal within $wait_short seconds 
                            Then I enter $ctnnum in terminal
                            And I wait $wait_short seconds 
                        ElsIf I see cursor at line 7 column 26 in terminal within $wait_short seconds 
                            Then I enter $ctnnum in terminal
                            And I wait $wait_short seconds 
                        Else I fail step with error message "ERROR: Cursor is in the wrong place to enter carton number"
                        EndIf

                    And I "process serialization if required/configured"
						Then I verify screen is done loading in terminal within $max_response seconds
						If I see "Serial Numb" on line 1 in terminal within $wait_short seconds 
							Then I execute scenario "Get Item Serialization Type"
							If I verify text $serialization_type is equal to "OUTCAP_ONLY"
								Then I execute scenario "Terminal Scan Serial Number Outbound Capture Picking"
							ElsIf I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
								Then I execute scenario "Terminal Scan Serial Number Cradle to Grave Picking"
                    		Else I fail step with error message "ERROR: Serial Number Screen seen, but serialization type cannot be determined"
                            EndIf
                        EndIf

                    Then I "validate that the carton is complete"
                        If I see "Carton Is Complete" in terminal within $wait_short seconds 
                            Then I press keys "ENTER" in terminal
                        EndIf

                    And I "validate that the batch is complete"
                        If I see "Batch is Complete" in terminal within $wait_short seconds 
                            Then I press keys "ENTER" in terminal
							If I verify variable "skip_deposit_logic" is assigned
							And I verify text $skip_deposit_logic is equal to "TRUE"
                            	Then I assign "TRUE" to variable "carton_loop_done"
                                And I unassign variable "skip_deposit_logic"
                            Else I execute scenario "Deposit After Carton Picking"
                            EndIf
                        EndIf

                    And I "check for an invalid Device State"
                        If I see "Invalid " in terminal within $wait_short seconds 
                            Then I fail step with error message "ERROR: Device is in an invalid state"
                        EndIf
                        
          			And I increase variable "picks_confirmed"                       
			EndIf      
            
			If I verify variable "single_pick_flag" is assigned
			And I verify text $single_pick_flag is equal to "TRUE" ignoring case
           		Then I assign "TRUE" to variable "carton_loop_done"
           		And I unassign variable "single_pick_flag"
        	EndIf
	EndWhile
 
#############################################################
# Private Scenarios:
#	Deposit After Carton Picking - Perform Post Carton Picking deposit
#	Terminal Build Batch for Undirected Carton Picking - Adds a single carton number to the batch
# 	Terminal Undirected Carton Picking Cancel and Reallocate - Cancels and reallocates an entire batch of carton picking
#	Get Carton Number by Order for Undirected Carton Picking - Checks whether Carton Picks exist for specified order.
#	Get Source ID for Carton Pick - Determine that correct source inventory Id, Prtnum, Srcloc for a carton pick 
#############################################################

@wip @private
Scenario: Deposit After Carton Picking
#############################################################
# Description: Perform Post Carton Picking deposit.  This should be replaced by standard deposit scenario
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#		None
#############################################################

Given I "read the Destination Location from Deposit Screen and Deposit"
	While I see " Deposit" in terminal within $wait_long seconds
    
		Given I "verify screen has loaded for information to be copied off of it"
			Then I verify screen is done loading in terminal within $max_response seconds

            If I verify text $term_type is equal to "handheld"
                Then I copy terminal line 12 columns 6 through 20 to variable "dep_loc"
            Else I verify text $term_type is equal to "vehicle"
				Then I copy terminal line 7 columns 7 through 20 to variable "dep_loc"
            EndIf
        
        Then I "scan the value in the screen, converting to verification code if needed"
            Given I wait $wait_short seconds 
            Given I assign $dep_loc to variable "verify_location"
            And I execute scenario "Get Location Verification Code"
            When I enter $location_verification_code in terminal
            And I wait $wait_med seconds 
	EndWhile
	Then I wait $wait_med seconds

@wip @private
Scenario: Get Carton Number by Order for Undirected Carton Picking
#############################################################
# Description: Returns MOCA status of 0 when there are 
# Carton Picks found in MOCA for this order.
# MSQL Files:
#   	get_carton_number_by_order_for_undirected_carton_pick.msql
# Inputs:
# 	Required:
#		ordnum - Order Number associated with this pick.
# 	Optional:
#       None
# Outputs:
#	crtnum - Carton Number associated with this order
#############################################################

Given I "search for the crtnum associated with the pick for this order."
 	Given I assign "get_carton_number_by_order_for_undirected_carton_pick.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "ctnnum" to variable "ctnnum"
    EndIf    
    
@wip @private
Scenario: Terminal Build Batch for Undirected Carton Picking
#############################################################
# Description: This scenario adds a single carton number to a batch.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		ctnnum - The Carton Number to add to the batch
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "add the carton we will pick to the pick batch"
	Once I see "Build Batch" in terminal
	When I enter $ctnnum in terminal
	And I wait $wait_short seconds 

And I "verify it is added to the pick batch"
	If I see "Added to Batch" in terminal within $wait_med seconds 
		Then I press keys "ENTER" in terminal
	Else I fail step with error message "ERROR: Batch build error"
	EndIf

@wip @private
Scenario: Get Source ID for Carton Pick  
############################################################
# Description: Determine that correct source inventory Id, Prtnum, Srcloc for a carton pick 
# MSQL Files:
#	None 
# MSQL Files:
#   	get_source_id_for_carton_pick.msql
# Inputs:
# 	Required:
#		srcloc - Source Location of the carton pick
#       ctnnum - Carton being picked into
# 	Optional:
#       None
# Outputs:
#	src_id - Source Inventory Id
#   prtnum - Part Number 
#############################################################

When I "Get the source Id based on the current acknowledge pick"
	And I assign "get_source_id_for_carton_pick.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "src_id" to variable "src_id"
        And I assign row 0 column "prtnum" to variable "prtnum"
    Else I fail step with error message "ERROR: Unable to determine source ID for carton pick"
	EndIf