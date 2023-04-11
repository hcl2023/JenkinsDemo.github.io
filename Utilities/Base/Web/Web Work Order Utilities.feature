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
# Utility: Web Work Order Utilities.feature
# 
# Functional Area: Production
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web
#
# Description:
# These Utility scenarios perform actions specific to work order processing in the Web
#
# Public Scenarios:
#	- Web Create Work Order - creates a work order in the web 
#	- Web Allocate Work Order - allocates a work order in the web 
#	- Web Start Work Order - starts a work order in the web 
#	- Web Complete Work Order - completes a work order in the web 
#	- Web Open Work Order Screen - opens Work Order screen in the web 
# 	- Web Click Work Order Check Box - clicks the work order checkbox 
#
# Assumptions:
# None
#
# Notes:
# None 
############################################################
Feature: Web Work Order Utilities

@wip @public
Scenario: Web Create Work Order
#############################################################
# Description: This scenario creates the work order in the web client
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "click the Actions drop down"
	When I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']/..//span[2]" in web browser within $max_response seconds 

And I "click Add"
	When I click element "xPath://span[starts-with(@id,'menuitem-') and text()='Add']" in web browser within $max_response seconds 

And I "get the work order type description for drop down selection"
	When I execute scenario "Get Work Order Type Description"

And I "select the work order type from the drop down"
	Given I assign variable "add_work_order_window" by combining "xPath://div[starts-with(@class,'x-window') and starts-with(@id,'wm-workorderaction-window-')]"
	And I assign variable "elt" by combining $add_work_order_window "//div[starts-with(@class,'x-trigger-index-0')]"
	And I click element $elt in web browser within $max_response seconds 
	And I assign variable "elt" by combining "xPath://li[@role='option' and text()='" $wko_typ_description "']"
	When I click element $elt in web browser within $max_response seconds 

And I "click OK"
	Given I assign variable "elt" by combining $add_work_order_window "//span[starts-with(@id,'button-') and text()='OK']/..//span[2]"
	When I click element $elt in web browser within $max_response seconds 
	Once I see "General" in web browser  

When I "enter the work order number"
	Then I type $wkonum in element "xPath://input[@name='workOrderNumber']" in web browser within $max_response seconds 

And I "enter the work order revision"
	When I type $wkorev in element "xPath://input[@name='workOrderRevision']" in web browser within $max_response seconds 

And I "select the work order client"
	When I type $client_id in element "xPath://input[@name='clientId']" in web browser within $max_response seconds 
	And I assign variable "elt" by combining "xPath://li[text()='" $client_id "']"
	And I click element $elt in web browser within $max_response seconds 

And I "select the item"
	When I type $tlp_prtnum in element "xPath://input[@name='itemNumber']" in web browser within $max_response seconds 
	And I assign variable "elt" by combining "xPath://div[starts-with(@class,'x-boundlist-item') and text()='" $tlp_prtnum " - " $client_id "']"
	And I click element $elt in web browser within $max_response seconds 
	And I press keys TAB in web browser

And I "select the BOM"
	When I assign variable "bom_window" by combining "xPath://div[starts-with(@class,'x-window') and contains(@class,'wm-BOMResultsWindow')]"
	Once I see element $bom_window in web browser
	And I assign variable "elt" by combining "xPath://div[text()='" $bomnum "']"
	And I assign variable "elt_selected" by combining "xPath://div[text()='" $bomnum "']/ancestor::tr[contains(@class,'x-grid-row-selected')]"
	If I do not see element $elt_selected in web browser within $wait_short seconds 
		Then I click element $elt in web browser within $max_response seconds 
	Else I "look for element in browser"
		Once I see element $elt in web browser 
	EndIf
	And I assign variable "elt" by combining $bom_window "//span[starts-with(@id,'button-') and text()='OK']/..//span[2]"
	And I click element $elt in web browser within $max_response seconds 

And I "select the inventory status"
   	When I execute scenario "Get Inventory Status Description"
	And I assign "xPath://input[@name='inventoryStatus']" to variable "elt"
	And I clear all text in element $elt in web browser within $max_response seconds
	And I type $invsts_description in element $elt in web browser within $max_response seconds 
	And I assign variable "elt" by combining "xPath://li[text()='" $invsts_description "']"
	And I click element $elt in web browser within $max_response seconds 

And I "enter the work order quantity"
	When I assign "xPath://input[@name='workOrderQuantity']" to variable "elt"
	And I clear all text in element $elt in web browser within $max_response seconds
	And I type $prdqty in element $elt in web browser within $max_response seconds 
	And I press keys TAB in web browser

And I "update the line quantity of the components"
	If I see "Update the line quantity of the components" in web browser within $wait_long seconds 
		Then I assign "xPath://span[text()='Yes']/ancestor::a" to variable "elt"
		And I click element $elt in web browser within $max_response seconds
	EndIf

And I "select the production line"
	Given I assign "xPath://input[@name='productionLine']" to variable "elt"
	And I clear all text in element $elt in web browser within $max_response seconds
	When I type $prdlin in element $elt in web browser within $max_response seconds     
	And I assign variable "elt" by combining "xPath://li[text()='" $prdlin "']"
	And I click element $elt in web browser within $max_response seconds 

Then I "click the save button"
	Given I assign variable "elt" by combining "xPath://div[starts-with(@class,'x-container') and contains(@class,'wm-bottombar')]"
	And I assign variable "elt" by combining $elt "//span[text()='Save']/..//span[2]"
	Then I click element $elt in web browser within $max_response seconds 

@wip @public
Scenario: Web Allocate Work Order
#############################################################
# Description: This scenario allocates the work order in the web client
# MSQL Files:
#	None
# Inputs:
#   Required:
#       wkonum - Work Order number to allocate
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "search for the work order to allocate"
	Then I assign "Work Order" to variable "component_to_search_for"
	And I assign $wkonum to variable "string_to_search_for"
	And I execute scenario "Web Component Search"

And I "click the checkbox for the work order to allocate"
	When I execute scenario "Web Click Work Order Check Box"

And I "click the Actions drop down"
	When I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']/..//span[2]" in web browser within $max_response seconds 

When I "click Allocate"
	When I click element "xPath://span[starts-with(@id,'menuitem-') and text()='Allocate']" in web browser within $max_response seconds 
	Once I see "SELECT LINES" in web browser

And I "click the header checkbox to select all lines"
	When I click element "xPath://div[contains(@class,'x-column-header-checkbox') and not(contains(@class,'x-grid-hd-checker-on'))]//span" in web browser within $max_response seconds 

And I "click the Next button"
	When I click element "xPath://span[starts-with(@id,'button-') and text()='Next']/..//span[2]" in web browser within $max_response seconds 

And I "click the Finish button"
	When I click element "xPath://span[starts-with(@id,'button-') and text()='Finish']/..//span[2]" in web browser within $max_response seconds

And I unassign variables "component_to_search_for,string_to_search_for"

@wip @public
Scenario: Web Start Work Order
#############################################################
# Description: This scenario starts the work order in the web client.
# MSQL Files:
#	None
# Inputs:
#   Required:
#       wkonum - Work Order number to start
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "search for the work order to start"
	Then I assign "Work Order" to variable "component_to_search_for"
	And I assign $wkonum to variable "string_to_search_for"
	And I execute scenario "Web Component Search"

And I "click the checkbox for the work order to start"
	When I execute scenario "Web Click Work Order Check Box"

And I "click the Actions drop down"
   When I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']/..//span[2]" in web browser within $max_response seconds 

When I "click Start"
	Then I click element "xPath://span[starts-with(@id,'menuitem-') and text()='Start']" in web browser within $max_response seconds 

Then I "see message indicating the work order started successfully"
	Given I assign variable "elt" by combining "xPath://div[starts-with(@id,'messagebox-') and text()='Work Order " $wkonum " started successfully']"
	Once I see element $elt in web browser
	Then I press keys "ENTER" in web browser

And I unassign variables "component_to_search_for,string_to_search_for"
	
@wip @public
Scenario: Web Complete Work Order
#############################################################
# Description: This scenario completes the work order in the web client.
# MSQL Files:
#	None
# Inputs:
#   Required:
#       wkonum - Work Order number to complete
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "search for the work order to complete"
	Then I assign "Work Order" to variable "component_to_search_for"
	And I assign $wkonum to variable "string_to_search_for"
	And I execute scenario "Web Component Search"

And I "click the checkbox for the work order to complete"
	When I execute scenario "Web Click Work Order Check Box"

When I "click the Actions drop down"
	Then I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']/..//span[2]" in web browser within $max_response seconds 

And I "click Complete"
	Then I click element "xPath://span[starts-with(@id,'menuitem-') and text()='Complete']" in web browser within $max_response seconds 

And I "confirm the Complete Work Order screen has opened"
	Then I assign variable "elt" by combining "xPath://span[text()='Complete Work Order - " $wkonum "']"
	Once I see element $elt in web browser

And I "click the close button to complete the work order"
	Then I click element "xPath://span[starts-with(@id,'button-') and text()='Close']/..//span[2]" in web browser within $max_response seconds 

Then I "confirm the work order closed successfully"
	Given I assign variable "elt" by combining "xPath://div[starts-with(@id,'messagebox-') and text()='Work order " $wkonum " closed successfully']"
	Once I see element $elt in web browser
	Then I press keys "ENTER" in web browser
	
@wip @public
Scenario: Web Open Work Order Screen
#############################################################
# Description: This scenario opens the Work Orders WMS Web screen.
# MSQL Files:
#	None
# Inputs:
#   Required:
#       None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

When I "verify the Work Orders screen is open and reset to default state."
	Given I assign "xPath://span[starts-with(@id,'wm-workorders-workorders_header_hd-') and text()='Work Orders']" to variable "work_order_screen_header"
	If I do not see element $work_order_screen_header in web browser within $wait_med seconds 
		Then I "go to the Search box and enter Work Orders"
			And I assign "Work Orders" to variable "wms_screen_to_open"
			When I execute scenario "Web Screen Search"
			And I wait $wait_med seconds 
			If I see "Exception Occurred" in web browser within $wait_short seconds 
				Then I press keys "ENTER" in web browser
			EndIf
			Once I see element $work_order_screen_header in web browser
			And I unassign variable "wms_screen_to_open"
	Else I echo "Work Order screen already open"
		Then I "clear any active filters on the screen to reset it"
			And I assign "xPath://a[contains(@class,'rpux-close-filter-btn')]" to variable "x_clear_filter"
			If I click element $x_clear_filter in web browser within $wait_long seconds 
			EndIf
	EndIf

@wip @public
Scenario: Web Click Work Order Check Box
#############################################################
# Description: This scenario clicks the work order check box in web
# MSQL Files:
#	None
# Inputs:
#   Required:
#       wkonum - Work Order number
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

When I "click the Work Order Checkbox"
	Given I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $wkonum "']"
	And I assign variable "box_not_checked" by combining $elt "/ancestor::tr[not(contains(@class,'x-grid-row-selected'))]//div[@class='x-grid-row-checker']"
	And I assign variable "box_checked" by combining $elt "/ancestor::tr[contains(@class,'x-grid-row-selected')]//div[@class='x-grid-row-checker']"
	If I see element $box_not_checked in web browser within $wait_short seconds 
		Then I click element $box_not_checked in web browser within $max_response seconds
		Once I see element $box_checked in web browser 
	Else I "look for element in browser"
		Once I see element $box_checked in web browser
	EndIf

#############################################################
# Private Scenarios:
#	None
#############################################################