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
# Utility: Terminal Work Order Utilities.feature
# 
# Functional Area: Production
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# This Utility contains scenarios that perform actions specific to work order processing in the Terminal
#
# Public Scenarios:
#	- Terminal Move Inventory to Workstation - moves picked work order inventory to workstation
#	- Get Next LPN to Move for Work Order - queries for available work order inventory to move
#	- Get Work Order Type Description - gets the work order type description
#	- Get Inventory Status Description - gets the inventory status description
#	- Terminal Pick Work Order - Uses Directed Work to pick Work Order and deposit
#	- Terminal Directed Work Order Case Picking - performs Directed Work picking 
#	- Terminal Receive Finished Goods - receives work order finished goods
#
# Assumptions:
# None
#
# Notes:
# None
# 
############################################################
Feature: Terminal Work Order Utilities

@wip @public
Scenario: Terminal Move Inventory to Workstation
#############################################################
# Description: This scenario moves picked work order inventory to Workstation.
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

Given I execute scenario "Get Next LPN to Move for Work Order"
	Given I "login, transfer, and logout through each LPN associated to the Work Order"
		While I verify text $srcloc is not equal to ""
		And I verify text $dstloc is not equal to ""
		And I verify text $xfer_lodnum is not equal to ""
        	Then I execute scenario "Terminal Navigate to Inventory Transfer Menu"
			When I execute scenario "Terminal Inventory Transfer Undirected"
			Then I execute scenario "Terminal Navigate Quickly to Undirected Menu"
			And I execute scenario "Get Next LPN to Move for Work Order"
		EndWhile

@wip @public
Scenario: Terminal Pick Work Order
#############################################################
# Description: This scenario uses directed work to pick work order inventory and deposit
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

When I "perform all Picks associated with the Work Order"
	While I verify number $work_order_picks is equal to 1
	   	When I "execute the directed (case) picks"
			And I execute scenario "Terminal Directed Work Order Case Picking"
			And I wait $wait_med seconds
			
		Then I "deposit the picked inventory to the staging location"
			Given I press keys "F6" in terminal
			And I wait $wait_med seconds
			When I execute scenario "Terminal Deposit"
			Then I press keys "F1" in terminal
			
		And I "look for any other picks for this work order"
			Then I execute scenario "Assign Work Order Picks to User"
			If I verify MOCA status is 0
				Then I assign 1 to variable "work_order_picks"
			Elsif I verify MOCA status is 510
				Then I assign 0 to variable "work_order_picks"
			Else I "received an unexpected MOCA Status"
				Then I fail step with error message "ERROR: error occured while getting work for work order"
			EndIf

		Then I "navigate back to directed work menu"
			And I execute scenario "Terminal Navigate to Directed Work Menu"
	EndWhile 

@wip @public
Scenario: Terminal Directed Work Order Case Picking
#############################################################
# Description: This scenario performs the picking action for work order picking
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		srclod - the source LPN to pick from
#	Optional:
#		cancel_no_realloc - Set to "Yes" to set picking to cancel without reallocation
# Outputs:
# 	None
#############################################################

Given I "check for Directed Picks"
	If I see "Pickup Product At" in terminal within $max_response seconds 
		Then I echo "I'm good to proceed as there are directed picks"
		Else I fail step with error message "ERROR: There are no directed picks. Exiting..."
	EndIf

And I "Press Enter to Acknowledge to get work"
	When I press keys "ENTER" in terminal
	Once I see "Wrk Order Pick" in terminal
	And I "verify screen has loaded for information to be copied off of it"
		Then I verify screen is done loading in terminal within $max_response seconds

When I "Process the Picks"
	If I verify variable "cancel_no_realloc" is assigned
	And I verify text $cancel_no_realloc is equal to "Yes"
		Given I "open the Tools Menu"
			Given I press keys "F7" in terminal
			Once I see "Tools Menu" in terminal
			
	  	When I "cancel the Pick"
			When I type option for "Cancel Pick" menu in terminal
			And I type "C-N-R" in terminal
			And I press keys "ENTER" in terminal
			And I type "N" in Terminal
			And I press keys "ENTER" in terminal
		
		And I "confirm the cancellation"
			Once I see "OK To Cancel Pick?" in terminal
			Then I type "Y" in terminal
			Once I see "Pick Canceled" in terminal
			Then I press keys "ENTER" in terminal
			
		Then I "exit the Tools Menu"
			Once I see "Tools Menu" in terminal 
			Then I press keys "F1" in terminal
	Else I "perform the Pick"
		Given I "read the Source Location"
			If I verify text $term_type is equal to "handheld"
				Then I copy terminal line 2 columns 6 through 20 to variable "srcloc"
			Else I verify text $term_type is equal to "vehicle"
				Then I copy terminal line 2 columns 6 through 29 to variable "srcloc"
			EndIf 
			
		And I "read the Part Number"
			If I verify text $term_type is equal to "handheld"
				Then I copy terminal line 5 columns 6 through 20 to variable "prtnum"
			Else I verify text $term_type is equal to "vehicle"
				Then I copy terminal line 3 columns 26 through 40 to variable "prtnum"
			EndIf 
			
	   	When I "check whether the location has multiple loads that can be picked"
			If I verify text $term_type is equal to "handheld"
				If I see cursor at line 8 column 6 in terminal within $screen_wait seconds
					Then I assign "true" to variable "pick_by_lodnum"
				Endif
			Else I verify text $term_type is equal to "vehicle"
				If I see cursor at line 5 column 6 in terminal within $screen_wait seconds
					Then I assign "true" to variable "pick_by_lodnum"
				Endif
			Endif
		
		If I verify variable "pick_by_lodnum" is assigned
		And I verify text $pick_by_lodnum is equal to "true"
			When I "enter the Lodnum"
				Given I assign $srcloc to variable "stoloc"
				And I assign $rcvqty to variable "untqty"
				And I execute scenario "Get LPN Based on Location and Quantity"
				Then I enter $lodnum in terminal
				
		Else I "am not picking by a Load Number - there is only a single load to pick at this location"
			When I "enter the Part Number"
				If I verify text $term_type is equal to "handheld"
					Once I see cursor at line 10 column 6 in terminal 
				Else I verify text $term_type is equal to "vehicle"
					Once I see cursor at line 6 column 6 in terminal 
				Endif
				Then I enter $prtnum in terminal

			And I "enter the Quantity to Pick"
				If I verify text $term_type is equal to "handheld"
					Once I see cursor at line 13 column 6 in terminal 
				Else I verify text $term_type is equal to "vehicle"
					Once I see cursor at line 8 column 6 in terminal 
				Endif
				If I verify variable "short_pick" is assigned
				And I verify text $short_pick is equal to "Yes"
					Then I assign "Yes" to variable "cancel_no_realloc"
					And I execute scenario "Terminal Clear Field"
					And I enter "1" in terminal
				EndIf 
				Then I press keys "ENTER" in terminal

			And I "accept the UoM field"
				If I verify text $term_type is equal to "handheld"
					Once I see cursor at line 13 column 15 in terminal 
				Else I verify text $term_type is equal to "vehicle"
					Once I see cursor at line 8 column 15 in terminal 
				Endif
				Then I press keys "ENTER" in terminal

			Then I "get the next LPN number to pick to"
				Then I assign next value from sequence "lodnum" to "to_id"
				And I enter $to_id in terminal
		Endif
	EndIf 
	
@wip @public
Scenario: Terminal Receive Finished Goods
#############################################################
# Description: This scenario receives the work order finished goods
# MSQL Files:
#	None
# Inputs:
#     Required:
#         prdlin - Production Line
#         client_id - Client ID
#         wkonum - Work Order number
#         wkorev - Work Order revision
#         rcvqty - Receive Qty
#     Optional:
#         over_consumption - Over Consumption allowed flag TRUE/FALSE
# Outputs:
# 	None
#############################################################

Given I "navigate to the Production screen"
	Once I see "Undirected" in terminal
    
    If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal 
	Endif

	And I wait $screen_wait seconds
	Then I type option for "Production Menu" menu in terminal
	And I wait $screen_wait seconds
    
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal 
	Endif
	Then I type option for "Production" menu in terminal

And I "enter the Production Line"
	Once I see "Prod Line:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 1 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 11 in terminal 
	Endif
	Then I enter $prdlin in terminal
	And I wait $screen_wait seconds

And I "enter the Work Order Number, if necessary"
	If I do not see "Receive Product" in terminal within $screen_wait seconds
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 6 column 1 in terminal 
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 4 column 11 in terminal 
		Endif
		Then I enter $wkonum in terminal
		And I wait $screen_wait seconds
	Endif
	
And I "enter the Client, if necessary"
	If I do not see "Receive Product" in terminal within $screen_wait seconds
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 10 column 1 in terminal 
		Else I verify text $term_type is equal to "vehicle"
			# NEED column,row for WIDE
			Once I see cursor at line 10 column 1 in terminal 
		Endif
		Then I enter $client_id in terminal
		And I wait $screen_wait seconds
	Endif
	
And I "enter the Work Order Revision, if necessary"
	If I do not see "Receive Product" in terminal within $screen_wait seconds
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 12 column 12 in terminal 
		Else I verify text $term_type is equal to "vehicle"
			# NEED column,row for WIDE
			Once I see cursor at line 12 column 12 in terminal 
		Endif
		Then I enter $wkorev in terminal
		And I wait $screen_wait seconds
	Endif

And I "am on the Receive Product page"
	Once I see "Receive Product" in terminal 

When I "generate a load number"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 6 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 6 in terminal 
	EndIf
	And I wait $screen_wait seconds
	Then I press keys "F3" in terminal
	And I wait $screen_wait seconds
	And I press keys "ENTER" in terminal

And I "skip the Case field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 11 column 6 in terminal  
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 22 in terminal 
	EndIf
	Then I press keys "ENTER" in terminal

And I "input the Receiving Quantity"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 8 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 8 in terminal 
	EndIf
	And I enter $rcvqty in terminal

And I "skip the UoM Field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 17 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 18 in terminal
	EndIf
	Then I press keys "ENTER" in terminal

And I "skip the Status Field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 14 column 16 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 37 in terminal 
	EndIf
	Then I press keys "ENTER" in terminal
	If I see error message "status." in terminal
		Then I press keys "ENTER" in terminal
		And I fail step with error message "ERROR: User with this role is not able to change this inventory status - See Config - Inventory - Inventory Status - Inventory Status Settings"
	EndIf

And I "handle the over consumption message"
	If I see error message "Cns exceeds Dlv Qty" in terminal
		If I verify variable "over_consumption" is assigned
			 If I verify text $over_consumption is equal to "TRUE"
				Then I type "Y" in terminal
			 Else I type "N" in terminal
				 And I assign 1 to variable "overConsOccured"
				 And I fail step with error message "ERROR: Over Consumption would occur but is not allowed"
			 EndIf
	   Else I type "N" in terminal
			And I fail step with error message "ERROR: Over Consumption would occur but is now allowed"
	   EndIf
	EndIf

And I "create inventory"
	Once I see "OK To Create" in terminal
   	Then I type "Y" in terminal

And I "check for overconsumption"
	If I see error message "work order lines for" in terminal 
	   Then I fail step with error message "ERROR: No valid work order lines found. Policy WORK-ORDER-PROCESSING / ALLOW-CNS-UNEXPECTED / MISCELLANEOUS not set for overconsumption"
	EndIf
	Then I press keys "F6" in terminal

Then I "deassign dep_loc variable that was set when moving components to production line to prevent putaway to the production line rather than the allocated location"
	If I verify variable "dep_loc" is assigned
		Then I assign "" to variable "dep_loc"
	EndIf

And I "select Directed Putaway"
	Once I see "Product Putaway" in terminal 
	Then i type "1" in terminal

And I "Deposit Product"
	Then I execute scenario "Terminal Deposit"

@wip @public
Scenario: Get Next LPN to Move for Work Order
#############################################################
# Description: This scenario queries for available work order inventory to move to a work station for processing.
# MSQL Files:
#	get_lpn_to_move_to_workstation.msql
# Inputs:
#   Required:
#       wkonum - Work Order Number
#       wkorev - Work Order revision
#       client_id - Client ID
#	Optional:
#		None
# Outputs:
#     srcloc - Source location of the inventory
#     dstloc - Destination location of the inventory
#     xfer_lodnum - LPN being moved
#     prtnum - Part being moved
#     client_id - Client ID
#     ftpcod - Footprint code
#############################################################

Given I "assign MOCA environment variables and query for LPNs to move"
	Then I assign "get_lpn_to_move_to_workstation.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	
Given I "assign output to variables to process move"
	If I verify MOCA status is 0
		Then I assign row 0 column "srcloc" to variable "srcloc"
		And I assign row 0 column "dstloc" to variable "dstloc"
		And I assign row 0 column "lodnum" to variable "xfer_lodnum"
		And I assign row 0 column "prtnum" to variable "prtnum"
		And I assign row 0 column "client_id" to variable "client_id"
		And I assign row 0 column "ftpcod" to variable "ftpcod"
	Elsif I verify MOCA status is 510
	 	Then I assign "" to variable "srcloc"
	 	And I assign "" to variable "dstloc"
	 	And I assign "" to variable "xfer_lodnum"
	Else I fail step with error message "ERROR: Error getting the inventory to move"
	EndIf 
	
@wip @public
Scenario: Get Work Order Type Description
#############################################################
# Description: This scenario gets the work order type description based on a work order type
# MSQL Files:
#	get_work_order_type_description.msql
# Inputs:
#   Required:
#       wko_typ - Work Order Type
#	Optional:
#		None
# Outputs:
#   wko_typ_description - Work order type description
#############################################################

When I "get the description associated to the Work Order Type"
	Then I assign "get_work_order_type_description.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
	And I assign row 0 column "lngdsc" to variable "wko_typ_description"

@wip @public
Scenario: Get Inventory Status Description
#############################################################
# Description: Based on the Inventory Status, gets the associated description
# MSQL Files:
#	get_inventory_status_description.msql
# Inputs:
#   Required:
#       invsts - Inventory Status descriptions
#	Optional:
#		None
# Outputs:
# 	lngdsc - Inventory Status description
#############################################################

When I "get the description associated to the Inventory Status"
	Given I assign "get_inventory_status_description.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
	And I assign row 0 column "lngdsc" to variable "invsts_description"
	
@wip @public
Scenario: Get LPN Based on Location and Quantity
#############################################################
# Description: Gets a single lodnum based on location and minimum quantity
# MSQL Files:
#	get_lodnum_by_location_and_quantity.msql
# Inputs:
#   Required:
#   	untqty - the quantity to have at least
#		prtnum - the part number to filter by
#		stoloc - the storage location to filter by
#	Optional:
#		None
# Outputs:
# 	lodnum - the selected lodnum
#############################################################

When I "get a single LPN based on location and quantity"
	Given I assign "get_lodnum_by_location_and_quantity.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
	And I assign row 0 column "lodnum" to variable "lodnum"

############################################################
# Private Scenarios:
#   None
############################################################