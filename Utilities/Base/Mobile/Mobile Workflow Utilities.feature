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
# Utility: Mobile Workflow Utilities.feature
# 
# Functional Area: Workflows
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile
# 
# Description:
# This utility performs Workflows functions within the Mobile App
#
# Public Scenarios:
# 	- Mobile Process Workflow - Checks whether a workflow is being prompted, and process the workflow if so.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Workflow Utilities
 
@wip @public
Scenario: Mobile Process Workflow
#############################################################
# Description: This scenario checks whether the Mobile App is prompting the user to 
# perform a Trailer Safety Check and performs such if so.
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

Given I "check if a workflow is being prompted"
	If I see "Confirm Workflow" in element "className:appbar-title" in web browser within $wait_med seconds 
		Then I "have a pending workflow to process"
			If I see "Perform Trailer Safety Check" in web browser within $wait_med seconds
				Then I execute scenario "Mobile Perform Trailer Safety Check Pass"
			Else I fail step with error message "ERROR: Expected to perform safety checks, but did not see approrpiate screen prompts"
			EndIf
	Else I echo "There is no workflow to process for this activity. Continuing with scenario execution..."
	EndIf

###############################
# Private Scenarios:  
# 	Mobile Perform Trailer Safety Check Pass - Processes a Trailer Safety Check as passing.
###############################

@wip @private
Scenario: Mobile Perform Trailer Safety Check Pass
#############################################################
# Description: This scenario answers 'Y' to all questions to pass a Trailer Safety Check if prompted in Mobile App.
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

Given I "only perform the workflow if prompted"
	If I see "Confirm Workflow" in element "className:appbar-title" in web browser within $wait_short seconds
	And I see "Perform Trailer Safety Check" in web browser within $wait_short seconds
		Given I "press ENTER if needed"
			If I see element "xPath://span[contains(text(),'OK [Enter]')]" in web browser within $screen_wait seconds
				Then I press keys "ENTER" in web browser
			EndIf
			Once I see "Confirm Workflow Instruction" in element "className:appbar-title" in web browser

		Then I "confirm Y to all safety check questions"
			While I see element "xPath://span[contains(text(),'Yes [Y]')]" in web browser within $screen_wait seconds 
			And I see element "xPath://span[contains(text(),'No [N]')]" in web browser within $screen_wait seconds
				Then I type "Y" in web browser
				And I wait $screen_wait seconds
			EndWhile
	Else I "do not have a pending Safety Check, so I simply continue with the scenario..."
	EndIf