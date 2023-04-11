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
# Utility: Mobile Carton Picking Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
# 
# Description: Utilities to perform Carton Picking in the Mobile App
#
# Public Scenarios:
# 	- Mobile Perform Carton Picks for Order - Given an Order Number, performs ever Carton Pick for it
#	- Mobile Undirected Carton Picking - Performs an entire batch of carton picking
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Carton Picking Utilities

@wip @public
Scenario: Mobile Perform Carton Picks for Order
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

Once I see "Build Batch" in element "className:appbar-title" in web browser

Then I "wait some time for carton pick kit to release" which can take between $wait_med seconds and $wait_long seconds 

When I "verify that Carton Picking work exists for this Order, add it to the Batch, and perform Carton Picking, if applicable"
	Given I assign 0 to variable "loop_done"
	While I see "Build Batch" in element "className:appbar-title" in web browser within $wait_med seconds
	And I verify number $loop_done is not equal to 1
		Given I execute scenario "Get Carton Number by Order for Undirected Carton Picking"
		If I verify MOCA status is 0
			When I execute scenario "Mobile Build Batch for Undirected Carton Picking"
			And I press keys "F6" in web browser
			And I execute scenario "Mobile Wait for Processing" 
			Then I execute scenario "Mobile Undirected Carton Picking"
		Else I echo "No Picks found"
			And I assign 1 to variable "loop_done"
		EndIf
	EndWhile
	
And I "move back to undirected menu to logout"
	Given I press keys "F1" in web browser
	And I wait $wait_short seconds
	
	If I see "Picking Menu" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I press keys "F1" in web browser
	EndIf

@wip @public
Scenario: Mobile Undirected Carton Picking
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
    And I see "Order Pick" in element "className:appbar-title" in web browser within $screen_wait seconds
		Given I "check if the test needs to cancel the current pick"
            If I verify variable "cancel_pick_flag" is assigned
            And I verify text $cancel_pick_flag is equal to "TRUE" ignoring case
				Then I "cancel pick from tools menu"
					And I execute scenario "Mobile Cancel Pick from Tools Menu"

           		And I "clear the cancel variables"
                    Given I unassign variable "cancel_pick_flag"
                    And I unassign variable "cancel_code"

               Then I "validate that the carton is complete"
					And I assign "Carton Is Complete" to variable "mobile_dialog_message"
					Then I execute scenario "Mobile Set Dialog xPath"
					If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
						Then I press keys "ENTER" in web browser
                    EndIf

                And I "validate that the batch is complete"
					Then I assign "Batch is Complete" to variable "mobile_dialog_message"
					And I execute scenario "Mobile Set Dialog xPath"
					If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
                        Then I press keys "ENTER" in web browser
                        If I see " Deposit" in element "className:appbar-title" in web browser within $wait_long seconds
							If I verify variable "skip_deposit_logic" is assigned
							And I verify text $skip_deposit_logic is equal to "TRUE"
                            	Then I assign "TRUE" to variable "carton_loop_done"
                                And I unassign variable "skip_deposit_logic"
                        	Else I execute scenario "Mobile Deposit After Carton Picking"
                            EndIf
                        EndIf
                    EndIf
                Then I "validate that the carton is complete"
					And I assign "Carton Is Complete" to variable "mobile_dialog_message"
					Then I execute scenario "Mobile Set Dialog xPath"
					If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
						Then I press keys "ENTER" in web browser
                    EndIf

                And I "validate that the batch is complete"
					Then I assign "Batch is Complete" to variable "mobile_dialog_message"
					And I execute scenario "Mobile Set Dialog xPath"
					If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
                        Then I press keys "ENTER" in web browser
                        If I see " Deposit" in element "className:appbar-title" in web browser within $wait_long seconds
							If I verify variable "skip_deposit_logic" is assigned
							And I verify text $skip_deposit_logic is equal to "TRUE"
                            	Then I assign "TRUE" to variable "carton_loop_done"
                                And I unassign variable "skip_deposit_logic"
                        	Else I execute scenario "Mobile Deposit After Carton Picking"
                            EndIf
                        EndIf
                    EndIf
			Else I "perform the normal pick confirmation"
                Then I "read the source location to pick from"
                    And I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'dsploc')]/descendant::span[contains(@class,'data')]" in web browser to variable "srcloc" within $max_response seconds

                And I "read the Carton ID that needs to be picked"
                	Then I copy text inside element "xPath://span[contains(text(),'Inventory Identifier')]/ancestor::aq-displayfield[contains(@id,'dsplod')]/descendant::span[contains(@class,'data')]" in web browser to variable "ctnnum" within $max_response seconds

                And I "read the Part number that needs to be picked"
					Then I copy text inside element "xPath://span[contains(text(),'Item Number')]/ancestor::aq-displayfield[contains(@id,'dspprt')]/descendant::span[contains(@class,'data')]" in web browser to variable "prtnum" within $max_response seconds

                And I "read the Item Client that needs to be picked"
					Then I copy text inside element "xPath://span[contains(text(),'Item Client ID')]/ancestor::aq-displayfield[contains(@id,'dspprtcli-')]/descendant::span[contains(@class,'data')]" in web browser to variable "client" within $max_response seconds

				When I "enter the Source Id, if applicable"	
					# This logic gets both src_id and prtnum
					And I assign "Source ID" to variable "input_field_with_focus"
					Given I assign variable "mobile_focus_elt" by combining "xPath://div[@class='mat-form-field-infix']/descendant::mat-label[contains(text(),'" $input_field_with_focus "')]"
					If I see element $mobile_focus_elt in web browser within $screen_wait seconds
						Then I execute scenario "Get Source ID for Carton Pick"
						If I verify variable "override_src_id" is assigned
							Then I type $override_src_id in web browser
							And I unassign variable "override_src_id"                    
						Else I type $src_id in web browser
						EndIf
						And I press keys "ENTER" in web browser
						Then I wait $screen_wait seconds
					EndIf

				When I "enter the Source Location, if applicable"
					And I assign "Source Location" to variable "input_field_with_focus"
					Given I assign variable "mobile_focus_elt" by combining "xPath://div[@class='mat-form-field-infix']/descendant::mat-label[contains(text(),'" $input_field_with_focus "')]"
					If I see element $mobile_focus_elt in web browser within $screen_wait seconds
						Then I assign $srcloc to variable "verify_location"
						And I execute scenario "Get Location Verification Code"
						If I verify variable "override_srcloc" is assigned
							Then I type $override_srcloc in web browser
							And I unassign variable "override_srcloc"
						Else I type $location_verification_code in web browser
						EndIf
						And I press keys "ENTER" in web browser
						Then I wait $screen_wait seconds
					EndIf

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

						And I unassign variable "short_pick_qty"
						And I unassign variable "short_pick_flag"
					ElsIf I verify variable "override_pick_qty" is assigned
						And I clear all text in element "name:untqty" in web browser within $max_response seconds
						Then I type $override_pick_qty in element "name:untqty" in web browser within $max_response seconds
						And I unassign variable "override_pick_qty"
					EndIf
					And I press keys "ENTER" in web browser 

				And I "press enter to confirm UOM and complete Pick"
					Then I assign "UOM" to variable "input_field_with_focus"
					And I execute scenario "Mobile Check for Input Focus Field"

					If I verify variable "override_uomcod" is assigned
						Then I clear all text in element "name:uomcod" in web browser within $max_response seconds
						And I type $override_uomcod in element "name:uomcod" in web browser within $max_response seconds
						And I unassign variable "override_uomcod"
					EndIf
					And I press keys "ENTER" in web browser 
        
				And I "enter the Carton Number"
					Then I assign "To ID" to variable "input_field_with_focus"
					And I execute scenario "Mobile Check for Input Focus Field"

					Then I type $ctnnum in element "name:dstlod" in web browser within $max_response seconds
					And I press keys "ENTER" in web browser
					And I wait $wait_short seconds 

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

				Then I "validate that the carton is complete"
					And I assign "Carton Is Complete" to variable "mobile_dialog_message"
					Then I execute scenario "Mobile Set Dialog xPath"
					If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
						Then I press keys "ENTER" in web browser
					EndIf

				And I "validate that the batch is complete"
					Then I assign "Batch is Complete" to variable "mobile_dialog_message"
					And I execute scenario "Mobile Set Dialog xPath"
					If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
						Then I press keys "ENTER" in web browser
						If I verify variable "skip_deposit_logic" is assigned
						And I verify text $skip_deposit_logic is equal to "TRUE"
                            Then I assign "TRUE" to variable "carton_loop_done"
							And I unassign variable "skip_deposit_logic"
						Else I execute scenario "Mobile Deposit After Carton Picking"
						EndIf
					EndIf

				And I "check for an invalid Device State"
					If I see "Invalid " in web browser within $wait_short seconds 
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
#	Mobile Deposit After Carton Picking - Perform Post Carton Picking deposit
#	Mobile Build Batch for Undirected Carton Picking - Adds a single carton number to the batch
# 	Mobile Undirected Carton Picking Cancel and Reallocate - Cancels and reallocates an entire batch of carton picking
#	Get Carton Number by Order for Undirected Carton Picking - Checks whether Carton Picks exist for specified order.
#	Get Source ID for Carton Pick - Determine that correct source inventory Id, Prtnum, Srcloc for a carton pick 
#############################################################

@wip @private
Scenario: Mobile Deposit After Carton Picking
#############################################################
# Description: Perform Post Carton Picking deposit.  
# This should be replaced by standard deposit scenario
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
	While I see " Deposit" in element "className:appbar-title" in web browser within $wait_long seconds
		Then I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'dsploc')]/descendant::span[contains(@class,'data')]" in web browser to variable "dep_loc" within $screen_wait seconds
        
        And I "scan the value in the screen, converting to verification code if needed"
            Given I assign $dep_loc to variable "verify_location"
            And I execute scenario "Get Location Verification Code"
            
            When I type $location_verification_code in web browser
			And I press keys "ENTER" in web browser
            And I wait $wait_med seconds 
	EndWhile
    
@wip @private
Scenario: Mobile Build Batch for Undirected Carton Picking
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
	Once I see "Build Batch" in element "className:appbar-title" in web browser

	And I assign "Carton Number" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $ctnnum in element "name:subnum" in web browser within $max_response seconds
    Then I press keys "ENTER" in web browser
	And I wait $wait_short seconds 

And I "verify it is added to the pick batch"
	If I see "Added to Batch" in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	Else I fail step with error message "ERROR: Batch build error"
	EndIf