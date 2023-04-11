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
# Utility: Web Outbound Audit Utilities.feature
# 
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: WEB, MOCA
#
# Description:
# These utility scenarios perform outbound audit functions in the Web
#
# Public Scenarios:
#	- Web Release Outbound Audit Hold - Approves a pending outbound audit hold in the Web.
#	- Web Shipping Search - Search the Shipping screen with search filter
#	- Web Navigate to Shiping Issues Screen - Navigate to the Shipping Issues/Not Shippable screen
#	- Web Navigate to RF Outbound Audit Issues Screen - Navigate to the Shipping Issues/RF Outbound Audit screen
#	- Web Check Outbound Audit History - From RF Outbound Audit screen, search for lodnum,
# select, and inspect field on screen
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Web Outbound Audit Utilities

@wip @public
Scenario: Web Check Outbound Audit History
#############################################################
# Description: From RF Outbound Audit screen, search for lodnum,
# select, and inspect field on screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - load number to search for
#		prtnum - part number from the order
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Once I see "RF Outbound Audit" in web browser

Then I "search for lodnum"
	And I assign "Identifier" to variable "component_to_search_for"
	And I assign $lodnum to variable "string_to_search_for"
	And I execute scenario "Web Shipping Search"
    
And I "select the lodnum/LPN"
	And I assign variable "elt" by combining "xPath://span[text() = '" $lodnum "']"
	When I click element $elt in web browser within $max_response seconds

And I "verify components of the audit record"
	Once I see $prtnum in web browser
	Once I see $lodnum in web browser
	Once I see "Initial Audit" in web browser
	Once I see "Recount Audit" in web browser

And I "close the screen by clicking the 'X' in the upper right corner"
	Then I assign variable "elt" by combining "xPath://i[starts-with(@id,'tool-') and contains(@id,'-toolEl')]"
	When I click element $elt in web browser within $max_response seconds

@wip @public
Scenario: Web Shipping Search
#############################################################
# Description: Use Search Box to find a specified component from Shipping screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		component_to_search_for - component to search for (i.e. shipment, load, order)
#		string_to_search_for - string to search for relative to component_to_search_for
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "filter by the component provided"
	And I assign variable "elt" by combining "xPath://input[starts-with(@id,'rpuxFilterComboBox-') and contains(@name,'rpuxFilterComboBox')]"
	Then I assign $elt to variable "search_filter"
	When I click element $search_filter in web browser within $max_response seconds 

And I "search for my component"
	Then I assign variable "search_string" by combining $component_to_search_for " = " $string_to_search_for
	And I type $search_string in element $search_filter in web browser within $max_response seconds
	And I wait $screen_wait seconds 
	And I press keys "ENTER" in web browser

And I unassign variables "search_filter,search_string"

@wip @public
Scenario: Web Release Outbound Audit Hold
#############################################################
# Description: Release Hold from the Shipping/Shipping Issues/Not Shippable screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - load number to search for with hold applied
#		invsts - inventory status applied during hold release
#		reacod - reason code string to use during hold release
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Once I see "Not Shippable" in web browser

Then I "search for lodnum"
	And I assign "LPN" to variable "component_to_search_for"
	And I assign $lodnum to variable "string_to_search_for"
	And I execute scenario "Web Shipping Search"
	And I wait $wait_med seconds

And I "select checkbox associated with row with lodnum"
	Then I assign variable "elt" by combining "xPath://tr[contains(@id,'record-ext-record')]/descendant::div[contains(@class,'grid-row-checker')]"
	Once I see element $elt in web browser
	And I click element $elt in web browser within $max_response seconds

And I "select Actions Menu and then Release Hold menu item"
	Then I click element "xPath://span[starts-with(@id,'moreactionsbutton-') and text()='Actions']/.." in web browser within $max_response seconds
	And I click element "xPath://span[starts-with(@id,'menuitem-') and text()='Release Hold']" in web browser within $max_response seconds
	Once I see "Release Hold" in web browser

And I "select checkbox associated with row with hold"
	Then I assign variable "elt" by combining "xPath://tr[contains(@id,'record-OUTAUDHLD')]/descendant::div[contains(@class,'grid-row-checker')]"
	And I click element $elt in web browser within $max_response seconds

And I "click on Finish to complete the hold release"
	Then I assign variable "elt" by combining "xPath://span[text()='Release']/.."
	And I click element $elt in web browser within $max_response seconds
	And I wait $screen_wait seconds
	Once I see "Change Inventory Status" in web browser

And I "in dialog, fill in inventory status for hold release"
	Then I click element "name:inventoryStatus" in web browser within $max_response seconds
	And I type $invsts in element "name:inventoryStatus" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I assign variable "elt" by combining "xPath://li[contains(text(),'" $invsts "')]"
	And I click element $elt in web browser within $max_response seconds

And I "in dialog, fill in inventory reason for hold release"
	Then I click element "name:reasonCode" in web browser within $max_response seconds
	And I type $reacod in element "name:reasonCode" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I assign variable "elt" by combining "xPath://li[contains(text(),'" $reacod "')]"
	And I click element $elt in web browser within $max_response seconds

And I "click OK to complete release hold"
	Then I click element "xPath://div[contains(@id, 'toolbar')]/descendant::span[text()='OK']/.." in web browser within $max_response seconds
	And I wait $screen_wait seconds

And I "dismiss the results dialog box with OK button"
	Then I click element "xPath://div[contains(@id, 'toolbar')]/descendant::span[text()='OK']/.." in web browser within $max_response seconds
	And I wait $screen_wait seconds

And I unassign variables "component_to_search_for,string_to_search_for"

@wip @public
Scenario: Web Navigate to Shiping Issues Screen
#############################################################
# Description: Use Web Search to navigate to Shipping/Shipping Issues
# Not Shippable Screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "open the Outbound Plannner screen"
	Then I assign "Not Shippable" to variable "wms_screen_to_open"
	And I assign "Shipping" to variable "wms_parent_menu"
	Then I execute scenario "Web Screen Search"

And I unassign variables "wms_screen_to_open,wms_parent_menu"
    
@wip @public
Scenario: Web Navigate to RF Outbound Audit Issues Screen
#############################################################
# Description: Use Web Search to navigate to Shipping/Shipping Issues
# RF Outbound Audit screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "open the Outbound Plannner screen"
	Then I assign "RF Outbound Audit" to variable "wms_screen_to_open"
	And I assign "Shipping" to variable "wms_parent_menu"
	Then I execute scenario "Web Screen Search"

And I unassign variables "wms_screen_to_open,wms_parent_menu"

#############################################################
# Private Scenarios:
# None
#############################################################