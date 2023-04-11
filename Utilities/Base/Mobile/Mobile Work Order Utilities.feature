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
# Utility: Mobile Work Order Utilities.feature
# 
# Functional Area: Production
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description:
# This Utility contains scenarios that perform actions specific to work order processing in the Mobile App
#
# Public Scenarios:
#	- Mobile Move Inventory to Workstation - moves picked work order inventory to workstation
#	- Mobile Pick Work Order - Uses Directed Work to pick Work Order and deposit
#	- Mobile Directed Work Order Case Picking - performs Directed Work picking 
#	- Mobile Receive Finished Goods - receives work order finished goods
#
# Assumptions:
# - Supporting MOCA scenarios are in Terminal Work Order Utilities.feature
#
# Notes:
# None
# 
############################################################
Feature: Mobile Work Order Utilities

@wip @public
Scenario: Mobile Move Inventory to Workstation
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
	Then I "login, transfer, and logout through each LPN associated to the Work Order"
		While I verify text $srcloc is not equal to ""
		And I verify text $dstloc is not equal to ""
		And I verify text $xfer_lodnum is not equal to ""
        	Then I execute scenario "Mobile Navigate to Inventory Transfer Menu"
			When I execute scenario "Mobile Inventory Transfer Undirected"
			Then I execute scenario "Mobile Navigate Quickly to Undirected Menu"	
			And I execute scenario "Get Next LPN to Move for Work Order"
		EndWhile

@wip @public
Scenario: Mobile Pick Work Order
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
			And I execute scenario "Mobile Directed Work Order Case Picking"
			
		Then I "deposit the picked inventory to the staging location"
			And I "wait for directed work to search/settle" which can take between $wait_med seconds and $wait_long seconds
			When I press keys "F6" in web browser
			If I see " Deposit" in element "className:appbar-title" in web browser within $wait_long seconds
			Else I echo "Retrying F6 operation"
			     And I press keys "F6" in web browser
			EndIf
			When I execute scenario "Mobile Deposit"
			Then I press keys "F1" in web browser
			And I "wait completion of desposit" which can take between $wait_med seconds and $wait_long seconds
			
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
			And I execute scenario "Mobile Navigate to Directed Work Menu"
	EndWhile 

@wip @public
Scenario: Mobile Directed Work Order Case Picking
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
	If I see "Pickup Product At" in element "className:appbar-title" in web browser within $wait_long seconds
		Then I echo "I'm good to proceed as there are directed picks"
		Else I fail step with error message "ERROR: There are no directed picks. Exiting..."
	EndIf

And I "press Enter to Acknowledge to get work"
	Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
	Then I press keys "ENTER" in web browser
	Once I see "Wrk Order Pick" in element "className:appbar-title" in web browser

When I "process the Picks"
	If I verify variable "cancel_no_realloc" is assigned
	And I verify text $cancel_no_realloc is equal to "Yes" ignoring case
		Then I assign "C-N-R" to variable "cancel_code"
		And I assign "FALSE" to variable "error_location_flag"
		Then I execute scenario "Mobile Cancel Pick from Tools Menu"
	Else I "perform the Pick"
		Given I "read the Source Location"
			Then I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'dsploc')]/descendant::span[contains(@class,'data')]" in web browser to variable "srcloc" within $max_response seconds
			
		And I "read the Part Number"
			Then I copy text inside element "xPath://span[contains(text(),'Item Number')]/ancestor::aq-displayfield[contains(@id,'dspprt')]/descendant::span[contains(@class,'data')]" in web browser to variable "prtnum" within $max_response seconds
			
	   	When I "check whether the location has multiple loads that can be picked"
			And I assign "Inventory Identifier" to variable "input_field_with_focus"
			If I see $input_field_with_focus in web browser within $screen_wait seconds
				Then I assign "TRUE" to variable "pick_by_lodnum"
			EndIf
		
		If I verify variable "pick_by_lodnum" is assigned
		And I verify text $pick_by_lodnum is equal to "TRUE" ignoring case
			When I "enter the Lodnum"
				Given I assign $srcloc to variable "stoloc"
				And I assign $rcvqty to variable "untqty"
				Then I execute scenario "Get LPN Based on Location and Quantity"
				And I assign "Item Number" to variable "input_field_with_focus"
				Then I execute scenario "Mobile Check for Input Focus Field"
				And I type $lodnum in element "name:prtnum" in web browser within $max_response seconds
				Then I press keys "ENTER" in web browser
		Else I "am not picking by a Load Number - there is only a single load to pick at this location"
			When I "enter the Part Number"
				Then I assign "Item Number" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"
				Then I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
				And I press keys "ENTER" in web browser

			And I "enter the Quantity to Pick"
				Then I assign "Quantity" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"
				If I verify variable "short_pick" is assigned
				And I verify text $short_pick is equal to "Yes"
					Then I assign "Yes" to variable "cancel_no_realloc"
					And I clear all text in element "name:untqty" in web browser within $max_response seconds
					And I type "1" in element "name:untqty" in web browser within $max_response seconds
				EndIf 
				Then I press keys "ENTER" in web browser

			And I "accept the UoM field"
				Then I assign "UOM" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"
				Then I press keys "ENTER" in web browser

			Then I "get the next LPN number to pick to"
				And I assign next value from sequence "lodnum" to "to_id"
				Then I assign "To ID" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"
				And I type $to_id in element "name:dstlod" in web browser within $max_response seconds
				And I press keys "ENTER" in web browser
				And I wait $screen_wait seconds
		Endif
	EndIf 
	
@wip @public
Scenario: Mobile Receive Finished Goods
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
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Production Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Production" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Production') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Production" in element "className:appbar-title" in web browser

And I "enter the Production Line"
	Then I assign "Production Line" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $prdlin in element "name:prdlin" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $screen_wait seconds

And I "enter the Work Order Number, if necessary"
	If I do not see "Receive Product" in web browser within $screen_wait seconds
		Then I assign "Work Order Number" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $wkonum in web browser
		And I press keys "ENTER" in web browser
	Endif
	
And I "enter the Client, if necessary"
	If I do not see "Receive Product" in web browser within $screen_wait seconds
		Then I assign "Client ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $client_id in web browser
		And I press keys "ENTER" in web browser
	Endif
	
And I "enter the Work Order Revision, if necessary"
	If I do not see "Receive Product" in web browser within $screen_wait seconds
		Then I assign "Work Order Revision" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $wkorev in web browser
		And I press keys "ENTER" in web browser
	Endif

And I "am on the Receive Product page"
	Once I see "Receive Product" in element "className:appbar-title" in web browser

When I "generate a load number"
	Then I assign "LPN" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "F3" in web browser
	And I wait $wait_short seconds
	And I press keys "ENTER" in web browser

And I "skip the Case field"
	Then I assign "Units Per" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "ENTER" in web browser

And I "input the Receiving Quantity"
	Then I assign "Receive Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $rcvqty in element "name:rcvqty" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "skip the UoM Field"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "ENTER" in web browser

And I "skip the Status Field"
	Then I assign "Inventory Status" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "ENTER" in web browser

	And I assign "status." to variable "mobile_dialog_message"
	Then I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
		And I fail step with error message "ERROR: User with this role is not able to change this inventory status - See Config - Inventory - Inventory Status - Inventory Status Settings"
	EndIf

And I "handle the over consumption message"
	Then I assign "Cns exceeds Dlv Qty" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		If I verify variable "over_consumption" is assigned
			 If I verify text $over_consumption is equal to "TRUE"
				Then I press keys "Y" in web browser
			 Else I press keys "N" in web browser
				 And I assign 1 to variable "overConsOccured"
				 And I fail step with error message "ERROR: Over Consumption would occur but is not allowed"
			 EndIf
	   Else I press keys "N" in web browser
			And I fail step with error message "ERROR: Over Consumption would occur but is now allowed"
	   EndIf
	EndIf

And I "create inventory"
	Then I assign "OK To Create Inventory?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
   	Then I type "Y" in web browser

And I "check for overconsumption"
	Then I assign "work order lines for" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
	   Then I fail step with error message "ERROR: No valid work order lines found. Policy WORK-ORDER-PROCESSING / ALLOW-CNS-UNEXPECTED / MISCELLANEOUS not set for overconsumption"
	EndIf
	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing"

Then I "deassign dep_loc variable that was set when moving components to production line to prevent putaway to the production line rather than the allocated location"
	If I verify variable "dep_loc" is assigned
		Then I assign "" to variable "dep_loc"
	EndIf

And I "select Directed Putaway"
	Once I see "Product Putaway" in element "className:appbar-title" in web browser
	Then I press keys "1" in web browser

And I "deposit Product"
	Then I execute scenario "Mobile Deposit"

############################################################
# Private Scenarios:
#   None
############################################################