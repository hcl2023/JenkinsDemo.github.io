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
# Utility: Mobile Unpick Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile
#
# Description:
# This Utility contains utility scenarios to perform unpick functionality in the Mobile App
#
# Public Scenarios:
#	- Mobile Perform Unpick - Performs a Mobile App unpick operation
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Unpick Utilities

@wip @public
Scenario: Mobile Perform Unpick
#############################################################
# Description: Performs a Mobile App Unpick operation in Mobile App
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		pck_lodnum - Pick load to be unpicked
#		unpick_partial - Flag indicating partial or full unpick
#		cancod - Cancel Code
#		putaway_method - Type of putaway for unpicked inventory
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "verify I am on the unpick screen"
	Once I see "Unpick" in element "className:appbar-title" in web browser

Then I "enter the lodnum to be unpicked"
	And I assign "Inventory Identifier" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $pck_lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
When I "check for partial unpick and LPN error conditions"
    Then I assign "unpick partial" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		If I verify text $unpick_partial is equal to "Y"
			Then I "am performing a partial unpick"
				Given I press keys "Y" in web browser
				And I wait $wait_short seconds
				Then I execute scenario "Mobile Perform Unpick Partial"
		Else I press keys "N" in web browser
		EndIf       
	Elsif I see "identifier invalid" in web browser
		Then I fail step with error message "ERROR: The load number to be unpicked is invalid"   
	Elsif I see "Identifier Is Not Picked Inventory" in web browser
		Then I fail step with error message "ERROR: The load number to be unpicked is not picked inventory"
	EndIf 
	
And I "enter the cancel code for the unpick"
	Then I assign "Cancel Code" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $cancod in element "name:codval" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $wait_short seconds
    
    Then I assign "Identifier Has Been Unpicked" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $wait_med seconds
		Then I press keys "ENTER" in web browser
	EndIf 
	And I wait $wait_short seconds
	
And I "force putaway if the vehicle load limit is more than 1"
	If I do not see "Product Putaway" in web browser within $screen_wait seconds 
		Then I press keys "F6" in web browser
		And I execute scenario "Mobile Wait for Processing" 
	EndIf
	Then I "choose a Putaway Method"
		Once I see "Product Putaway" in element "className:appbar-title" in web browser
		Then I type $putaway_method in web browser

    	Then I assign "Could Not Allocate" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
		EndIf
		
When I "deposit the load"
	Then I execute scenario "Mobile Deposit"
	
#############################################################
# Private Scenarios:
#	Mobile Perform Unpick Partial - Performs a partial Mobile App Unpick
#############################################################

@wip @private
Scenario: Mobile Perform Unpick Partial
#############################################################
# Description: Performs a partial Mobile App Unpick.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		client_id - Client
#		prtnum - Part Number
#		unpick_qty - Partial qty to unpick
#		unpick_to_lodnum - LPN to put partial unpicked inventory
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "verify I am on the unpick (partial) screen"
	Once I see "Unpick" in element "className:appbar-title" in web browser

Given I "enter the client_id"
	If I verify text $client_id is not equal to "----"
		Then I assign "Item Client ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I clear all text in element "name:prt_client_id" in web browser within $max_response seconds
		And I type $client_id in element "name:prt_client_id" in web browser within $max_response seconds
		Then I press keys "ENTER" in web browser
	EndIf

When I "enter the item number"
	Then I assign "Item Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I clear all text in element "name:prtnum" in web browser within $max_response seconds
	And I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	If I see "no rows" in web browser within $screen_wait seconds 
		Then I fail step with error message "ERROR: The item to unpick is not on this load"
	ElsIf I see "Invalid item" in web browser within $screen_wait seconds
		Then I fail step with error message "ERROR: The item number is invalid"
	EndIf
	
And I "enter the unpick quantity"
	Then I assign "Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I clear all text in element "name:untqty" in web browser within $max_response seconds
	And I type $unpick_qty in element "name:untqty" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
    Then I assign "Un-pickable" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $wait_med seconds 
		Then I press keys "ENTER" in web browser
		And I fail step with error message "ERROR: Inventory to unpick exceeds what is available in the current load"
	EndIf
	
And I "acknowledge the uom for unpicking"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

And I "enter the destination load for the unpicked item if one is defined and this is a partial qty"
	If I verify variable "unpick_to_lodnum" is assigned
	And I verify text $unpick_to_lodnum is not equal to ""
		Then I wait $wait_long seconds
		And I type $unpick_to_lodnum in web browser
		And I wait $wait_short seconds 
	EndIf
	And I press keys "ENTER" in web browser