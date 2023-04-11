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
# Test Case: BASE-INV-1090 Web Inventory Release Hold.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description:
# This test case will release hold of Inventory from the Web
#
# Input Source: Test Case Inputs/BASE-INV-1090.csv
# Required Inputs:
# 	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal/WEB and datasets processing.
# 	prtnum - Needs to be a valid part number that is assigned in your system
# 	untqty - Quantity being added
#	adjref1 - Adjustment reference 1 (defaults to stoloc value)
#	adjref2 - Adjustment reference 2 (defaults to prtnum value)
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
# 	lotnum - Lot Number. This needs to be a valid lot/lot format based on config
#	actcod - Activity Code. Used by 'create inventory' command
#	hldnum - Hold Number. Hold Number to be applied to inventory
#	reacodfull - Reason Code Full. Used for the reason code of the inventory status change. Must be full description.
#	hold_mode - Used for processing logic. 1 = Add Hold, 0 = Release Hold
# Optional Inputs:
# None
#
# Assumptions:
# None
#
# Notes:
# - Note that user permissions, Hold Definition, Hold Reason, etc. must all be set up to run successfully
#
############################################################ 
Feature: BASE-INV-1090 Web Inventory Release Hold
 
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

	Then I assign "BASE-INV-1090" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Inv_Release_Hold" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Inv_Release_Hold" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-1090
Scenario Outline: BASE-INV-1090 Web Inventory Release Hold
CSV Examples: Test Case Inputs/BASE-INV-1090.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Screen"

When I execute scenario "Web Inventory Add or Release Hold"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"