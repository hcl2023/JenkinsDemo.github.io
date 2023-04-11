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
# Test Case: BASE-INV-4070 Mobile Inventory Status Change.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
# 
# Description: This test case changes the status of an inventory identifier in the Mobile App
#
# Input Source: Test Case Inputs/BASE-INV-4070.csv
# Required Inputs:
# 	stoloc - Location where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Mobile App/WEB and datasets processing
# 	prtnum - Needs to be a valid part number that is assigned in your system
# 	untqty - Quantity being added
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
# 	reacod - System reason code for status change. Must exist as a valid reason code in the system
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
# 	lotnum - Lot Number. This needs to be a valid lot/lot format based on config
#	actcod - Activity Code, used by 'create inventory command'
#	new_sts - Status change value
#	new_sts_full_string - Full string representing the new status code (i.e. Damaged Product)
#	new_sts_use_f2 - use F2 to chooose new_sts value from value lookup list
# Optional Inputs:
# None
#
# Assumptions:
# - Locations, parts, clients, reason codes are set up for status change
#  
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: one representing Available status and then typing new_sts (D) directly into Mobile element
#	Example Row: one representing Available status and then selecting new_sts (Damaged Product) from F2 generated values list
#	Example Row: one representing Damaged status and then typing new_sts (A) directly into Mobile element
#	Example Row: one representing Damaged status and selecting new_sts (Available) from F2 generated values list
#
############################################################ 
Feature: BASE-INV-4070 Mobile Inventory Status Change
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Inventory Imports"

	Then I assign "BASE-INV-4070" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Inv_Terminal_Adjustment" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Inv_Terminal_Adjustment" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-INV-4070
Scenario Outline: BASE-INV-4070 Mobile Inventory Status Change
CSV Examples: Test Case Inputs/BASE-INV-4070.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Mobile App"
	And I execute scenario "Mobile Login"
    
When I "navigate to the status change menu and perform the status change"
	Then I execute scenario "Mobile Inventory Status Change Menu"
	And I execute scenario "Mobile Inventory Status Change"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"