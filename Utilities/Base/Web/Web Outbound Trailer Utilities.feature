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
# Utility: Web Outbound Trailer Utilities.feature
# 
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: WEB, MOCA
#
# Description:
# These utility scenarios perform outbound trailer operations in the Web
#
# Public Scenarios:
#	- Web Trailer Check Paperwork - Check for required paperwork
#	- Web Assign Close and Dispatch Variables - Creates close and dispatch variable based on operation
#	- Web Validate Trailer Close Test Functionality Variables - Validates the operation variable is an acceptable value
#	- Web Open Shipping Loads Screen - Opens web screen for Shipping Loads
#	- Web Open Door Activity Screen - Opens web screen for Shipping Door Activity
#	- Web Open Transport Equipment Screen - Opens web screen for Shipping Transport Equipment
#	- Web Open Check In Screen - Opens web screen for Shipping Check In
#	- Web Validate Outbound Trailer Exists for Check In - Checks system for trailer designated for check in
#	- Web Select Check In Without Appointment - This scenario selects the Check In Without Appointment option in the web
#	- Web Search for Outbound Trailer - This scenario selects the trailer/carcod to check in
#	- Web Select Dock Door for Check In - This scenario selects the Input dock door
#	- Web Check In Outbound Trailer - This scenario selects the Check In option in the web
#	- Web Verify Outbound Trailer Check In - This scenario verifies in the web that trailer check in was successful
#	- Web Process Outbound Trailer Safety Check - This scenario processes a safety check for Shipping trailers
#	- Web Search for Load - This scenario searches for the move that will be closed
#	- Web Close the Trailer - This scenario clicks the button to close the trailer
#	- Web Set Dispatch Equipment Check Box - This ensures the dispatch equipment check box is set properly based on operation
#	- Web Click Save - This scenario clicks the save button
#	- Web Verify Paperwork - This scenario verifies there is no required paperwork
#	- Web Verify Confirmation - This scenario waits for the successful confirmation
#	- Web Dispatch the Trailer - This scenario clicks the Dispatch and the Dispatch Load buttons
#	- Web Select Load Row - This scenario selects the row for the Load based on the move_id
#	- Web Set Load Stop - This scenario selects and loads the stop for the load
#	- Web Verify Dock Door Ready - This scenario waits for the LPNs and retrieve dock door to be ready
#	- Web Select Move Immediately, Close, and Dispatch - This scenario selects the move immediately, close equipment, and dispatch equipment if applicable
#	- Web Create Outbound Trailer for Check In - creates a shipping trailer in the web
#	- Web Deassign LPN from Load - deassigns a LPN from a load
#   - Web Delete Stop - This scenario selects and deletes the stop for the load
#	- Web Reopen Transport Equipment - Reopens the sepcified Transport Equipment in the Web
#	- Web Close Transport Equipment from Door Activity - closes trailer from Shipping Door Activity Screen
#	- Web Dispatch Transport Equipment from Door Activity - dispatched trailer from Shipping Door Activity Screen
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Web Outbound Trailer Utilities

wip @public
Scenario: Web Dispatch Transport Equipment from Door Activity
#############################################################
# Description: This scenario dispatches transport equipment from
# door activity screen relative to trailer 
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_id - Trailer ID
#	Optional:
#		None
# Outputs:
#   None                     
#############################################################

Given I "click on Trailer to Dispatch"
	Then I assign variable "elt" by combining "xPath://div[starts-with(text(), '" $trlr_id " | " "')]"
	And I click element $elt in web browser within $max_response seconds

When I "select Dispatch Equipment Menu Item from Actions Drop Down"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and text()='Actions']/.."
	And I click element $elt in web browser within $max_response seconds

	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'menuitem-') and text()='Dispatch Equipment']"
	And I click element $elt in web browser within $max_response seconds

And I "click Save Button on Dispatch Equipment Screen"
	Then I click element "xPath://a[contains(@class,'x-btn w')]/descendant::span[text()='Save']/.." in web browser within $max_response seconds
	And I wait $wait_med seconds
    
And I "verify actions is completed"
	Then I execute scenario "Web Verify Confirmation"

@wip @public
Scenario: Web Close Transport Equipment from Door Activity
#############################################################
# Description: This scenario closes specified Transport Equipment including
# Performing Safety Check Workflows in Web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_id - Trailer ID
#	Optional:
#		None
# Outputs:
#   None                     
#############################################################

Given I "click on Trailer to Close"
	Then I assign variable "elt" by combining "xPath://div[starts-with(text(), '" $trlr_id " | " "')]"
	And I click element $elt in web browser within $max_response seconds

When I "select Close Equipment Menu Item from Actions Drop Down"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and text()='Actions']/.."
	And I click element $elt in web browser within $max_response seconds

	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'menuitem-') and text()='Close Equipment']"
	And I click element $elt in web browser within $max_response seconds
    
Then I "enter Transport Equipment Seal 1 on Close Equipment Screen"    
	And I type $seal in element "xPath://input[@name='equipmentSealField1']" in web browser within $max_response seconds
     
And I "click Save Button on Close Equipment Screen"
	Then I click element "xPath://a[contains(@class,'x-btn w')]/descendant::span[text()='Save']/.." in web browser within $max_response seconds
	And I wait $wait_med seconds
    
And I "perform workflow and click OK to dismiss screen"
	Then I execute scenario "Web Verify Confirmation"

@wip @public
Scenario: Web Reopen Transport Equipment
#############################################################
# Description: This scenario reopens the specified Transport Equipment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_id - Trailer ID
#	Optional:
#		None
# Outputs:
#   None                     
#############################################################

Once I see "Door Activity" in web browser

Given I "click on Trailer to Reopen"
	Then I assign variable "elt" by combining "xPath://div[starts-with(text(), '" $trlr_id " | " "')]"
	And I click element $elt in web browser within $max_response seconds
	
When I "select Reopen Closed Equipment Menu Item from Actions Drop Down"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and text()='Actions']/.."
	And I click element $elt in web browser within $max_response seconds

	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'menuitem-') and text()='Reopen Closed Equipment']"
	And I click element $elt in web browser within $max_response seconds 
    
Then I "accept and confirm the re-open of the equipment"
	Once I see element "xPath://div[contains(text(),'You are about to reopen transport equipment')]" in web browser
	Once I see "Would you like to proceed?" in web browser
	Then I click element "xPath://span[text()='OK']/.." in web browser within $max_response seconds

	Once I see element "xPath://div[contains(text(),'was reopened successfully')]" in web browser
	Then I click element "xPath://span[text()='OK']/.." in web browser within $max_response seconds

Once I see "Door Activity" in web browser

@wip @public
Scenario: Web Trailer Check Paperwork
#############################################################
# Description: Creates required data for test case
# MSQL Files:
#	check_shipping_paperwork_required.msql
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	pprwrk_req - This is used to determine if the warehouse is configured for requiring shipping paperwork to be printed
#############################################################

Given I "Check for required paperwork"
	And I assign "check_shipping_paperwork_required.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"
	And I assign row 0 column "pprwrk_req" to variable "pprwrk_req"

@wip @public
Scenario: Web Assign Close and Dispatch Variables
#############################################################
# Description: Creates close and dispatch variable based on operation
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		operation - LC will set close, LCD will set close and dispatch
#	Optional:
#		None
# Outputs:
#	close - Yes or No for whether to close the trailer
#	dispatch - Yes or No for whether to dispatch the trailer
#############################################################

Given I "check operation to see if I want to close and/or dispatch the trailer after loading"
	Then I assign "No" to variable "close"
	When I assign "No" to variable "dispatch"

	If I verify variable "operation" is assigned
    	If I verify text $operation is equal to "LC"
			Then I assign "Yes" to variable "close"
		Elsif I verify text $operation is equal to "LCD"
			Then I assign "Yes" to variable "close"
			And I assign "Yes" to variable "dispatch"
		EndIf
	EndIf

@wip @public
Scenario: Web Validate Trailer Close Test Functionality Variables
#############################################################
# Description: Validates the operation value for Trailer Close test case.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		operation - CLOSE will close and dispatch trailer, CLOSEONLY closes trailer without dispatch
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "make sure operation setting is a good value"
	When I assign "Yes" to variable "fail_op"
 
	If I verify variable "operation" is assigned
		If I verify text $operation is equal to "CLOSE" ignoring case
			Then I assign "No" to variable "fail_op"
		Elsif I verify text $operation is equal to "CLOSEONLY" ignoring case
			Then I assign "No" to variable "fail_op"
		EndIf
	EndIf

	If I verify text "Yes" is equal to $fail_op ignoring case
		Then I fail step with error message "ERROR: Invalid run time 'operation' parameter"
	EndIf

And I unassign variable "fail_op"
 
@wip @public
Scenario: Validate Trailer Load Test Functionality
#############################################################
# Description: Validates the operation value is acceptable for Trailer Load test case.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		operation - LOAD will load the trailer, LC will load and close, LCD will load close and dispatch
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "make sure 'operation' and 'cleanup' are good values"
	When I assign "Yes" to variable "fail_op"
	
	If I verify variable "operation" is assigned
		If I verify text $operation is equal to "LOAD" ignoring case
			Then I assign "No" to variable "fail_op"
		Elsif I verify text $operation is equal to "LC" ignoring case
			Then I assign "No" to variable "fail_op"
		Elsif I verify text $operation is equal to "LCD" ignoring case
			Then I assign "No" to variable "fail_op"
		EndIf
	EndIf

	If I verify text "Yes" is equal to $fail_op ignoring case
		Then I fail step with error message "ERROR: Invalid run time 'operation' parameter"
	EndIf

And I unassign variable "fail_op"
 
@wip @public
Scenario: Web Open Shipping Loads Screen
#############################################################
# Description: This scenario opens the Shipping Loads screen
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

Given I "go to Search box and enter Loads"
	When I assign "Shipping" to variable "wms_parent_menu"
	And I assign "Loads" to variable "wms_screen_to_open"
	Then I execute scenario "Web Screen Search"
	Once I see "Loads" in web browser

And I unassign variables "wms_parent_menu,wms_screen_to_open"

@wip @public
Scenario: Web Open Door Activity Screen
#############################################################
# Description: This scenario opens the Shipping Door Activity screen
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

Given I "go to the Search box and enter Door Activity"
	When I assign "Shipping" to variable "wms_parent_menu"
	And I assign "Door Activity" to variable "wms_screen_to_open"
	Then I execute scenario "Web Screen Search"
	Once I see "Door Activity" in web browser

And I unassign variables "wms_parent_menu,wms_screen_to_open"
 
@wip @public
Scenario: Web Open Transport Equipment Screen
#############################################################
# Description: This scenario opens the Shipping Transport Equipment screen
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

Given I "go to the Search box and enter Transport Equipment"
	When I assign "Shipping" to variable "wms_parent_menu"
	And I assign "Transport Equipment" to variable "wms_screen_to_open"
	Then I execute scenario "Web Screen Search"
	Once I see "Equipment Status" in web browser

And I unassign variables "wms_parent_menu,wms_screen_to_open"

@wip
Scenario: Web Open Check In Screen
#############################################################
# Description: This scenario opens the Shipping Check In screen
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

Given I "go to the Search box and enter Check In"
	When I assign "Shipping" to variable "wms_parent_menu"
	And I assign "Check In" to variable "wms_screen_to_open"
	Then I execute scenario "Web Screen Search"
	Once I see "Appointments" in web browser

And I unassign variables "wms_parent_menu,wms_screen_to_open"

@wip @public
Scenario: Web Validate Outbound Trailer Exists for Check In
#############################################################
# Description: Checks system for trailer designated for check in
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

Given I "open the Transport Equipment screen and search for trailer"
	When I execute scenario "Web Open Transport Equipment Screen"
	Then I assign "Transport Equipment" to variable "component_to_search_for"
	And I assign $trlr_num to variable "string_to_search_for"
	And I execute scenario "Web Component Search"
	
And I "examine the select trailer"
	If I see $trlr_num in web browser within $wait_med seconds 
	And I see "Expected" in web browser
		Then I echo "the trailer exists and is in Expected status...continue with Check In"
	Else I fail step with error message "ERROR: Expected trailer not found"
	EndIf

And I unassign variables "component_to_search_for,string_to_search_for"

@wip @public
Scenario: Web Select Check In Without Appointment
#############################################################
# Description: This scenario selects the Check In Without Appointment option in the web
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

Given I "click the Check In Without Appointment link"
	When I assign variable "elt" by combining "xPath://a[text()='Check in without appointment']"
	Then I click element $elt in web browser within $max_response seconds 
	
@wip @public
Scenario: Web Search for Outbound Trailer
#############################################################
# Description: This scenario selects the trailer to check in
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - Trailer Number
#		carcod - Carrier Code
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "search for the trailer to check in"
	When I assign variable "elt" by combining "xPath://input[starts-with(@id,'trailerlookup-') and contains(@id,'-inputEl')]"
	Then I click element $elt in web browser within $max_response seconds 
	And I type $trlr_num in element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://div[starts-with(@class,'x-boundlist-item') and text()='" $trlr_num "|" $carcod "']"
	Once I see element $elt in web browser
	Then I click element $elt in web browser within $max_response seconds
	
@wip @public
Scenario: Web Select Dock Door for Check In
#############################################################
# Description: This scenario selects the Input dock door
# MSQL Files:
#	None
# Inputs:
#	Required:
#		dock - the Input dock door for Check In
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "select the Input dock door from the list of doors"
	When I assign variable "elt" by combining "xPath://div[text()='" $dock "']"
	Once I see element $elt in web browser
	Then I click element $elt in web browser within $max_response seconds 
	
@wip @public
Scenario: Web Check In Outbound Trailer
#############################################################
# Description: This scenario selects the Check In option in the web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "click the Check In button"
	When I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and text()='Check In']/.."
	Then I click element $elt in web browser within $max_response seconds
	
@wip @public
Scenario: Web Verify Outbound Trailer Check In
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
#   None                     
#############################################################

Given I "ensure that I see a successful check-in and click the 'OK' button"
	Once I see "Check In Successful" in web browser
	Then I click element $xPath_span_OK_sibling in web browser within $max_response seconds

@wip @public
Scenario: Web Process Outbound Trailer Safety Check
#############################################################
# Description: This scenario processes a safety check for Shipping trailers
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - Trailer Number
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "open the Transport Equipment screen and search for the trailer"
	When I execute scenario "Web Open Transport Equipment Screen"
	Then I assign "Transport Equipment" to variable "component_to_search_for"
	And I assign $trlr_num to variable "string_to_search_for"
	And I execute scenario "Web Component Search"
	
And I "select the selected trailer"
	If I see $trlr_num in web browser within $wait_med seconds 
	And I see "Open For Shippi" in web browser
		Then I execute scenario "Web Transport Equipment Process Trailer Safety Check"
	Else I fail step with error message "ERROR: Expected trailer not found"
	EndIf

And I unassign variables "component_to_search_for,string_to_search_for"

@wip @public
Scenario: Web Search for Load
#############################################################
# Description: This scenario searches for the move that will be closed
# MSQL Files:
#	None
# Inputs:
#	Required:
#		move_id - Move ID
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "search for the load that will be closed"
	Then I assign "Load" to variable "component_to_search_for"
	And I assign $move_id to variable "string_to_search_for"
	And I execute scenario "Web Component Search"

And I unassign variables "component_to_search_for,string_to_search_for"
	
@wip @public
Scenario: Web Close the Trailer
#############################################################
# Description: This scenario clicks the button to close the trailer
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "click the buttons to close the trailer"
	When I assign "xPath://div[text()='Ready To Close']" to variable "elt"
	Then I click element $elt in web browser within $max_response seconds 
	And I assign "xPath://a[text()='Close Load']" to variable "elt"
	And I click element $elt in web browser within $max_response seconds 
	
@wip @public
Scenario: Web Set Dispatch Equipment Check Box
#############################################################
# Description: This ensures the dispatch equipment check box is set properly based on operation
# MSQL Files:
#	None
# Inputs:
#	Required:
#		operation - CLOSE will close and dispatch trailer, CLOSEONLY closes trailer without dispatch
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "ensure Dispatch Equipment check box is set properly based on operation"
	When I wait $screen_wait seconds 
	Once I see "Close Shipping Equipment" in web browser
	And I assign variable "tractor_num" by combining $xPath "//label[text()='Tractor Number']"

	If I verify variable "operation" is assigned
		If I verify text "CLOSE" is equal to $operation
		And I do not see element $tractor_num in web browser within $wait_short seconds 
			Then I "check the Dispatch Equipment check box"
				And I click element "xPath://label[text()='Dispatch Equipment']" in web browser within $max_response seconds 
		Elsif I verify text "CLOSEONLY" is equal to $operation ignoring case
		And I see element $tractor_num in web browser within $wait_short seconds 
			Then I "uncheck the Dispatch Equipment check box"
				And I click element "xPath://label[text()='Dispatch Equipment']" in web browser within $max_response seconds
		EndIf
	EndIf
	
@wip @public
Scenario: Web Click Save
#############################################################
# Description: This scenario clicks the save button
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "click the 'Save' button"
	When I assign variable "save_button" by combining $xPath "//div[contains(@class,'x-docked-bottom')]" $xp_span_Save $xp_span_sibling
	Then I click element $save_button in web browser within $max_response seconds 
	
@wip @public
Scenario: Web Verify Paperwork
#############################################################
# Description: This scenario verifies there is no required paperwork
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "verify there is no required paperwork"
	If I see "Not all shipments have had paperwork printed" in web browser within $wait_med seconds 
	And I verify text $pprwrk_req is equal to "1"
		Then I "cannot close the trailer until the paperwork has been printed"
		And I fail step with error message "ERROR: Cannot close trailer because paperwork is not printed"
	EndIf
	
@wip @public
Scenario: Web Verify Confirmation
#############################################################
# Description: This scenario waits for the successful confirmation
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "handle safety check workflow on close if seen"
	If I see "Safety Check" in web browser within $wait_long seconds
		Then I execute scenario "Web Complete Trailer Safety Check"
	EndIf 

Then I "wait for the confirmation and click the 'OK' button by pressing Enter"
	Once I see "Confirmation" in web browser
	And I see "successfully" in web browser
	Then I press keys "ENTER" in web browser
	
@wip @public
Scenario: Web Dispatch the Trailer
#############################################################
# Description: This scenario clicks the Dispatch and the Dispatch Load buttons
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None                     
#############################################################

Given I "click the buttons to close the trailer"
	When I assign "xPath://div[text()='Dispatch']" to variable "elt"
	Then I click element $elt in web browser within $max_response seconds 
	And I assign "xPath://a[text()='Dispatch Load']" to variable "elt"
	And I click element $elt in web browser within $max_response seconds

@wip @public
Scenario: Web Select Load Row
#############################################################
# Description: This scenario selects the row for the Load based on the move_id
# MSQL Files:
#	None
# Inputs:
#	Required:
#		move_id - Move ID
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "select the row with my Load and wait for the page to load"
	When I assign variable "elt" by combining "xPath://div[text()='" $move_id "']"
	Then I click element $elt in web browser within $max_response seconds

	And I assign variable "elt" by combining "Loads - " $move_id
	Once I see $elt in web browser

@wip @public
Scenario: Web Set Load Stop
#############################################################
# Description: This scenario selects and loads the stop for the load
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "select the check box for the stop I want to load"
	When I click element "xPath://table[starts-with(@id,'checkbox-')]" in web browser within $max_response seconds

Given I "click the load stop button"
	When I click element "xPath://span[text()='Load Stop']/..//span[2]" in web browser within $max_response seconds
	Once I see "Outbound Shipment Stop" in web browser

@wip @public
Scenario: Web Verify Dock Door Ready
#############################################################
# Description: This scenario waits for the LPNs and retrieve dock door to be ready
# MSQL Files:
#	None
# Inputs:
#	Required:
#		dock - This will be used as the dock location for the trailer
#	Optional:
#		dock_door - This will be used as the dock location for the trailer IF and only if dock is not set
# Outputs:
#   None
#############################################################

Given I "check to see if dock is set and if not set to dock_door"
	If I verify variable "dock" is assigned
	And I verify text $dock is not equal to ""
	ElsIf I verify variable "dock_door" is assigned
	And I verify text $dock_door is not equal to ""
		Then I assign $dock_door to variable "dock"
	Else I fail step with error message "ERROR: Inputs dock AND dock_door are not set"
	EndIf

Given I "give the screen time to check LPNs and retrieve dock door"
	When I assign "xPath://input[@name='dockdoor']" to variable "dockdoor"
	Then I copy text inside element $dockdoor in web browser to variable "text_in_dockdoor" within $max_response seconds
	If I verify text $text_in_dockdoor is not equal to $dock
		Then I assign 0 to variable "wait_count"
		While I verify text $text_in_dockdoor is not equal to $dock
		And I verify number $wait_count is less than or equal to 12
			Then I wait $wait_long seconds
			And I assign "" to variable "text_in_dockdoor"
			And I copy text inside element $dockdoor in web browser to variable "text_in_dockdoor" within $max_response seconds
			And I increase variable "wait_count" by 1
		EndWhile
	EndIf

@wip @public
Scenario: Web Select Move Immediately, Close, and Dispatch
#############################################################
# Description: This scenario selects the move immediately, close equipment, and dispatch equipment if applicable
# MSQL Files:
#	None
# Inputs:
#	Required:
#		close - Yes will close the equipment
#		dispatch - Yes will dispatch the equipment
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "make sure the 'Move Immediately' radio button is selected"
	When I click element "xPath://label[text()='Move Immediately']/..//input" in web browser within $max_response seconds

Given I "click the Close Equipment checkbox if I am closing the trailer"
	If I verify text $close is equal to "Yes"
		Then I click element "xPath://label[text()='Close Equipment']/..//input" in web browser within $max_response seconds
	EndIf

Given I "click the Dispatch Equipment check box if I am dispatching the trailer"
	If I verify text $dispatch is equal to "Yes"
		Then I click element "xPath://label[text()='Dispatch Equipment']/..//input" in web browser within $max_response seconds
	EndIf

@wip @public
Scenario: Web Create Outbound Trailer for Check In
#############################################################
# Description: This scenario creates a shipping trailer for check in using the web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - Trailer Number
#		carcod - Carrier Code
#	Optional:
#		None
# Outputs:
#	None                     
#############################################################

Given I execute scenario "Web Open Transport Equipment Screen"

When I "click the Actions drop down"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and text()='Actions']/.."
	And I click element $elt in web browser within $max_response seconds

Then I "click Add Transport Equipment"
	When I assign variable "elt" by combining "xPath://span[starts-with(@id,'menuitem-') and text()='Add Transport Equipment']"
	Then I click element $elt in web browser within $max_response seconds 
	Once I see "Equipment Number" in web browser

And I "enter the trailer number"
	When I assign variable "elt" by combining "xPath://input[@name='trailerNumber']"
	Then I click element $elt in web browser within $max_response seconds 
	And I type $trlr_num in element $elt in web browser within $max_response seconds

And I "select the carrier"
	When I assign variable "elt" by combining "xPath://input[@name='carrier']"
	Then I click element $elt in web browser within $max_response seconds 
	And I type $carcod in element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://li[@role='option' and text()='" $carcod "']"
	And I click element $elt in web browser within $max_response seconds 

And I "ensure I am creating a Shipping trailer"
	When I assign variable "elt" by combining "xPath://input[@name='trailerCode']/../.."
	And I assign variable "elt" by combining $elt "//div[starts-with(@class,'x-trigger-index')]"
	Then I click element $elt in web browser within $max_response seconds 
	And I assign variable "elt" by combining "xPath://li[@role='option' and text()='Shipping']"
	And I click element $elt in web browser within $max_response seconds 

And I "select the type of equipment"
	When I assign variable "elt" by combining "xPath://input[@name='trailerType']"
	Then I click element $elt in web browser within $max_response seconds 
	And I type "Truck" in element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://li[@role='option' and text()='Truck/Transport Equipment']"
	And I click element $elt in web browser within $max_response seconds 

And I "click Save to create the trailer"
	When I assign variable "elt" by combining "xPath://div[contains(@class,'x-docked-bottom')]//span[text()='Save']/.."
	Then I click element $elt in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I execute scenario "Get Trailer ID from Trailer Number"

@wip @public
Scenario: Web Deassign LPN from Load
#############################################################
# Description: This scenario selects the load, navigates to LPNs tab, selects the LPN, 
# and deassign it from the load
# MSQL Files:
#	None
# Inputs:
#	Required:
#		move_id - Move ID 
#		ship_id - Ship ID 
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "select the load"
	Then I assign variable "elt" by combining "xPath://text()[.='" $move_id "']/ancestor::div[1]"
	Once I see element $elt in web browser
	When I click element $elt in web browser within $max_response seconds

Then I "select the LPNs tab on shipping loads screen"
	When I assign variable "elt" by combining "xPath://span[starts-with(@id,'rpCountButton') and text()='LPNs']/.."
	Once I see element $elt in web browser
	And I double click element $elt in web browser within $max_response seconds

And I "maximize the web browser"
	When I maximize web browser

Given I "select the LPN"
	Then I assign variable "elt" by combining "xPath:(//div[contains(@class,'x-grid-row-checker')])[1]"
	Once I see element $elt in web browser
	When I click element $elt in web browser within $max_response seconds

Then I "select the move LPNs to different shipment from actions menu"
	And I assign variable "elt" by combining "xPath://text()[.='Actions']/ancestor::a[1]"
	Once I see element $elt in web browser
	When I click 2 nd element $elt in web browser within $max_response seconds
	Once I see element "xPath://span[text()='Move LPNs to Different Shipment']" in web browser
	When I click element "xPath://span[text()='Move LPNs to Different Shipment']" in web browser within $max_response seconds

And I "select Leave as unassigned shipments and click save"
	Once I see element "xPath://label[text()='Leave as unassigned shipments.']" in web browser
	When I click element "xPath://label[text()='Leave as unassigned shipments.']" in web browser within $max_response seconds
	Given I assign variable "elt" by combining "xPath://span[text()='Save']"
	Then I assign $elt to variable "save_button"
	Once I see element $save_button in web browser
	When I double click element $save_button in web browser within $max_response seconds

Then I "validate shipment was split sucessfully"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[text()='Shipment " $ship_id ""
	And I assign variable "elt" by combining $elt " was split successfully.']"
	Once I see element $elt in web browser
	Once I see element "xPath://span[text()='OK']" in web browser
	When I double click element "xPath://span[text()='OK']" in web browser within $max_response seconds
    
@wip @public
Scenario: Web Delete Stop
#############################################################
# Description: This scenario selects and deletes the stop for the load
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "select the check box for the stop I want to load"
	When I click element "xPath://table[starts-with(@id,'checkbox-')]" in web browser within $max_response seconds

Then I "click the load stop button"
	And I click element "xPath://span[text()='Delete']/..//span[2]" in web browser within $max_response seconds

When I "wait for the confirmation and click the 'OK' button by pressing Enter"
	Once I see "Confirm Delete" in web browser
	Then I press keys "ENTER" in web browser

And I wait $wait_med seconds

#############################################################
# Private Scenarios:
#	Get Trailer ID from Trailer Number - gets the Trailer ID based on the Trailer Number
#############################################################

@wip @private
Scenario: Get Trailer ID from Trailer Number
#############################################################
# Description: This scenario gets the trlr_id from the trlr_num
# MSQL Files:
#	get_trailer_id_from_trailer_number.msql
# Inputs:
#	Required:
#		trlr_num - Trailer Number
#	Optional:
#		None
# Outputs:
#   trlr_id - Trailer ID
#############################################################

Given I "call MSQL to get trailer ID from trailer number"
	Then I assign "get_trailer_id_from_trailer_number.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
	And I assign row 0 column "trlr_id" to variable "trlr_id"