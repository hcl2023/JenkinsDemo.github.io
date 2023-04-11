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
# Test Case: BASE-INV-4020 Mobile Inventory Adjustment Delete.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This test case deletes a single load of inventory on the Mobile App
#
# Input Source: Test Case Inputs/BASE-INV-4020.csv
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
# Optional Inputs:
# None
# 
# Assumptions:
# - This test case is for a single load Delete of location containing 1 pallet
# - Locations, parts, clients, reason codes are set up for an Delete
# - Adjustment approval required will be acknowledged if approval thresholds are configured and adjustment exceeds threshold
# - A cycle purge is needed to remove pending adjustment approval when the adjustment exceeds configured threshold
#
# Notes:
# None
#
############################################################ 
Feature: BASE-INV-4020 Mobile Inventory Adjustment Delete

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Inventory Imports"

	Then I assign "BASE-INV-4020" to variable "test_case"
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

@BASE-INV-4020
Scenario Outline: BASE-INV-0020 Mobile Inventory Adjustment Delete
CSV Examples: Test Case Inputs/BASE-INV-4020.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

And I "login to the Mobile App"
	Then I execute scenario "Mobile Login"
    
When I "navigate to the adjustment screen and perform the adjustment"
	Then I execute scenario "Mobile Inventory Adjustment Menu"
	And I execute scenario "Mobile Inventory Adjustment Delete"
	And I execute scenario "Mobile Inventory Adjustment Complete"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"