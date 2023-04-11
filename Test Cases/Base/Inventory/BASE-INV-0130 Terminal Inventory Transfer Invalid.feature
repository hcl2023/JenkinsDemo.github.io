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
# Test Case: BASE-INV-0130 Terminal Inventory Transfer Invalid.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description: This test case will attempt to move inventory to an invalid location in the Terminal.
#
# Input Source: Test Case Inputs/BASE-INV-0130.csv
# Required Inputs:
# 	srcloc - Where the adjustment will take place. Must be a valid adjustable location in the system
#	dstloc - Destination Location.  Where we deposit the inventory. This will be an invalid storage trailer.
#	valid_dstloc - secondary location to complete transfer.
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal and datasets processing.
# 			 (Note: When lodnum = 'CYC-LOAD-XFER', Cycle will generate a new LPN when processing the dataset.
#			 otherwise, it will use the input lodnum.)
# 	prtnum - Needs to be a valid part number that is assigned in your system
#	untqty - Quantity for the dataset to add inventory . Must be a number. 
#	trlr_id - This will be used as the trailer ID for the trailer
#	carcod - This will be used as the carrier for the shipment
#	yard_loc - Yard Location
#	trlr_cod - Transport Equipment Code
# Optional Inputs:
#	None
# 
# Assumptions: 
# - Regression runs require parts and enough config to deposit inventory into the destination location.
# - Processing will handle standard LPN flow for blind receipts, over receipts, multi-client, multi-wh, lot tracking, aging, qa directed
# - Process ends with the inventory being moved to assign dstloc
#
# Notes:
# None
#
############################################################ 
Feature: BASE-INV-0130 Terminal Inventory Transfer Invalid

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Adjust Imports"

	Then I assign "BASE-INV-0130" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the datasets"
	Then I assign "Create_Trailer" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

	Then I assign "Inv_Transfer" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign row 0 column "lodnum" to variable "xfer_lodnum"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the datasets"
	Then I assign "Create_Trailer" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

	Then I assign "Inv_Transfer" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-0130
Scenario Outline: BASE-INV-0130 Terminal Inventory Transfer Invalid
CSV Examples: Test Case Inputs/BASE-INV-0130.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Terminal"
	And I execute scenario "Terminal Login"

When I "navigate to the transfer screen and perform transfer to storage trailer not at dock door"
Then I "desposit to a known/good location after the attempt to the invalid location"
	Then I execute scenario "Terminal Navigate to Inventory Transfer Menu"
	And I execute scenario "Terminal Inventory Transfer Invalid"
    
And I "validate the transfer occurred properly"
	Then I execute scenario "Inventory Transfer Validate Location"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"