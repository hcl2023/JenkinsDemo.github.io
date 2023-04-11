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
# Test Case: BASE-INV-1140 Web Inventory Relabel LPN.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description:
# This test case will relabel an LPN for an Inventory from the Web.
#
# Input Source: Test Case Inputs/BASE-INV-1140.csv
# Required Inputs:
#	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal and datasets processing
# 	new_lodnum - Used to set the inventory's lodnum to this value
# 	prtnum - Needs to be a valid part number that is assigned in your system
# 	untqty - Quantity being added
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
#	actcod - Used by 'create inventory' command
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
# 	lotnum - Lot Number. This needs to be a valid lot/lot format based on config
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
# Optional Inputs:
# 	None
# 
# Assumptions:
#	None
#
# Notes:
#	None
#
############################################################ 
Feature: BASE-INV-1140 Web Inventory Relabel LPN

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

	And I assign "BASE-INV-1140" to variable "test_case"
	When I execute scenario "Test Data Triggers"
    
	Then I assign "Create_Inventory_Load" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Create_Inventory_Load" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
	And I assign $new_lodnum to variable "lodnum"
	And I assign "Create_Inventory_Load" to variable "cleanup_directory"
	Then I execute scenario "Perform MOCA Cleanup Script"   

@BASE-INV-1140
Scenario Outline: BASE-INV-1140 Web Inventory Relabel LPN
CSV Examples: Test Case Inputs/BASE-INV-1140.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory outbound screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open the Inventory Outbound Screen"

And I execute scenario "Web Select LPN to Modify"
And I execute scenario "Web Select Relabel LPN Action"
When I execute scenario "Web Inventory Relabel LPN"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"