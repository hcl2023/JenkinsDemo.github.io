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
# Utility: Mobile Inventory Utilities.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile
#
# Description:
# These Utility Scenarios perform actions specific to Mobile Inventory activities
#
# Public Scenarios:
#	- Mobile Inventory Adjustment Complete - Confirm the Inventory Adjustment
#	- Mobile Inventory Adjustment Add - Performs an Inventory Adjustment Add
#	- Mobile Inventory Adjustment Delete - Performs an Inventory adjustment Delete
#	- Mobile Inventory Adjustment Change - Performs an Inventory Adjustment increase or decrease
#	- Mobile Inventory Transfer Directed - Performs an Inventory transfer in directed mode
#	- Mobile Inventory Transfer Undirected - Performs an Inventory transfer
#	- Mobile Inventory Status Change - Performs an Inventory Status Change
#	- Mobile Inventory Putaway Directed Override - Perform putaway. If specified, will override location with F4
#	- Mobile Inventory Location Display - Inventory Location Display relative to specified location
#	- Mobile Inventory Display - Inventory display relative to lodnum and prtnum
#	- Mobile Partial Inventory Move - performs a Partial Inventory Move
#	- Mobile Inventory Transfer Invalid - Performs an inventory move to a storage trailer not at dock door.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Inventory Utilities

@wip @public
Scenario: Mobile Partial Inventory Move
#############################################################
# Description: This scenario performs a Partial Inventory Move
# MSQL Files:
#	None
# Inputs:
#	Required:
#		srclod - LPN to be transferred
#		dstloc - Location where LPN will be deposited
#		move_qty - Quantity to be moved
#	Optional:
#		srclod_list - Comma separate list of LPNs to be transferred
# Outputs:
# 	None           
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "F" ignoring case
		Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf

And I "validate I am on the partial inventory move screen"
	Once I see "Partial Inventory Move" in element "className:appbar-title" in web browser

And I "look to see if we have multiple LPNs to move"
	If I verify variable "srclod_list" is assigned
	And I verify text $srclod_list is not equal to ""
		Then I assign $srclod_list to variable "srclod_list_local"
	Else I assign $srclod to variable "srclod_list_local"
	EndIf
   
When I "input each LPN to be transferred"
	Then I assign 1 to variable "lodnum_cnt"
	While I assign $lodnum_cnt th item from "," delimited list $srclod_list_local to variable "srclod_local"
		When I "input the LPN to Be Transferred"
		And I assign "Source ID" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		And I type $srclod_local in element "name:src_id" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
    
		And I "scan the partial quantity"
			Then I assign "Quantity" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			And I clear all text in element "name:untqty" in web browser within $max_response seconds
			And I type $move_qty in element "name:untqty" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
        
			Then I "enter through the UOM field as I am not going to change it"
				And I assign "UOM" to variable "input_field_with_focus"
				Then I execute scenario "Mobile Check for Input Focus Field"
				And I press keys "ENTER" in web browser
	
			Once I see "Partial Inventory Move" in element "className:appbar-title" in web browser
			And I wait $screen_wait seconds

		And I increase variable "lodnum_cnt" by 1
	EndWhile
        
And I "press F6 to Deposit"
	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 
	Once I see " Deposit" in element "className:appbar-title" in web browser

And I "perform the Inventory Move"
	Given I assign $dstloc to variable "dep_loc"
	When I execute scenario "Mobile Deposit"

And I unassign variables "loc_to_check,lodnum_cnt,srclod_local,srclod_list_local"

@wip @public
Scenario: Mobile Inventory Location Display
#############################################################
# Description: Enter storage location and process information
# on Inventory Location Display screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - storage location for display
#	Optional:
#		generate_screenshot - if requested generate Mobile App screen shot
# Outputs:
#	None
#############################################################

Given I "enter storage location in inventory location display"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
And I "verify data on the screen"
	Once I see "Location Display" in element "className:appbar-title" in web browser
	Once I see "Location Status" in web browser

	Given I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'stoloc-display')]/descendant::span[contains(@class,'data')]" in web browser to variable "screen_stoloc" within $max_response seconds
	If I verify text $screen_stoloc is equal to $stoloc ignoring case
	Else I fail step with error message "ERROR: Could not verify location status on the screen"
	EndIf

	Given I assign $stoloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "P" ignoring case
		Then I assign "Partial" to variable "locsts_string"
	Elsif I verify text $location_status is equal to "F" ignoring case
		Then I assign "Full" to variable "locsts_string"
	Elsif I verify text $location_status is equal to "E" ignoring case
		Then I assign "Empty" to variable "locsts_string"
	Elsif I verify text $location_status is equal to "I" ignoring case
		Then I assign "Inventory Error" to variable "locsts_string"
	Else I fail step with error message "ERROR: Could not determine Location Status (locsts)"
	EndIf
    
	Given I copy text inside element "xPath://span[contains(text(),'Location Status')]/ancestor::aq-displayfield[contains(@id,'locsts')]/descendant::span[contains(@class,'data')]" in web browser to variable "screen_locsts" within $max_response seconds
	If I verify text $screen_locsts is equal to $locsts_string ignoring case
	Else I fail step with error message "ERROR: Could not verify location status on the screen"
	EndIf

And I "take a mobile screen shot if requested"
	If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I execute scenario "Mobile Generate Screenshot"
	EndIf

And I press keys "ENTER" in web browser

And I unassign variables "locsts_string,loc_to_check,screen_locsts"

@wip @public
Scenario: Mobile Inventory Display
#############################################################
# Description: Perform an inventory display relative to 
# lodnum and prtnum
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - storage location
#		lodnum - load number
#	Optional:
#		prtnum - part number
#		generate_screenshot - if requested generate Mobile App screen shot
# Outputs:
#	None
#############################################################

Given I "enter lodnum and prtnum (if specified) in inventory display"
	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $wait_short seconds

	Then I assign "Item Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	If I verify variable "prtnum" is assigned
	And I verify text $prtnum is not equal to "" ignoring case
		Then I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
		And I wait $wait_short seconds

		If I verify text $client_id is not equal to "----"
			Then I press keys "ENTER" in web browser
		EndIf
	Else I press keys "ENTER" in web browser
	EndIf
    
Then I "press enter through remaining fields in inventory display"
	While I do not see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser within $wait_med seconds
		Then I press keys "ENTER" in web browser
		And I wait $screen_wait seconds
	EndWhile

	Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
	Once I see "Inventory Dsp" in element "className:appbar-title" in web browser
	Once I see "LPN" in web browser

And I "move through all possible items relative to lodnum"
	Then I assign variable "more_dsp_data" by combining "TRUE"
	While I verify text $more_dsp_data is equal to "TRUE" ignoring case
		Then  I "verify data on the screen"
			If I verify variable "prtnum" is assigned
			And I verify text $prtnum is not equal to "" ignoring case
				Then I copy text inside element "xPath://span[contains(text(),'Item Number')]/ancestor::aq-displayfield[contains(@id,'prtnum')]/descendant::span[contains(@class,'data')]" in web browser to variable "screen_prtnum" within $max_response seconds
				If I verify text $screen_prtnum is equal to $prtnum ignoring case
				Else I fail step with error message "ERROR: Could not verify prtnum on the screen"
				EndIf
			EndIf

			Given I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'stoloc')]/descendant::span[contains(@class,'data')]" in web browser to variable "screen_stoloc" within $max_response seconds
			If I verify text $screen_stoloc is equal to $stoloc ignoring case
			Else I fail step with error message "ERROR: Could not verify stoloc on the screen"
			EndIf
                
			Given I copy text inside element "xPath://span[contains(text(),'LPN')]/ancestor::aq-displayfield[contains(@id,'lodnum')]/descendant::span[contains(@class,'data')]" in web browser to variable "screen_LPN" within $max_response seconds
			If I verify text $screen_LPN is equal to $lodnum ignoring case
			Else I fail step with error message "ERROR: Could not verify lodnum/LPN on the screen"
			EndIf
			And I wait $wait_short seconds
    
		And I "take a mobile screen shot if requested"
			If I verify variable "generate_screenshot" is assigned
			And I verify text $generate_screenshot is equal to "TRUE" ignoring case
				Then I execute scenario "Mobile Generate Screenshot"
			EndIf

		And I "advance though additional data on the screen"
			If I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser within $screen_wait seconds
				Then I press keys "ENTER" in web browser
				And I wait $screen_wait seconds
			EndIf

		And I "check to see if there is more inventory to display, if not we are done"
			Then I assign "Last Line of Inventory Displayed" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
        		Then I assign variable "more_dsp_data" by combining "FALSE"
				And I press keys "ENTER" in web browser
				Once I see "Inventory Dsp" in element "className:appbar-title" in web browser
				Once I see "Inventory Identifier" in web browser
			Else I assign variable "more_dsp_data" by combining "TRUE"
			EndIf
EndWhile

And I press keys "ENTER" in web browser

And I unassign variables "more_dsp_data,screen_LPN,screen_prtnum,screen_stoloc"

@wip @public
Scenario: Mobile Inventory Putaway Directed Override
#############################################################
# Description: Perform product putaway. If override is set
# then will override deposit location with F4, If allocate
# is set, will allocate with F3. If neither is set,
# will perform standard putaway.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - the LPN that was deposited
#	Optional:
#		inputs to mobile Deposit:
#		dep_loc - the deposit location
#		override_f2 - use F2 to show overrtide code
#		allocate - TRUE|FALSE - will use F3 to allocate location
#		override - TRUE|FALSE - will use F4 to override location
#		over_code - override code
#		over_dep_loc - override deposit location
# Outputs:
# 	None  
#############################################################

Given I "enter the lodnum"
	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
	Once I see "Putaway" in element "className:appbar-title" in web browser
	Once I do not see $lodnum in web browser

And I "press F6 and perform deposit"
 	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 
    
	Then I assign "Could Not Allocate" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	EndIf

	Once I see " Deposit" in element "className:appbar-title" in web browser
	Then I execute scenario "Mobile Deposit"

And I unassign variable "mobile_dialog_elt"

@wip @public
Scenario: Mobile Inventory Status Change
#############################################################
# Description: Perform a status change on inventory in the Mobile App
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - Load number being adjusted in 
#		reacod - System reason code for the change
#		new_sts - Status change value
#	Optional:
#		new_sts_use_f2 - lookup status change value with F2
# Outputs:
# 		None
#############################################################

Given I "verify we are on the Mobile Inventory Screen"
	Once I see "Inventory Status Change" in element "className:appbar-title" in web browser

And I "enter the load number for the status change"
	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "change the inventory status"
	Then I assign "New Sts" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	If I verify variable "new_sts_use_f2" is assigned
	And I verify text $new_sts_use_f2 is equal to "TRUE"
		Then I press keys "F2" in web browser
		And I execute scenario "Mobile Wait for Processing"

		Once I see "Value Lookup" in element "className:appbar-title" in web browser
        Then I type $new_sts in element "name:inpfld1" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
		Then I assign variable "elt" by combining "xPath://span[contains(text(),'" $new_sts_full_string "')]"
		And I click element $elt in web browser within $max_response seconds
		And I click element "name:newsts" in web browser within $max_response seconds
	Else I type $new_sts in element "name:newsts" in web browser within $max_response seconds
	EndIf
	Then I press keys "ENTER" in web browser

And I "provide a reason code"
	Then I assign "Reason Code" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $reacod in element "name:reacod" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "confirm the change"
	Then I assign "Ok to Change Status?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser
    
	Then I assign "Status Changed" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "ENTER" in web browser

And I unassign variable "mobile_dialog_elt"

@wip @public
Scenario: Mobile Inventory Transfer Directed 
#############################################################
# Description: Perform an Inventory Transfer in Directed work mode
# MSQL Files:
#	None
# Inputs:
#	Required:
#		srcloc - source location for the transfer
#		dstloc -  destination location for the transfer
#		xfer_lodnum - lodnum to transfer
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "F" ignoring case
		Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf
    
And I "am on Directed Work Screen"
	Once I see "Pickup Product At" in element "className:appbar-title" in web browser

And I "enter the transfer source location and get to Product Pickup Screen"
	If I see $srcloc in web browser within $screen_wait seconds
	And I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
		Then I press keys "ENTER" in web browser
	Else I fail step with error message "ERROR: The srcloc for the work given does not match the dataset. Use WMS work queue to resolve"
	EndIf
	
	If I see "Product Pickup" in element "className:appbar-title" in web browser within $wait_med seconds
		Then I assign "TRUE" to variable "proceed"
	ElsIf I see "Replenish Pick" in element "className:appbar-title" in web browser within $wait_med seconds
		Then I assign "TRUE" to variable "proceed"
	ElsIf I fail step with error message "ERROR: Expected text not found on mobile screen"
	EndIf
  
	If I verify text $proceed is equal to "TRUE"
		Then I "scan the transfer lodnum and set deposit location"
			And I assign "Inventory Identifier" to variable "input_field_with_focus"
			Then I execute scenario "Mobile Check for Input Focus Field"
			And I type $xfer_lodnum in element "name:lodnum" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
			And I execute scenario "Mobile Wait for Processing" 

			Then I assign "no rows affected" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I fail step with error message "ERROR: The lodnum for the work given does not match the dataset. Use WMS work queue to resolve"
			EndIf
			And I assign $dstloc to variable "dep_loc"
        
		And I "am back at the Directed Work Screen and I press F6 to deposit and complete transfer"
			Then I press keys "F6" in web browser
			And I execute scenario "Mobile Wait for Processing" 
			Once I see " Deposit" in element "className:appbar-title" in web browser 
			And I execute scenario "Mobile Deposit"
	EndIf

And I unassign variables "loc_to_check,mobile_dialog_elt"

@wip @public
Scenario: Mobile Inventory Transfer Undirected
#############################################################
# Description: This scenario performs a Full Inv Move
# MSQL Files:
#	None
# Inputs:
#	Required:
#		xfer_lodnum - LPN to be transferred
#		dstloc - Location where LPN will be deposited
#	Optional:
#		xfer_lodnum_list - Comma separate list of LPNs to be transferred
# Outputs:
# 	None           
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "F" ignoring case
		Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf

And I "validate I am on the inventory move screen"
	Once I see "Full Inventory Move" in element "className:appbar-title" in web browser

And I "look to see if we have multiple LPNs to move"
	If I verify variable "xfer_lodnum_list" is assigned
	And I verify text $xfer_lodnum_list is not equal to ""
		Then I assign $xfer_lodnum_list to variable "xfer_lodnum_list_local"
	Else I assign $xfer_lodnum to variable "xfer_lodnum_list_local"
	EndIf
   
When I "input each LPN to be transferred"
	Then I assign 1 to variable "lodnum_cnt"
	While I assign $lodnum_cnt th item from "," delimited list $xfer_lodnum_list_local to variable "xfer_lodnum_local"
		Then I assign "Source ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $xfer_lodnum_local in element "name:src_id" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
		And I wait $wait_med seconds

		And I increase variable "lodnum_cnt" by 1
	EndWhile 

And I "press F6 to Deposit"
	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 
	Once I see " Deposit" in element "className:appbar-title" in web browser 

And I "perform the Inventory Move"
	Then I assign $dstloc to variable "dep_loc"
	And I execute scenario "Mobile Deposit"

Once I see "Full Inventory Move" in element "className:appbar-title" in web browser

And I unassign variables "loc_to_check,lodnum_cnt,xfer_lodnum_local,xfer_lodnum_list_local"

@wip @public
Scenario: Mobile Inventory Transfer Invalid
#############################################################
# Description: Perform an inventory transfer with an
# storage location not at dock door (should get message
# about Invalid location)
# MSQL Files:
#	None
# Inputs:
#	Required:
#		xfer_lodnum - LPN to be transferred
#		dstloc - Invalid location where deposit will first be attempted to (and fail)
#		valid_dstloc - Valid location where deposit will eventually be made to
#	Optional:
#		None
# Outputs:
# 	None   
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "F" ignoring case
		Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf

And I "validate I am on the inventory move screen"
	Once I see "Full Inventory Move" in element "className:appbar-title" in web browser

When I "input the LPN to Be Transferred"
	Then I assign "Source ID" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $xfer_lodnum in element "name:src_id" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	Once I do not see $xfer_lodnum in web browser 

And I "press F6 to Deposit"
	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 
	If I see " Deposit" in element "className:appbar-title" in web browser within $wait_long seconds
	Else I echo "Retrying F6 operation"
		And I press keys "F6" in web browser
	EndIf
	Once I see " Deposit" in element "className:appbar-title" in web browser 

And I "enter the invalid location, checking to make sure we see the invalid message"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I assign $dstloc to variable "dep_loc"
	And I type $dstloc in element "name:dstloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

	Then I assign "Invalid location" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "ENTER" in web browser
    
And I "deposit to a good location"
	Then I unassign variables "dep_loc,dstloc"
    And I assign value $valid_dstloc to unassigned variable "dep_loc"
	And I assign value $valid_dstloc to unassigned variable "dstloc"
	Then I execute scenario "Mobile Deposit"

And I unassign variable "loc_to_check"

@wip @public
Scenario: Mobile Inventory Adjustment Change
#############################################################
# Description: Perform an Inventory Adjustment Change
# to increase or decrease the amount of inventory
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#		reacod - System reason code for adjustment.
#		adjref1 - Adjustment reference 1 (defaults to stoloc value)
#		adjref1 - Adjustment reference 2 (defaults to prtnum value)
#		new_qty - The new quantity we want to adjust to (increase/decrease)
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "enter my Location"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $wait_short seconds

	Then I assign "Approvals pending" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
		And I fail step with error message "ERROR: Found Approvals Pending and did expect, please approve pending approvals (in Web from Inventory/Adjustments)"
	EndIf

And I "validate my load is in the Location"
	Once I see $lodnum in web browser
	And I assign variable "elt" by combining "xPath://span[contains(text(),'" $lodnum "')]"
	And I click element $elt in web browser

And I "enter the new quantity"
	Then I assign "Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I clear all text in element "name:scanned_qty" in web browser within $max_response seconds
	And I type $new_qty in element "name:scanned_qty" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "confirm Unit of Measure"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

And I "add References and Reason Code if Configured"
	If I see "Adjustment References" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Mobile Inventory Adjustment References"
	EndIf

And I "set the string expected in inventory update dialog"
	Then I assign "OK To Update?" to variable "dialog_message"

And I press keys "F1" in web browser

@wip @public
Scenario: Mobile Inventory Adjustment Delete
#############################################################
# Description: Conduct a mobile inventory adjustment delete
# operation.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "enter the Location"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "validate my Load is in the Location"
	Once I see $lodnum in web browser

And I "select the Delete Option"
	Then I press keys "F4" in web browser

And I "add References and Reason Code if Configured"
	If I see "Adjustment References" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Mobile Inventory Adjustment References"
	EndIf

And I "set the string expected in inventory deletion dialog"
	Then I assign "OK To Delete Inventory?" to variable "dialog_message"

@wip @public
Scenario: Mobile Inventory Adjustment Complete
#############################################################
# Description: Complete and confirm an Inventory Adjustment 
# relative to the Storage Location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		dialog_message - message you anticipate seeing in dialog box
#	Optional:
#		None
# Outputs:
# 		None
#############################################################
    
Given I "Create/Delete/Update the Inventory"
	Then I assign $dialog_message to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds  
		Then I press keys "Y" in web browser
	EndIf

	Then I assign "Approval Required" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
	     Then I press keys "ENTER" in web browser
	EndIf
    
	Once I see "Inventory Adjustment" in element "className:appbar-title" in web browser
	Once I see "Location" in web browser
	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 
 
	Then I assign "Complete Adjustment?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser
	And I wait $wait_short seconds

And I "acknowledge Adjustment Completed or Approval Needed (Above Configured Threshold)"
	Then I assign "Adjustment Completed Successfully" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	ElsIf I assign "Approval Required" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
		EndIf
	Else I fail step with error message "ERROR: Failed to complete adjustment or could not acknowledge approval required"
	EndIf
	And I wait $wait_short seconds
	
	Then I press keys "F1" in web browser

And I "check for play adjustments"
	Then I assign "Play Adjustments?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $wait_med seconds 
		Then I press keys "Y" in web browser
	EndIf
    
And I unassign variable "mobile_dialog_elt"

@wip @public
Scenario: Mobile Inventory Adjustment Add
#############################################################
# Description: Perform an Inventory Adjustment to Add
# Inventory to a specified Location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#		prtnum - Valid part number that is assigned in your system
#		client_id - Client for the adjustment inventory
#		reacod - System reason code for adjustment/add
#		invsts - Inventory status
#		lotnum - Lot Number for item to be added
#		ftpcod - Footprint code for item to be added
#		uom - Unit of measure
#		adjref1 - Adjustment reference 1 (defaults to stoloc value)
#		adjref1 - Adjustment reference 2 (defaults to prtnum value)
#		untqty - The quantity of inventory we want to add
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "am at the Inventory Adjustment Screen"
	Once I see "Inventory Adjustment" in element "className:appbar-title" in web browser

And I "enter my Location"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	If I see "Location is empty" in web browser within $wait_med seconds
		Then I press keys "F3" in web browser
		Once I see "Inventory Adjust Identify" in element "className:appbar-title" in web browser
	EndIf
	
And I "enter my Client ID"
	If I verify text $client_id is not equal to "----"
		Then I assign "Client ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		And I type $client_id in element "name:client_id" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf
	
And I "enter my Load Number"
	Then I assign "LPN" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	If I verify variable "lodnum" is assigned
		Then I type $lodnum in element "name:lodnum" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	Else I press keys "F3" in web browser
		And I press keys "ENTER" in web browser
	EndIf

And I "enter my Part Number"
	Then I assign "Item Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "confirm U/C"
	Then I assign "Units Per" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I click element "name:untcas" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "enter quantity"
	Then I assign "Receive Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $untqty in element "name:rcvqty" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "confirm the Unit of Measure"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I click element "name:rcvuom" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "enter Inventory Status"
	Then I assign "Inventory Status" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $invsts in element "name:invsts" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "process Lot if Configured"
	If I see "Identify Product" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I assign "Lot Number" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		And I type $lotnum in element "name:lotnum" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf
	
And I "add References and Reason Code if Configured"
	If I see "Adjustment References" in element "className:appbar-title" in web browser within $wait_med seconds
		Then I execute scenario "Mobile Inventory Adjustment References"
	EndIf

And I "set the string expected in inventory addition dialog"
	And I assign "OK To Create Inventory?" to variable "dialog_message"

@wip @public
Scenario: Mobile Inventory Adjustment References
#############################################################
# Description: Add Adjustment References and Reason for 
# an adjustment operation
# MSQL Files:
#	None
# Inputs:
#	Required:
#		reacod - System reason code for adjustment.
#		adjref1 - Adjustment reference 1 (defaults to stoloc value)
#		adjref2 - Adjustment reference 2 (defaults to prtnum value)
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "specify the Inventory Adjustments References, Reason and Confirm"
	Once I see "Adjustment References" in element "className:appbar-title" in web browser

	Then I assign "Adjustment Reference One" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $adjref1 in element "name:adj_ref1" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

	Then I assign "Adjustment Reference Two" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $adjref2 in element "name:adj_ref2" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

	Then I assign "Reason Code" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $reacod in element "name:reacod" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

	And I wait $screen_wait seconds

@wip @public
Scenario: Mobile Inventory Adjustment Menu
#############################################################
# Description: Traverse to the Mobile Inventory Adjustment Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Mobile Inventory Adjustment Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Inventory Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Inventory Adjust') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Adjustment" in element "className:appbar-title" in web browser
	
############################################################
# Private Scenarios:
# None
#############################################################