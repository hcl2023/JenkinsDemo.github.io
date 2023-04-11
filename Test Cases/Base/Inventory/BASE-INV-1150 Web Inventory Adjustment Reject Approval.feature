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
# Test Case: BASE-INV-1150 Web Inventory Adjustment Reject Approval.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description:
# This test case will reject a Inventory Adjustment approval in the Web
#
# Input Source: Test Case Inputs/BASE-INV-1150.csv
# Required Inputs:
#	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number.
# 	prtnum - Need to be a valid part number that is assigned in your system
# 	untqty - Quantity being added
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
#	actcod - Used by 'create inventory' command
#	ftpcod - Footprint Code
#	srcloc - Source Location
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
# 	lotnum - Lot Number. This needs to be a valid lot/lot format based on config
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
#	adj_untqty - adjust inventory quantity to this value
#	adjust_approval_reason - reason code used for the inventory adjustment approval
#	web_credentials - Both WMS User and Cycle Credentials named INV_ADJ_USR
#	username - WEB username (INV_ADJ_USR) to perform WEB logout
#	approval_needed - TRUE indicates that WEB dialog will be presented to note approval is needed
# Optional Inputs:
# 	None
# 
# Assumptions:
# - This test requires a WMS User and generated Cycle Credentials for INV_ADJ_USR
#	- User must have permission to setup and approve Inventory Adjustments
#		- setting adj_thr_unit = 1, adj_thr_cst = 1 in les_usr_ath table for INV_ADJ_USR
#
# Notes:
#	None
#
############################################################ 
Feature: BASE-INV-1150 Web Inventory Adjustment Reject Approval

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

	And I assign "BASE-INV-1150" to variable "test_case"
	When I execute scenario "Test Data Triggers"

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

@BASE-INV-1150
Scenario Outline: BASE-INV-1150 Web Inventory Adjustment Reject Approval
CSV Examples: Test Case Inputs/BASE-INV-1150.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory outbound screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Screen"

And I "perform the Adjustments in the Inventory"
	When I execute scenario "Web Inventory Adjust With Approval Limits"

And I "navigate to the Inventory Adjustments Screen"
	Then I execute scenario "Web Open Inventory Adjustments Screen"
    
And I "perform the Approval for the Inventory Adjustments"
	Then I execute scenario "Web Reject Inventory Adjustments"
    
And I "verify cycle count is generated or Not"  
	Then I execute scenario "Validate Cycle Count"
    
Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"