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
# Test Case: BASE-INV-1040 Web Inventory Adjustment Decrease.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description:
# This test case will handle using the Web to complete an inventory adjustment to decrease existing inventory
# and confirm the inventory has been adjusted into the system. If adjustment approvals are enabled and the adjustment
# exceeds the threshold, this test case will acknowledge approval if required and confirm the inventory adjustment is pending
# approval
#
# Input Source: Test Case Inputs/BASE-INV-1040.csv
# Required Inputs:
# 	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal/WEB and datasets processing.
# 	prtnum - Needs to be a valid part number that is assigned in your system
# 	untqty - Quantity being added
# 	uom - Unit of measure to be added. Must be a valid UOM for the item
# 	ftpcod - Footprint code for item to be added. Must be a valid footprint for the item
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
#            This Web readable value (this input value) is translated to the system code value for use in the dataset
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
#            This Web readable value (this input value) is translated to the system code value for use in the dataset
# 	lotnum - Lot Number. This needs to be a valid lot/lot format based on config
#   new_qty - Quantity for the increase. Must be more than QTY (untqty used by dataset)
# Optional Inputs:
# None
#
# Assumptions:
# - This test case is for a decreasing inventory on an existing load in a location
# - Locations, parts, clients, reason codes are set up for a decrease
# - The location is either full or partially full and can take an adjustment (is not empty, locked, or in inventory error)
# - Adjustment approval required will be acknowledged if approval thresholds are configured and adjustment exceeds threshold
# 
# Notes:
# None
#
############################################################ 
Feature: BASE-INV-1040 Web Inventory Adjustment Decrease

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Then I assign "BASE-INV-1040" to variable "test_case"
	When I execute scenario "Test Data Triggers"

	Given I execute scenario "Inventory Adjust Imports"
	Then I execute scenario "Web Environment Setup"

And I "load the dataset"
	Given I "Lookup reacod system code from description via MOCA"
		Then I assign $reacod to variable "code_description"
		And I assign $reacod to variable "save_reacod"
		And I assign "reacod" to variable "code_name"
		Then I execute scenario "Get Code Value from Code Description"
		And I assign $code_value to variable "reacod"

	And I "Lookup invsts system code from description via MOCA"
		Then I assign $invsts to variable "code_description"
        And I assign $invsts to variable "save_invsts"
		And I assign "invsts" to variable "code_name"
		Then I execute scenario "Get Code Value from Code Description"
		And I assign $code_value to variable "invsts"
		
	Then I assign "Web_Inv_Adjustment" to variable "dataset_directory"    
	And I execute scenario "Perform MOCA Dataset"

    Then I assign $save_invsts to variable "invsts"
    And I assign $save_reacod to variable "reacod"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Inv_Adjustment" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-1040
Scenario Outline: BASE-INV-1040 Web Inventory Adjustment Decrease
CSV Examples: Test Case Inputs/BASE-INV-1040.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Screen"

When I execute scenario "Web Inventory Adjustment Change"
And I execute scenario "Web Inventory Adjustment Check that Inventory Adjustment was Successful"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"