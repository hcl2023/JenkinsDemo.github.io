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
# Utility: Terminal Workflow Utilities.feature
# 
# Functional Area: Workflows
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Terminal
# 
# Description:
# This utility performs Workflows functions within the Terminal
#
# Public Scenarios:
# 	- Terminal Process Workflow - Checks whether a workflow is being prompted, and process the workflow if so.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Workflow Utilities
 
@wip @public
Scenario: Terminal Process Workflow
#############################################################
# Description: This scenario checks whether the Terminal is prompting the user to 
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
	If I see "Confirm Workflow" in terminal within $wait_med seconds 
		Then I "have a pending workflow to process"
			If I see "Confirm?" in terminal within $wait_long seconds
			And I see "Perform Trailer Safe" in terminal within $wait_med seconds
				Then I execute scenario "Terminal Perform Trailer Safety Check Pass"
			Else I fail step with error message "ERROR: Expected to perform safety checks, but did not see approrpiate screen prompts"
			EndIf
	Else I echo "There is no workflow to process for this activity. Continuing with scenario execution..."
	EndIf

###############################
# Private Scenarios:  
# 	Terminal Perform Trailer Safety Check Pass - Processes a Trailer Safety Check as passing.
###############################

@wip @private
Scenario: Terminal Perform Trailer Safety Check Pass
#############################################################
# Description: This scenario answers 'Y' to all questions to pass a Trailer Safety Check if prompted in Terminal.
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
	If I see "Confirm?" in terminal within $wait_med seconds 
	And I see "Perform Trailer Safe" in terminal within $wait_short seconds
		Given I "press ENTER if needed"
			If I see "Press" in terminal within $wait_med seconds
			And I see "Enter" in terminal within $wait_short seconds
				Then I press keys "ENTER" in terminal
			EndIf
			
		When I "assign the expected positions for the cursor during the Safety Check questions"
			If I verify text $term_type is equal to "handheld"
				Then I assign 16 to variable "line_pos"
				And I assign 16 to variable "column_pos"
			Else I assign 8 to variable "line_pos"
				And I assign 16 to variable "column_pos"
			EndIf

		Then I "confirm Y to all safety check questions"
			While I see cursor at line $line_pos column $column_pos in terminal within $wait_long seconds 
			And I see "Confirm" in terminal within $wait_med seconds 
			And I see "Y|N" in terminal within $wait_short seconds
				Then I type "Y" in terminal
				And I wait $wait_short seconds
			EndWhile
	Else I "do not have a pending Safety Check, so I simply continue with the scenario..."
	EndIf