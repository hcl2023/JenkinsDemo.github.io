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
# Utility: Web Workflow Utilities.feature
# 
# Functional Area: Workflows
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Web
# 
# Description:
# Utility scenarios to perform Workflows within the Web
#
# Public Scenarios:
#	- Web Door Activity Process Trailer Safety Check - Performs Trailer Safety Check for Door Activity Processes via the Web.
# 	- Web Transport Equipment Process Trailer Safety Check - Performs a  Trailer Safety Check for Transport Equipment via the Web.
#	- Web Shipping Loads Process Trailer Safety Check - Performs a Trailer Safety Check for Shipping Loads via the Web.
#	- Web Perform Transport Equipment Workflow Safety Check Pass - Performs a Safety Check for Transport Equipment as passing via the Web.
#   - Web Perform Trailer Safety Check Pass - Performs a Trailer Safety Check with Pass responses via Web
#	- Web Complete Trailer Safety Check - Completes the Trailer Safety Check with Yes responses via Web
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Web Workflow Utilities

@wip @public
Scenario: Web Door Activity Process Trailer Safety Check
#############################################################
# Description: This scenario performs a Trailer Safety Check when prompted on the Door Activities screen in the Web.
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

Given I "only perform the trailer safety check if prompted"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@class,'hot') and text()='Safety']"
	# If we see the option for the safety check, click it and perform the check.  Otherwise, skip the process and continue.
	If I see element $elt in web browser within $wait_short seconds 
		Then I "select Safety Check from the Actions drop down"
			And I click element "xPath://div[starts-with(@id,'wm-loaddetails-bottomcontrols-')]//span[text()='Actions']//.." in web browser within $max_response seconds
			And I click element "xPath://span[starts-with(@id,'menuitem-') and text() ='Safety Check']" in web browser within $max_response seconds
			
		When I "perform and pass the Safety Check"
			And I execute scenario "Web Perform Trailer Safety Check Pass"
			
		Then I "return to the Door Activity screen and proceed with trailer closing."
			Once I see "Door Activity" in web browser
			Then I click element $trailer in web browser within $max_response seconds             
	Else I "do not need to perform a Safety Check"
		Then I assign "NONE" to variable "safety_check_status"
	EndIf

@wip @public
Scenario: Web Transport Equipment Process Trailer Safety Check
#############################################################
# Description: This scenario performs a Trailer Safety Check when prompted during on the Transport Equipment screen in the Web.
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

Given I "perform the trailer safety check if required for the trailer"
	Then I "check for the prompt to perform the Safety Check and run through the check if found."
  	And I assign variable "elt" by combining "xPath://div[starts-with(@class,'rpux-tag-component') and text()='Safety']"
	If I see element $elt in web browser within $wait_med seconds 
		Then I click element $elt in web browser within $max_response seconds

		When I "click the Perform Safety Check link"
			Given I assign variable "elt" by combining "xPath://a[starts-with(@id,'hyperlink') and text()='Perform Safety Check']"
			Then I click element $elt in web browser within $max_response seconds

			And I execute scenario "Web Perform Trailer Safety Check Pass"

			Then I "return to the Transport Equipment screen, clear the search filter, and search for the trailer again"
				# Assign the xPath for the buttons to return to the Transport Equipment screen.
				Given I assign variable "elt" by combining "xPath://a[contains(@class,'rp-close-filter-btn')]"
				Then I wait $wait_long seconds
				And I click element $elt in web browser within $max_response seconds

				Then I assign "Transport Equipment" to variable "component_to_search_for"
				And I assign $trlr_num to variable "string_to_search_for"
				And I execute scenario "Web Component Search"

		Then I "Select the selected transport equipment choice to confirm it has passed the safety check"
				If I see "Passed" in web browser within $wait_long seconds
					Then I "have successfully performed the Safety Check!"
				Else I assign variable "error_message" by combining "ERROR: Failed to confirm Safety Check has passed for trlr_num " $trlr_num " in Web"
					Then I fail step with error message $error_message
				EndIf              
	Else I assign "NONE" to variable "safety_check_status"
	EndIf   

@wip @public
Scenario: Web Shipping Loads Process Trailer Safety Check
#############################################################
# Description: This scenario performs a Trailer Safety Check when
# set safety button is visible on screen. Can be seen as a span
# or a div element, and scenario handles both cases.
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

Given I "assign the element to check for the Safety Check prompt."
	Then I assign variable "elt_div" by combining "xPath://div[starts-with(@class,'rpux-tag-') and text()='Safety']"
	And I assign variable "elt_span" by combining "xPath://span[starts-with(@class,'rpux-tag-') and text()='Safety']"
	
Then I "check for the prompt and perform the safety check if found."
	And I assign "FALSE" to variable "safety_check_seen"
	If I see element $elt_div in web browser within $wait_med seconds
    	Then I assign "TRUE" to variable "safety_check_seen"
		And I assign $elt_div to variable "elt"
    Elsif I see element $elt_span in web browser within $wait_med seconds
    	Then I assign "TRUE" to variable "safety_check_seen"
		And I assign $elt_span to variable "elt"
    EndIf
	
    If I verify text $safety_check_seen is equal to "TRUE"
		Given I "click the prompt for the safety check"
			Then I click element $elt in web browser within $max_response seconds
		
		When I "click to begin the safety check"
			Given I assign variable "elt" by combining "xPath://a[starts-with(@id,'hyperlink-') and text()='Perform Safety Check']"
			Then I click element $elt in web browser within $max_response seconds
			And I wait $wait_med seconds
		Then I "perform the safety check"
			Then I execute scenario "Web Perform Trailer Safety Check Pass"
	Else I "was not prompted for a Safety Check and continue the scenario."
	EndIf
    
	And I unassign variables "elt,elt_span,elt_div"

@wip @public
Scenario: Web Perform Transport Equipment Workflow Safety Check Pass
#############################################################
# Description: This scenario performs a Trailer Safety Check when prompted during on the Transport Equipment screen in the Web.
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

Given I "only perform the Safety Check if prompted"
	If I see "Transport Equipment Workflow" in web browser within $wait_long seconds 
		Given I "assign the xPath for the 'Yes' button"
			Then I assign variable "elt" by combining "xPath://a[not(contains(@class,'x-pressed'))]"
			And I assign variable "elt" by combining $elt "//span[text()='Yes']/.."
			And I assign variable "pass_not_pressed" by combining $elt
		
		Then I "Pass all of the safety check questions"
			While I see element $pass_not_pressed in web browser within $wait_med seconds 
				Then I click element $pass_not_pressed in web browser within $max_response seconds
			EndWhile
			
		Then I "save the safety check" 
			# Assign the xPath for the Complete button
			And I assign variable "elt" by combining "xPath://div[contains(@class,'wm-formView-save-toolbar')]"  
			And I assign variable "elt" by combining $elt "//span[text()='Complete']/.."
			# Click to Complete
			And I click element $elt in web browser within $max_response seconds 
	Else I "was not prompted to perform the Safety Check and continue the scenario."
	EndIf

@wip @public
Scenario: Web Perform Trailer Safety Check Pass
#############################################################
# Description: This scenario performs a Trailer Safety Check when prompted (with Pass) within the Web.
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

Given I "check to see if a Safety Check is prompted"
	If I see "Safety Checks:" in web browser within $wait_long seconds
		Given I "create the xPath to click to run through the Safety Check"
			Then I assign variable "elt" by combining "xPath://a[not(contains(@class,'x-pressed'))]"
			And I assign variable "elt" by combining $elt "//span[text()='Pass']/.."
			And I assign variable "pass_not_pressed" by combining $elt
			
		When I "pass all of the safety check questions"
			While I see element $pass_not_pressed in web browser within $wait_med seconds 
				Then I click element $pass_not_pressed in web browser within $max_response seconds
			EndWhile
			
		Then I "save the safety check" 
			# Assign xPath for the Save buttton.
			Given I assign variable "elt" by combining "xPath://div[contains(@class,'wm-formView-save-toolbar')]"  
			And I assign variable "elt" by combining $elt "//span[text()='Save']/.."
			Then I click element $elt in web browser within $max_response seconds 
	Else I "did not perform a safety check since none were prompted"
	EndIf

@wip @public
Scenario: Web Complete Trailer Safety Check
#############################################################
# Description: This scenario Completes the Trailer Safety Check when prompted (with Yes) within the Web.
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

Given I "check to see if a Safety Check is prompted"
	If I see element "xPath://span[text()='Perform Trailer Safety Check - Warehouse Immediate']" in web browser within $wait_long seconds
		Given I "create the xPath to click to run through the Safety Check"
			Then I assign variable "elt" by combining "xPath://a[not(contains(@class,'x-pressed'))]"
			And I assign variable "elt" by combining $elt "//span[text()='Yes']/.."
			And I assign variable "yes_not_pressed" by combining $elt
			
		When I "click Yes to all the safety check questions"
			While I see element $yes_not_pressed in web browser within $wait_med seconds 
				Then I click element $yes_not_pressed in web browser within $max_response seconds
			EndWhile
			
		Then I "click Complete Button"
			And I click element "xPath://span[text()='Complete']/ancestor::span[@class='x-btn-button']/span[2]" in web browser within $max_response seconds
	Else I "did not perform a safety check since none were prompted"
	EndIf

#############################################################
# Private Scenarios:
#	None
#############################################################