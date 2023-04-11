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
# Utility: Terminal Pallet Picking Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
# 
# Description:
# Utilities to perform Pallet Picking
#
# Public Scenarios:
#   - Perform Pallet Pick for Order - Performs all Pallet Picks associated with an Order
#   - Perform Undirected Pallet Pick for Order - Performs all Pallet Picks via Undirected associated with an Order
#	- Navigate to Pick Product Screen - Navigate to the Pick Product screen.
#
# Assumptions:
# 	None
#
# Notes:
# - See Scenario Headers for required inputs.
#
############################################################
Feature: Terminal Pallet Picking Utilities

@wip @public
Scenario: Perform Pallet Pick for Order
#############################################################
# Description: From the Directed Work screen, given an order number/operation code/username, performs the entirety of the associated pallet picks.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		oprcod - set to the pallet picking operation code
#		username - the user assigned to or user to assign to
#   	ordnum - The order that will be pallet picked
#   Optional:
#		cancel_and_reallocate - Will cancel the Carton Pick and reallocate if set to "true"
# Outputs:
#	None
#############################################################

Given I "wait some time for pallet picks to release" which can take between $wait_long seconds and $max_response seconds 

Then I "obtain the Work Reference"
	And I execute scenario "Get Directed Work Picking Work Reference by Order Number and Operation"
	If I verify MOCA status is 0
	   Then I echo "We have got Pallet Picks"
	Else I assign variable "error_message" by combining "ERROR: We do not have any Pallet Picks. Exiting...."
		Then I fail step with error message $error_message
	EndIf 

When I "confirm Directed Work exists"
	If I see "Pickup Product At" in terminal within $wait_med seconds
		Then I echo "I'm good to proceed as there are directed works"
	Else I assign variable "error_message" by combining "ERROR: No Directed Picks found. Exiting..."
		Then I fail step with error message $error_message
	EndIf 

And I "perform all associated Pallet Picking"
	Then I assign "FALSE" to variable "DONE"
	While I see "Pickup Product At" in terminal within $wait_med seconds
	And I verify text $DONE is equal to "FALSE"
		Given I "verify screen has loaded for information to be copied off of it"
			Then I verify screen is done loading in terminal within $max_response seconds

		If I verify text $term_type is equal to "handheld"
			Then I copy terminal line 4 columns 1 through 20 to variable "srcloc"
		Else I verify text $term_type is equal to "vehicle"
			Then I copy terminal line 3 columns 20 through 40 to variable "srcloc"
		EndIf
		Given I execute MOCA command "[select ltrim(rtrim('" $srcloc "')) as srcloc from dual]"
		And I verify MOCA status is 0
		Then I assign row 0 column "srcloc" to variable "srcloc"

		And I execute scenario "Check Pick Directed Work Assignment by Operation and Location"
		If I verify MOCA status is 0
			Then I assign row 0 column "reqnum" to variable "reqnum"
			And I assign row 0 column "wh_id" to variable "wh_id"
 
			Then I echo "The Current Work (reqnum = " $reqnum ") is a Pallet Pick. Proceeding...."
			And I wait $wait_med seconds
			If I verify text $cancel_and_reallocate is equal to "true"
				Then I execute scenario "Pallet Picking Directed Cancel and Reallocate Process Detail"
			Else I verify text $cancel_and_reallocate is not equal to "true"
				Then I execute scenario "Pallet Picking Process Detail"
				And I execute scenario "Get Directed Work Picking Work Reference by Order Number and Operation"
				If I verify variable "cnz_mode" is assigned
				And I verify text $cnz_mode is equal to "TRUE" ignoring case
					And I execute scenario "Check for Count Near Zero Prompt"
				EndIf
            	Then I press keys "F6" in terminal
				And I wait $wait_med seconds 
				Then I execute scenario "Terminal Deposit"
			EndIf
		Else I echo "The current work is not a pallet pick or the work is not assigned to the current user. Exiting..."
			And I assign "TRUE" to variable "DONE"
		EndIf 
	EndWhile

@wip @public
Scenario: Perform Undirected Pallet Pick for Order
#############################################################
# Description: From the Directed Work screen, given an order number/operation code/username, performs the entirety of the associated pallet picks.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		oprcod - set to the pallet picking operation code
#		username - the user assigned to or user to assign to
#   	ordnum - The order that will be pallet picked
#   Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "perform Order Pallet picks"
	And I assign "FALSE" to variable "DONE"
	While I see "Product Pickup" in terminal within $wait_med seconds 
	And I verify text $DONE is equal to "FALSE"
		Then I execute scenario "Get Pallet Pick Undirected Work by Order Number and Operation"
		If I verify MOCA status is 0
			Given I assign row 0 column "wrkref" to variable "wrkref"
			And I assign row 0 column "wh_id" to variable "wh_id"
			
			And I echo "The Current Work (wrkref = " $wrkref ") is a Pallet Pick. Proceeding...."
			And I wait $wait_med seconds 
			
			When I execute scenario "Pallet Picking Undirected Process Detail"
            Then I press keys "F6" in terminal
			And I wait $wait_med seconds 
			Then I execute scenario "Terminal Deposit"
		Else I echo "No Picks. Exiting..."
			And I assign "TRUE" to variable "DONE"
		EndIf 
	EndWhile 
	
@wip @public
Scenario: Navigate to Pick Product Screen
#############################################################
# Description: This scenario Navigates to Pick Product screen
# MSQL Files:
#	None
# Inputs:
#     Required:
#       None
#   Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "ensure I am at the Undirected Menu"
	If I see "Undirected Menu" in terminal within $wait_long seconds
	Else I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	EndIf

Once I see "Undirected Menu" in terminal
And I type option for "Picking Menu" menu in terminal

Once I see "Picking Menu" on line 1 in terminal 
And I "open the Picking Menu"
	When I type option for "Pick Product" menu in terminal
	If I see "Product Pickup" in terminal within $wait_med seconds 
		Then I echo "I'm good to proceed"
	Else I assign variable "error_message" by combining "ERROR: Expected Product Pickup screen not found in terminal"
		Then I fail step with error message $error_message
	EndIf

#############################################################
# Private Scenarios:
#	Get Pallet Pick Undirected Work by Order Number and Operation - Obtains a work reference number (wrkref) for a pick.
#   Pallet Picking Process Detail - performs an individual Pallet Pick
# 	Pallet Picking Directed Cancel and Reallocate Process Detail - cancels and reallocates an individual Pallet Pick via Undirected
#   Pallet Picking Undirected Process Detail - performs an individual Pallet Pick via Undirected
#	Get Directed Work Picking Work Reference by Order Number and Operation - Checks whether Pallet Picks exist for specified order.
#	Get Pallet Number from Source Location for Picking - Obtains Load Number of Pallet with specified Part Number exist in specified location.
#############################################################

@wip @private
Scenario: Pallet Picking Process Detail
#############################################################
# Description: This scenario performs Pallet Picking to completion from the Directed Work screen.
# MSQL Files:
#	None
# Inputs:
#    Required:
#       None
#   Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "Press Enter to Acknowledge"
	When I press keys "ENTER" in terminal
	Once I see "Order Pick" in terminal
	And I "verify screen has loaded for information to be copied off of it"
		Then I verify screen is done loading in terminal within $max_response seconds
	
And I "get the pallet pick source location from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 2 columns 5 through 20 to variable "srcloc"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 2 columns 5 through 29 to variable "srcloc"
	EndIf
    Given I execute MOCA command "[select ltrim(rtrim('" $srcloc "')) as srcloc from dual]"
	And I verify MOCA status is 0
	Then I assign row 0 column "srcloc" to variable "srcloc"

And I "get the part number to be picked from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 5 columns 5 through 20 to variable "prtnum"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 3 columns 26 through 40 to variable "prtnum"
	EndIf 
 
And I "get the client ID to be picked from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 11 columns 5 through 20 to variable "client_id"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 7 columns 5 through 20 to variable "client_id"
	EndIf 
 
And I "get a pallet number from the pick location to be the pallet we will pick"
	Given I execute scenario "Get Pallet Number from Source Location for Picking"
	If I verify MOCA status is 0
		Then I assign row 0 column "lodnum" to variable "srclod"
	Else I assign variable "error_message" by combining "ERROR: The inventory in this location is not equal to what we expect to pick"
		Then I fail step with error message $error_message
	EndIf 
 
When I "enter the pallet number we are picking to complete the pallet pick"
	When I enter $srclod in terminal

@wip @private
Scenario: Pallet Picking Directed Cancel and Reallocate Process Detail
#############################################################
# Description: This scenario cancels each Pallet Pick in a batch and sends it to Reallocation
# MSQL Files:
#	None
# Inputs:
#    Required:
#       None
#   Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "Press Enter to Acknowledge"
	When I press keys "ENTER" in terminal
	Once I see "Order Pick" in terminal 
 
When I "navigate to the tools menu and cancel the pallet pick"
	When I press keys "F7" in terminal
	Once I see "Tools Menu" in terminal
	
And I "cancel the pallet pick"
	Given I type "5" in terminal
	Once I see "Cancel Pick" in terminal
	And I enter "C-RA" in terminal
	And I wait $wait_short seconds
	And I press keys "ENTER" in terminal
	Once I see "OK To Cancel Pick?" in terminal
	When I type "Y" in terminal
	Once I see "Pick Successfully" in terminal
	And I press keys "ENTER" in terminal
	Once I see "Tools Menu" in terminal
	Then I wait $wait_short seconds
	And I press keys "F1" in terminal

@wip @private
Scenario: Pallet Picking Undirected Process Detail
#############################################################
# Description: This scenario performs List Picking to completion from the Product Pickup screen.
# MSQL Files:
#	None
# Inputs:
#     Required:
#       wrkref - the Work Reference Number
#   Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "enter the Work Reference"
	Once I see "Work Task" in terminal  
	And I wait $wait_short seconds 
	Then I enter $wrkref in terminal
	Once I see "Order Pick" in terminal
	And I "verify screen has loaded for information to be copied off of it"
		Then I verify screen is done loading in terminal within $max_response seconds
 
When I "get the pallet pick source location from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 2 columns 5 through 20 to variable "srcloc"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 2 columns 5 through 29 to variable "srcloc"
    	Given I execute MOCA command "[select ltrim(rtrim('" $srcloc "')) as srcloc from dual]"
		And I verify MOCA status is 0
		Then I assign row 0 column "srcloc" to variable "srcloc"
	EndIf 
 
And I "get the part number to be picked from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 5 columns 5 through 20 to variable "prtnum"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 3 columns 26 through 40 to variable "prtnum"
	EndIf 
 
And I "get the client ID to be picked from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 11 columns 5 through 20 to variable "client"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 7 columns 5 through 20 to variable "client"
	EndIf 
 
And I "get a pallet number from the pick location to be the pallet we will pick"
	Given I execute scenario "Get Pallet Number from Source Location for Picking"
	If I verify MOCA status is 0
		 Then I assign row 0 column "lodnum" to variable "srclod"
	Else I assign variable "error_message" by combining "ERROR: The inventory in this location is not equal to what we expect to pick"
		Then I fail step with error message $error_message
	EndIf 
 
When I "enter the pallet number we are picking to complete the List Pick"
	When I enter $srclod in terminal

@wip @private
Scenario: Get Pallet Pick Undirected Work by Order Number and Operation
#############################################################
# Description: Obtains a work reference number (wrkref) for a pick.
# MSQL Files:
#	get_undirected_pallet_pick_work_reference_by_order_and_operation_code.msql
# Inputs:
# 	Required:
#   	oprcod - Operation Code.
#		ordnum - Order Number associated with this pick.
# 	Optional:
#       None
# Outputs:
#	wrkref - the Work Reference number associated with this order.
#############################################################

When I "search for wrkref given the above variables"
	Given I assign "get_undirected_pallet_pick_work_reference_by_order_and_operation_code.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	
@wip @private
Scenario: Get Directed Work Picking Work Reference by Order Number and Operation
#############################################################
# Description: Returns MOCA status of 0 when there are 
# Pallet Picks found in MOCA for this order.
# MSQL Files:
#	get_picking_work_reference_directed_work_by_order_and_operation_code.msql
# Inputs:
# 	Required:
#   	oprcod - Operation Code.
#		ordnum - Order Number associated with this pick.
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

When I "search for any existing Pallet Picks"
	Given I assign "get_picking_work_reference_directed_work_by_order_and_operation_code.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    	
@wip @private
Scenario: Get Pallet Number from Source Location for Picking
############################################################
# Description: Returns MOCA status of 0 when there are 
# Pallets in the specified location containing the 
# Part Number specified.
# MSQL Files:
#	get_pallet_number_from_source_location_for_picking.msql
# Inputs:
# 	Required:
#		srcloc - Source Location
#		prtnum - Part Number
# 	Optional:
#       None
# Outputs:
#	lodnum - Load Number associated with this pallet.
#############################################################

When I "search MOCA for a pallet number in this location with the specified prtnum."
	Given I assign "get_pallet_number_from_source_location_for_picking.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"