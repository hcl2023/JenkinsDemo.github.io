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
# Test Case: BASE-INV-0150 Terminal Inventory Partial Move Multiple LPNs.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, Terminal
#
# Description: This test case will perform a Terminal inventory move of a partial quantity in a load for multiple LPNs and verify that the moves were successful.
#
# Input Source: Test Case Inputs/BASE-INV-0150.csv
# Required Inputs:
# 	srcloc - The source location of the LPN (load number) to be moved. Must be a valid adjustable/storable location in the system. Used in load dataset processing.
# 	dstloc - The destination location of the LPN to be moved. Must be a valid adjustable/storable location in the system. Must be a different location than the source location. Used in Terminal interactions and post move validation.
# 	srclod - Load number added by dataset and moved by the main scenario. Can be a fabricated number.
# 	prtnum_list - Comma separated list of valid part numbers that are assigned in your system and will use to generated 
#	untqty - Quantity for the dataset to add inventory . Must be a number. Quantity used for all prtnums in prtnum_list
#	move_qty - Qty to be moved from source to destination if moving less than a full load. Used in Terminal interactions and post move validation.
# Optional Inputs:
# None
#
# Assumptions:
# - This test case is for moving a single or multiple item LPN (load number) from a source location to a destination location
# - Locations, parts, clients, reason codes are set up for an inventory movement
# - If moving a partial quantity, the move_qty variable is populated and is less than the untqty variable used by the load dataset
# - If moving a partial qty, the dstlod variable is populated for the new LPN that is created with the partial move qty
#
# Notes:
# - None
#
############################################################ 
Feature: BASE-INV-0150 Terminal Inventory Partial Move Multiple LPNs
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Adjust Imports"

	And I assign "BASE-INV-0150" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the datasets (one for each prtnum/lodnum being added)"
	If I verify variable "prtnum_list" is assigned
	And I verify text $prtnum_list is not equal to ""
		Then I assign 1 to variable "prtnum_cnt"
		While I assign $prtnum_cnt th item from "," delimited list $prtnum_list to variable "prtnum"
			And I assign "Inv_Transfer" to variable "dataset_directory"
			Then I execute scenario "Perform MOCA Dataset"
			And I assign row 0 column "lodnum" to variable "srclod"

			If I verify variable "srclod_list" is assigned
			And I verify text $srclod_list is not equal to ""
				Then I assign variable "srclod_list" by combining $srclod_list "," $srclod
			Else I assign $srclod to variable "srclod_list"
			EndIf

			And I increase variable "prtnum_cnt" by 1
		EndWhile
		And I unassign variables "prtnum,srclod,prtnum_cnt"
	EndIf
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

When I "cleanup the datasets relative source location and lodnum"
	If I verify variable "srclod_list" is assigned
	And I verify text $srclod_list is not equal to ""
		Then I assign 1 to variable "lodnum_cnt"
		While I assign $lodnum_cnt th item from "," delimited list $srclod_list to variable "srclod"
			Then I assign $srclod to variable "lodnum"
			And I assign "Inv_Transfer" to variable "cleanup_directory"
			Then I execute scenario "Perform MOCA Cleanup Script"

			And I increase variable "lodnum_cnt" by 1
		EndWhile
		And I unassign variables "lodnum_cnt,srclod,lodnum"
	EndIf

When I "cleanup the datasets relative to deposited LPNs"
	If I verify variable "dep_lpn_list" is assigned 
	And I verify text $dep_lpn_list is not equal to ""
		Then I assign 1 to variable "lpn_cnt"
		While I assign $lpn_cnt th item from "," delimited list $dep_lpn_list to variable "lodnum"
			And I assign "Inv_Transfer" to variable "cleanup_directory"
			Then I execute scenario "Perform MOCA Cleanup Script"
			And I increase variable "lpn_cnt" by 1
		EndWhile
		And I unassign variables "lpn_cnt,lodnum"
	EndIf

@BASE-INV-0150
Scenario Outline: BASE-INV-0150 Terminal Inventory Partial Move Multiple LPNs
CSV Examples: Test Case Inputs/BASE-INV-0150.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Terminal and navigate to partial inventory move screen"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal Navigate to Partial Inventory Move Menu"

When I "perform and validate the partial inventory moves"
	Then I execute scenario "Terminal Partial Inventory Move"

	If I verify variable "prtnum_list" is assigned
	And I verify text $prtnum_list is not equal to ""
		Then I assign 1 to variable "prtnum_cnt"
		While I assign $prtnum_cnt th item from "," delimited list $prtnum_list to variable "prtnum"
			And I execute scenario "Validate Partial Move Was Successful"
			Then I increase variable "prtnum_cnt" by 1
		EndWhile
	EndIf

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"