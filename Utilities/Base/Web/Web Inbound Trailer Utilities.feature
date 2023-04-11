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
# Utility: Web Inbound Trailer Utilities.feature
# 
# Functional Area: Inbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: WEB
#
# Description:
# These utility scenarios perform inbound trailer functions
#
# Public Scenarios:
#	- Web Open Receiving Transport Equipment Screen - Opens web Receiving Transport Equipment screen
#	- Web Search for Inbound Trailer - Searches for the trailer provided in Test Case Inputs
#	- Web Check In Inbound Trailer - Checks in the trailer using Web
#	- Web Verify Inbound Trailer Check In - Validates success confirmation dialog is confirmed
#	- Web Open Add Transport Equipment Screen - Opens the Transport Equipment Screen without an appointment.
#	- Web Process Inbound Trailer Safety Check - Checks the Inbound trailer requires check and then confirms the prompts
#	- Web Add Storage Transport Equipment Infomation - Enters in the required information for the storage transport equipment. 
#	- Web Check In Storage Trailer - Selects a door and checks in a trailer.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Web Inbound Trailer Utilities

@wip @public
Scenario: Web Open Receiving Transport Equipment Screen
#############################################################
# Description: This scenario opens the Receiving Transport Equipment screen in the WEB
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

Given I "go to the Search box and find my Receiving option"
	When I assign "Transport Equipment" to variable "wms_screen_to_open"
	And  I assign "Receiving" to variable "wms_parent_menu"
	Then I execute scenario "Web Screen Search"

@wip @public
Scenario: Web Open Yard Check In Screen
#############################################################
# Description: This scenario opens the Yard Check In screen in the WEB
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

Given I "go to the Search box and find my Receiving option"
	When I assign "Check In" to variable "wms_screen_to_open"
	And  I assign "Yard" to variable "wms_parent_menu"
	Then I execute scenario "Web Screen Search"
    Once I see "Inbound Shipments" in web browser

@wip @public
Scenario: Web Search for Inbound Trailer
#############################################################
# Description: This scenario searches and selects the Inbound Trailer for check in
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - Trailer Number
#	Optional:
#		None
# Outputs:
#	None                  
#############################################################

Given I "am on the Transport Equipment page"
	Once I see "Transport Equipment" in web browser
	
When I "search for the trailer"
	Then I assign "Transport Equipment" to variable "component_to_search_for"
	And I assign $trlr_num to variable "string_to_search_for"
	And I execute scenario "Web Component Search"
	
Then I "select the search result choice"
	Once I see element "className:x-grid-row-checker" in web browser
	Then I click element "className:x-grid-row-checker" in web browser within $max_response seconds
	
@wip @public
Scenario: Web Check In Inbound Trailer
#############################################################
# Description: This scenario performs web actions for Inbound Trailer for check in
# MSQL Files:
#	None
# Inputs:
#	Required:
#		yard_loc - yard location
#		wh_id - warehouse ID
#	Optional:
#		None
# Outputs:
#	None                     
#############################################################

Given I "select the Check In option from the Actions pull-down button on the top left"
	When I assign "xPath://span[text()='Actions']//../span[2]" to variable "elt"
	And I click element $elt in web browser within $max_response seconds 
	And I click element "id:actionmenu_checkinEquipment-textEl" in web browser within $max_response seconds 
	Once I see "Check In" in web browser
	
When I "select the door to receive the trailer and click 'Check In' to check it in"
	Then I assign variable "elt" by combining "xPath://*[@data-recordid='" $yard_loc "*!" $wh_id "']"
	And I click element $elt in web browser within $max_response seconds 

And I "press the 'Check In' button"
	When I assign "xPath://span[text()='Check In' and starts-with(@id,'button')]//..//span[2]" to variable "elt"
	Then I click element $elt in web browser within $max_response seconds

@wip @public
Scenario: Web Verify Inbound Trailer Check In
#############################################################
# Description: This scenario verifies in the web that trailer check in was successful
# MSQL Files:
#	None
# Inputs:
#	Required:
#		xPath_span_OK_sibling - A prebuilt variable in Web Element Utilities for child OK buttons
#	Optional:
#		None
# Outputs:
#	None                 
#############################################################

Given I "ensure that I see a successful check-in and click the 'OK' button"
	Once I see "Check In Successful" in web browser
	Then I click element $xPath_span_OK_sibling in web browser within $max_response seconds
	
@wip @public
Scenario: Web Process Inbound Trailer Safety Check
#############################################################
# Description: This scenario processes a safety check for Receiving trailers
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - Trailer Number
#	Optional:
#		None
# Outputs:
#	None         
#############################################################

Given I "find the checked in inbound trailer and process the safety checks"
	When I execute scenario "Web Search for Inbound Trailer"
	If I see $trlr_num in web browser within $wait_med seconds 
	And I see "Open For Recei" in web browser within $wait_med seconds
		Then I execute scenario "Web Transport Equipment Process Trailer Safety Check"
	Else I fail step with error message "ERROR: Expected trailer not found"
	EndIf

@wip @public
Scenario: Web Open Add Transport Equipment Screen
#############################################################
# Description: Opens the Transport Equipment Screen without an appointment.
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

Given I "select check in without appointment"
	Once I see "Check In" in web browser
	Then I click element "text:Check in without appointment" in web browser within $max_response seconds
 
And I "open Add Transport screen"
	Once I see "Transport Equipment" in web browser
    Then I click element "text:Add Equipment" in web browser within $max_response seconds
    And I wait $wait_med seconds
    
@wip @public
Scenario: Web Add Storage Transport Equipment Infomation
#############################################################
# Description: Enters in the required information for the storage transport equipment.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - This will be used as the trailer number when receiving by Trailer
#		carcod - Carrier Code used for the trailer
#	Optional:
#		None
# Outputs:
#	None                     
#############################################################

Given I "type in equipment number"
	When I see "Equipment Information" in web browser within $wait_med seconds
    Then I assign variable "elt" by combining "xPath://input[starts-with(@id, 'textfield-') and contains(@name, 'trailerNumber')]"
    Then I click element $elt in web browser within $max_response seconds
    And I type $trlr_num in web browser

And I "type in carrier info"
	Then I assign variable "elt" by combining "xPath://td[starts-with(@id, 'carriercombo-')]"
    And I click element $elt in web browser within $max_response seconds
	And I type $carcod in web browser
	And I click element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $carcod "']"
	And I click element $elt in web browser within $max_response seconds

And I "type use in as Storage"
	Then I assign variable "elt" by combining "xPath://input[contains(@name, 'trailerCode')]"
	And I click element $elt in web browser within $max_response seconds
	And I clear all text in element $elt in web browser within $max_response seconds
	And I click element $elt in web browser within $max_response seconds
	And I type "Storage" in web browser
	And I assign variable "elt" by combining "xPath://li[text()='Storage']"
	And I click element $elt in web browser within $max_response seconds

And I "save the Transport Equipment"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id, 'container-')]/descendant::span[text()='Save']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds
 
@wip @public
Scenario: Web Check In Storage Trailer
#############################################################
# Description: Selects a door and checks in a trailer.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		yard_loc - yard location
#		wh_id - warehouse ID
#	Optional:
#		None
# Outputs:
#	None                     
#############################################################

When I "select the door to receive the trailer and click 'Check In' to check it in"
	Then I assign variable "elt" by combining "xPath://*[@data-recordid='" $yard_loc "*!" $wh_id "']"
	And I click element $elt in web browser within $max_response seconds 

And I "press the 'Check In' button"
	When I assign "xPath://span[text()='Check In' and starts-with(@id,'button')]//..//span[2]" to variable "elt"
	Then I click element $elt in web browser within $max_response seconds