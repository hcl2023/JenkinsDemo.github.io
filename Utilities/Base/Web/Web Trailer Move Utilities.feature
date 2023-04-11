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
# Utility: Web Trailer Move Utilities.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description: These Utility scenarios perform actions specific to trailer moves in the Web
#
# Public Scenarios:
# 	- Web Trailer Move - top-level trailer move operation in the Web
#
# Assumptions:
# None
#
# Notes:
# - Utility Scenarios to verify trailer move operations via MOCA are
#   located in the Terminal version of this Utility.
# 
############################################################
Feature: Web Trailer Move Utilities

@wip @public
Scenario: Web Trailer Move
#############################################################
# Description: This scenario moves a trailer using the WEB
# MSQL Files:
#	None
# Inputs:
#	Required:
#       trlr_num - Trailer Number
#       move_to_dock_loc - Location trailer will be moved to
#		work_queue_or_immediate - Variable that indicates when the move is performed
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "go to the Search box and find the Transport Equipment Screen"
	Then I assign "Transport Equipment" to variable "wms_screen_to_open"
	When I execute scenario "Web Screen Search"

And I "search for the Trailer by Transport Equipment Number"
	Then I assign "Transport Equipment" to variable "component_to_search_for"
	And I assign $trlr_num to variable "string_to_search_for"
	And I execute scenario "Web Component Search"
	
And I "click the row with the Trlr Num"
	Once I see $trlr_num in web browser
	Once I see element "className:x-grid-row-checker" in web browser
	When I click element "className:x-grid-row-checker" in web browser within $max_response seconds
	And I wait $wait_short seconds 

And I "select the Actions Drop Down"
	Given I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and contains(@id,'-btnInnerEl') and .= 'Actions']/ancestor::a[starts-with(@id,'button-')]"
	When I click element $elt in web browser within $max_response seconds

When I "move Transport Equipment"
	Given I assign variable "elt" by combining "xPath://a[starts-with(@id,'actionmenu_moveEquipment-itemE')]"
	When I click element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 

And I "type in the To Dock Location"
	Given I assign "xPath://input[starts-with(@id,'combobox-') and contains(@name,'to')]" to variable "elt"
	And I click element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 
	When I type $move_to_dock_loc in element $elt in web browser within $max_response seconds
	Then I press keys TAB in web browser

And I "process work_queue or move immediate action option"
	If I verify variable "work_queue_or_immediate" is assigned
	And I verify text $work_queue_or_immediate is equal to "work_queue" 
		Given I "select The Work Queue Button"
			Then I assign variable "elt" by combining "xPath://label[starts-with(@id,'radiofield-') and .= 'Add to Work Queue']"
			When I click element $elt in web browser within $max_response seconds
			And I wait $wait_short seconds 

		And I "type the username of the user to assign the activity to"
			Then I assign variable "username_dash" by combining $username " - "
			And I assign variable "elt" by combining "xPath://input[starts-with(@id,'userrolecombo-') and contains(@id,'-inputEl')]"
			And I click element $elt in web browser within $max_response seconds
			When I type $username_dash in element $elt in web browser within $max_response seconds
			And I wait $wait_med seconds

		And I "click the arrow"
			Then I assign variable "elt" by combining "xPath://td[contains(@id,'userrolecombo')]//div[contains(@class,'x-form-arrow-trigger')]"
			When I click element $elt in web browser within $max_response seconds
			And I wait $wait_med seconds

		And I "select the user/role combo from the list"
			Then I assign variable "elt" by combining "xPath://div[@class='x-boundlist-item' and starts-with(.,'" $username_dash "')]"
			When I click element $elt in web browser within $max_response seconds
			And I wait $wait_short seconds 

	Else I "select The Move Immediately Button"
			Then I assign variable "elt" by combining "xPath://label[starts-with(@id,'radiofield-') and .= 'Move Immediately']"
			When I click element $elt in web browser within $max_response seconds
			And I wait $wait_short seconds 
	EndIf 

And I "press the OK Button in Screen"
	Given I assign variable "elt" by combining "xPath://a[starts-with(@id,'button-') and .= 'OK']"
	When I click element $elt in web browser within $max_response seconds

Then I "confirm move"
	If I verify variable "work_queue_or_immediate" is assigned
	And I verify text $work_queue_or_immediate is equal to "work_queue" 
		Once I see "Add transport equipment move" in web browser
	Else I "look for equipment"
		Once I see "Move transport equipment" in web browser 
	Endif
	Then I press keys "ENTER" in web browser
	And I wait $wait_med seconds

And I unassign variables "wms_screen_to_open,component_to_search_for,string_to_search_for"
	
#############################################################
# Private Scenarios:
#	None
#############################################################