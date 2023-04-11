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
# Test Case: BASE-INV-5010 Flow Inventory Adjust With Approval Limits.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA, Web
#
# Description: This test case will Adjust Inventory with Approval Limits via terminal
#
# Input Source: Test Case Inputs/BASE-INV-5010.csv
# Required Inputs:
#	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number.
# 	prtnum - Needs to be a valid part number that is assigned in your system
# 	untqty - Quantity being added
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
#	actcod - Used by 'create inventory' command
#	ftpcod - Footprint Code
#	srcloc - Source Location
#	dstloc - Destination Location
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
# 	lotnum - Lot Number. This needs to be a valid lot/lot format based on config
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
#	adjust_approval_reason - reason code used for the inventory adjustment approval
#	adj_qty - adjust inventory quantity to this value
#	web_credentials - Both WMS User and Cycle Credentials named INV_ADJ_USR
#	username - WEB username (INV_ADJ_USR) to perform WEB logout
# Optional Inputs:
# None
#
# Assumptions:
# - This test requires a WMS User and generated Cycle Credentials for INV_ADJ_USR
#	- User must have permission to setup and approve Inventory Adjustments
#		- setting adj_thr_unit = 1, adj_thr_cst = 1 in les_usr_ath table for INV_ADJ_USR
#
# Notes:
# 	None
#
############################################################
Feature: BASE-INV-5010 Flow Inventory Adjust With Approval Limits

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

	Then I assign "BASE-INV-5010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Create_Inventory" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Create_Inventory" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-5010
Scenario Outline: BASE-INV-5010 Flow Inventory Adjust With Approval Limits
CSV Examples: Test Case Inputs/BASE-INV-5010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the terminal"
	And I execute scenario "Terminal Login"
    
When I "navigate to the terminal adjustment screen and perform the adjustment"
	Then I assign $adj_untqty to variable "new_qty"
	And I execute scenario "Terminal Inventory Adjustment Menu"
	And I execute scenario "Terminal Inventory Adjustment Change"
    
And I "open Inventory Adjustments Screen"
	Then I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Adjustments Screen"

And I "perform the Approval for the Inventory Adjustments"
	Then I execute scenario "Web Approve Inventory Adjustments"
    
And I "verify the Adjustments in the Inventory has done Successfully or Not"
	Then I execute scenario "Validate Inventory Adjust With Approval Limits"
	
Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"	