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
# Test Case: BASE-INV-1180 Web Inventory Adjustment Approval from Cost.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description:
# This test case will generate a Inventory Adjustment based on cost. It will choose adjustment quantities at an allowable amount, below that allowable amount, and above the allowable amount.
#
# Input Source: Test Case Inputs/BASE-INV-1180.csv
# Required Inputs:
#	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number.
# 	prtnum - Need to be a valid part number that is assigned in your system
# 	untqty - Quantity being added
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
#	actcod - Used by 'create inventory' command
#	ftpcod - Footprint Code
#	srcloc - Source Location
#	lotnum - Lot Number
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
#	adjust_approval_reason - reason code used for the inventory adjustment approval
#	web_credentials - Both WMS User and Cycle Credentials named INV_ADJ_USR_COST
#	username - WEB username (INV_ADJ_USR_COST) to perform WEB logout
#	adj_thresh - should adjustment quantity be set MAX_ALLOWABLE|LESS_THAN|GREATER_THAN based on cost threshold allowed
#	adj_max_cost - maximum threshold the user can adjust without approval ($500 for INV_ADJ_USR_COST user)
# Optional Inputs:
# 	None
# 
# Assumptions:
# - This test requires a WMS User and generated Cycle Credentials for INV_ADJ_USR_COST
#	- User must have permission to setup and approve Inventory Adjustments
#		- setting adj_thr_unit = 0, adj_thr_cst = 500 in les_usr_ath table for INV_ADJ_USR_COST
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: Adjustment at maximum allowable limit based on adj_max_cost without needing approval
#	Example Row: Adjustment at maximum allowable limit - 1 based on adj_max_cost without needing approval
#	Example Row: Adjustment at maximum allowable limit + 1 based on adj_max_cost needing and detecting needed approval
#
############################################################ 
Feature: BASE-INV-1180 Web Inventory Adjustment Approval from Cost

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Adjust Imports"
	Then I execute scenario "Web Environment Setup"

	And I assign "BASE-INV-1180" to variable "test_case"
	When I execute scenario "Test Data Triggers"

	Then I assign "Create_Inventory" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

	Then I execute scenario "Determine Inventory Adjustment Settings by Cost"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Create_Inventory" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-1180
Scenario Outline: BASE-INV-1180 Web Inventory Adjustment Approval from Cost
CSV Examples: Test Case Inputs/BASE-INV-1180.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory outbound screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Screen"

And I "perform the Adjustments in the Inventory relative to limits determined" 
	Then I execute scenario "Web Inventory Adjust With Approval Limits"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"  