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
# Test Case: BASE-INV-4040 Mobile Inventory Adjustment Decrease.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This test case decrements inventory on an existing load in a location on the Mobile App
#
# Input Source: Test Case Inputs/BASE-INV-4040.csv
# Required Inputs:
# 	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Mobile App and datasets processing.
# 	prtnum - Needs to be a valid part number that is assigned in your system
# 	client_id - Client for the adjustment inventory. Must be a valid client
# 	untqty - Quantity being added
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
# 	lotnum - Lot Number. This needs to be a valid lot/lot format based on config
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
#	actcod - Activity Code. Used by 'create inventory' command
#   new_qty - Quantity for the increase. Must be greater than untqty
# Optional Inputs:
# None
# 
# Assumptions:
# - This test case is for adding qty to an existing load in a location
# - Locations, parts, clients, reason codes are set up for adjustment
# - Adjustment approval required will be acknowledged if approval thresholds are configured and adjustment exceeds threshold
# 
# Notes:
# None
#
############################################################ 
Feature: BASE-INV-4040 Mobile Inventory Adjustment Decrease

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Inventory Imports"

	Then I assign "BASE-INV-4040" to variable "test_case"
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

@BASE-INV-4040
Scenario Outline: BASE-INV-4040 Mobile Inventory Adjustment Decrease
CSV Examples: Test Case Inputs/BASE-INV-4040.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Mobile App"
	And I execute scenario "Mobile Login"

When I "navigate to the adustment screen and perform the adjustment"
	Then I execute scenario "Mobile Inventory Adjustment Menu" 
	And I execute scenario "Mobile Inventory Adjustment Change"
	And I execute scenario "Mobile Inventory Adjustment Complete"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"