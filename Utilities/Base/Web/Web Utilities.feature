############################################################
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
# Utility: Web Utilities.feature
# 
# Functional Area: General Web
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description:
# This Utility contains general Utility scenarios for the Web
#
# Public Scenarios:
#	- Web Login - Navigate to the WMS Screen in Web Browser
#	- Web Logout - Will log out from Web
#	- Web End Driver Tasks - Kill Web Driver Tasks
#	- Web Screen Search - Open's WMS's web search screen and look for screen
#	- Web Change Warehouse - Will Change Warehouse in Web
#	- Web Environment Setup - Setup variables and data needed for Web testing
#	- Web Select Workstation - Select from workstation screen a workstation to use
#	- Web Set Calendar Date - Opens calendar date picker and selects Today.
#	- Web Component Search - Use Web Search Box to find a specified component from most Web screens
# 
# Assumptions:
# 	None
#
# Notes:
# 	None
#
############################################################ 
Feature: Web Utilities

@wip @public
Scenario: Web Environment Setup
#############################################################
# Description: This scenario will setup common variables for 
# Web based testing
# MSQL Files:
#	None
# Inputs:
#    Required:
#		None
#    Optional:
#       None
# Outputs:
#    None
#############################################################

Given I "set up Web Environment Variables"
	Then I assign "xPath:" to variable "xPath"
	And I assign "xPath://input[contains(@id, 'jdaSearchField')]" to variable "wms_search"

And I "setup xPaths"
	Then I execute scenario "Web Set Up xPath"
 
@wip @public
Scenario: Web Login
#############################################################
# Description: This scenario will Navigate to WMS's Main Screen in web 
# browser and will open a particular warehouse
# MSQL Files:
#	check_default_warehouse.msql
# Inputs:
#	Required:
#		browser  - Browser name (set in Environment by default)
#		web_ui   - Web URL (set in Environment by default)
#		USERNAME - Username (This value comes from MOCA credentials)
#		PASSWORD - Password (This value comes from MOCA credentials)
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to WMS Main Screen in Web Browser"
	Then I open $browser web browser
	And I wait $wait_short seconds 
	When I navigate to $web_ui in web browser

When I "login to the WMS web screen"	
	Once I see element "xPath://div[@class='copyrightMessage']" in web browser
	When I type USERNAME from credentials $web_credentials in element "id:loginUserName" in web browser within $max_response seconds
	And I type PASSWORD from credentials $web_credentials in element "id:loginPassword" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "check to make sure I've logged in to the correct warehouse for my test"
	Once I see element "xPath://label[contains(text(),'Hello')]" in web browser
	And I assign "check_default_warehouse.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 510
		Then I execute scenario "Web Change Warehouse"
	EndIf

And I assign "FALSE" to variable "web_logged_off"

@wip @public 
Scenario: Web Logout
#############################################################
# Description: This scenario will log out of the WMS Web application.
# If the logout button/path cannot be seen, the browser will be explicitly
# closed and a fail step will be executed.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		USERNAME - This value comes from MOCA credentials
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "select the down arrow next to the user's name at the top"
And I "if this fails, close the browser explicitly"
	Then I assign "xPath:" to variable "xPath"
	And I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='" $username "']"
	And I assign variable "elt" by combining $elt "/..//span[2]"
	And I assign variable "elt" by combining $elt ""
    
    If I see element $elt in web browser within $wait_long seconds
	And I click element $elt in web browser within $wait_med seconds 
		Then I wait $wait_short seconds 
		And I "press Enter to Logout"
			Then I click element "text:Logout" in web browser within $max_response seconds
		Then I close web browser
		And I assign "TRUE" to variable "mobile_logged_off"
	Else I close web browser
		And I assign "TRUE" to variable "mobile_logged_off"
    	Then I fail step with error message "ERROR: Could not logoff gracefully, closing browser explicitly from Cycle"
    EndIf
 
@wip @public
Scenario: Web End Driver Tasks
#############################################################
# Description: This scenario will kill the driver tasks
# associated with chrome, Edge, and IE browsers.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "validate that the Browser has been closed"
	If I close web browser
	EndIf
	
When I "stop all Web driver tasks for IE, Chrome, and Edge browsers"
	Then I execute process "C:/Windows/System32/taskkill.exe" with parameters " /F /IM IEDriverServer.exe /T"
	And I execute process "C:/Windows/System32/taskkill.exe" with parameters " /F /IM chromedriver.exe /T"
	And I execute process "C:/Windows/System32/taskkill.exe" with parameters " /F /IM MicrosoftWebDriver.exe /T"
 
@wip @public
Scenario: Web Screen Search
#############################################################
# Description: This scenario will open the WMS web screen that needs to be opened.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		wms_screen_to_open - Name of the WMS web screen that needs to be opened
#		wms_search - Element for Search field
#	Optional:
#		wms_parent_menu - Parent menu for WMS screen to open (ex: receiving, shipping, etc...)
# Outputs:
#	None
#############################################################

Given I "clear the search bar"
	Then I click element $wms_search in web browser within $max_response seconds 
	When I clear all text in element $wms_search in web browser within $max_response seconds
	
And I "search for the new screen"
	When I type $wms_screen_to_open in element $wms_search in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
When I "navigate to the screen"
	If I verify variable "wms_parent_menu" is assigned
		Then I assign variable "elt" by combining "xPath://*[substring(normalize-space(text()),1,string-length('" $wms_parent_menu "'))='" $wms_parent_menu "' and substring(normalize-space(text()),string-length(normalize-space(text()))-string-length('-> " $wms_screen_to_open "')+1)='-> " $wms_screen_to_open "']"
	Else I assign variable "elt" by combining "xPath://*[substring(normalize-space(text()),string-length(normalize-space(text()))-string-length('-> " $wms_screen_to_open "')+1)='-> " $wms_screen_to_open "']"
	EndIf
	When I click element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 

@wip @public
Scenario: Web Change Warehouse
#############################################################
# Description: This scenario will change warehouse in the Web.
# MSQL Files:
#	get_warehouse_long_description.msql
# Inputs:
#	Required:
# 		wh_id - This value comes from environment file if not it will open with default warehouse
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "clear the text from choose site field"
	Then I assign "xPath://span[starts-with(@id,'jdaSiteButton-')]" to variable "elt"
	When I click element $elt in web browser within $max_response seconds
	Once I see "Change Site" in web browser

	Then I assign "xPath://input[contains(@name,'combobox')]" to variable "elt"
	And I click element $elt in web browser within $max_response seconds
	And I clear all text in element $elt in web browser within $max_response seconds
	
When I "change Warehouse in Web"
	Then I assign "get_warehouse_long_description.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
	And I assign row 0 column "lngdsc" to variable "wh_input"

	When I type $wh_input in element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $wh_input "']"
	And I click element $elt in web browser within $max_response seconds
	And I assign "xPath://span[contains(@id,'button-') and .='Select']" to variable "elt" 
	And I click element $elt in web browser within $max_response seconds

Then I "finished changing warehouses and make sure we are on main screen with Hello message"
	Once I see element "xPath://label[contains(text(),'Hello')]" in web browser
    
@wip @public
Scenario: Web Select Workstation
#############################################################
# Description: Navigate to workstatation screen and select
# workstation to use
# MSQL Files:
#	None
# Inputs:
#	Required:
#       workstation - WMS workstation to use
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "select a workstation to use"
	Then I click element $xPath_wms_workstation in web browser within $max_response seconds 
	Once I see element "xPath://span[text()='Select Workstation']" in web browser
	If I verify variable "workstation" is assigned
		Then I assign variable "my_workstation" by combining "xPath://div[text()='" $workstation "']"
		If I see element $my_workstation in web browser within $wait_short seconds
			Then I click element $my_workstation in web browser within $max_response seconds 
		EndIf
	EndIf
	Then I press keys TAB in web browser
	And I press keys "ENTER" in web browser
    
And I unassign variable "my_workstation"

Scenario: Web Set Calendar Date
#############################################################
# Description: Opens calendar date picker and selects Today.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		  None
#	  Optional:
#		  None
# Outputs:
# 	None
#############################################################

Given I "set the calendar date to Today"
	Then I assign variable "elt" by combining "xPath://div[contains(@class, 'rp-calendar-trigger')]"
	And I click element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://span[starts-with(@id, 'button-') and text()='Today']/ancestor::a[contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds

@wip @private
Scenario: Web Component Search
#############################################################
# Description: Use Search Box to find a specified component from most Web search screens
# Note, exclusions do apply with other search boxes/elements having differing xPaths.
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
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//table[contains(@id,'FilterComboBox-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'triggerWrap')]"
	And I assign variable "elt" by combining $elt "/descendant::input[contains(@id,'-inputEl')]"
	Then I assign $elt to variable "search_filter"
	When I click element $search_filter in web browser within $max_response seconds 

And I "search for my component and search criteria"
	Given I assign variable "search_string" by combining $component_to_search_for " = " $string_to_search_for
	Then I type $search_string in element $search_filter in web browser within $max_response seconds
	And I wait $screen_wait seconds 
	Then I press keys "ENTER" in web browser

And I unassign variables "search_filter,search_string" 

#############################################################
# Private Scenarios:
#	None
#############################################################