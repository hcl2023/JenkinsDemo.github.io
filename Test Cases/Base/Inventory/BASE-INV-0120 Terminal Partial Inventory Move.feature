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
# Test Case: BASE-INV-0120 Terminal Partial Inventory Move.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, Terminal
#
# Description: This test case will perform a terminal inventory move of a partial quantity in a load and verify that the move was successful.
#
# Input Source: Test Case Inputs/BASE-INV-0120.csv
# Required Inputs:
# 	srcloc - The source location of the LPN (load number) to be moved. Must be a valid adjustable/storable location in the system. Used in load dataset processing.
# 	dstloc - The destination location of the LPN to be moved. Must be a valid adjustable/storable location in the system. Must be a different location than the source location. Used in Terminal interactions and post move validation.
# 	srclod - Load number added by dataset and moved by the main scenario. Can be a fabricated number. Used in dataset processing and in Web interactions.
#	prtnum - This needs to be a valid part number that is defined in your system. The part will use the default client_id defined in Environment.feature. Used in load dataset processing and Terminal validation.
#	untqty - Quantity for the dataset to add inventory. Must be a number. Used in load dataset processing and Web validation.
#	ftpcod - Footprint code for item to be adjusted. Must be a valid footprint for the item. Used in load dataset processing.
#	move_qty - Qty to be moved from source to destination if moving less than a full load. Used in terminal interactions and post move validation.
# Optional Inputs:
# None
#
# Assumptions:
# - This test case is for moving a single item LPN (load number) from a source location to a destination location
# - Locations, parts, clients, reason codes are set up for an inventory movement
# - If moving a partial quantity, the move_qty variable is populated and is less than the untqty variable used by the load dataset
# - If moving a partial qty, the dstlod variable is populated for the new LPN that is created with the partial move qty
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: one representing a complete move of inventory
#	Example Row: one representing a partial move of inventory
#
############################################################ 
Feature: BASE-INV-0120 Terminal Partial Inventory Move
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Adjust Imports"

	And I assign "BASE-INV-0120" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Inv_Part_Move" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I "cleanup source location"
		And I assign $srclod to variable "lodnum"
		And I assign $srcloc to variable "stoloc"
		Then I assign "Inv_Part_Move" to variable "cleanup_directory"
		And I execute scenario "Perform MOCA Cleanup Script"
	And I "cleanup destination location"
		If I verify variable "dep_lpn" is assigned
		And I verify text $dep_lpn is not equal to "" ignoring case
			Then I assign $dep_lpn to variable "lodnum"
			And I assign $dstloc to variable "stoloc"
			And I assign "Inv_Part_Move" to variable "cleanup_directory"
			Then I execute scenario "Perform MOCA Cleanup Script"
		EndIf

@BASE-INV-0120
Scenario Outline: BASE-INV-0120 Terminal Partial Inventory Move
CSV Examples: Test Case Inputs/BASE-INV-0120.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Terminal and navigate to audit count screen"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal Navigate to Partial Inventory Move Menu"

When I "perform and validate the partial inventory move"
	Then I execute scenario "Terminal Partial Inventory Move"
	And I execute scenario "Validate Partial Move Was Successful"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"