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
# Test Case: BASE-INV-4140 Mobile Inventory Transfer Multiple LPNs Undirected.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This test case performs a full inventory move of multiple LPNs as Undirected work in the Mobile App
#
# Input Source: Test Case Inputs/BASE-INV-4140.csv
# Required Inputs:
# 	srcloc - Where the adjustment will take place. Must be a valid adjustable location in the system
#	dstloc - Destination Location.  Where we deposit the inventory.
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal and datasets processing.
# 			 (Note: When lodnum = 'CYC-LOAD-XFER', Cycle will generate a new LPN when processing the dataset.
#			 otherwise, it will use the input lodnum.)
# 	prtnum_list - Comma separated list of valid part numbers that are assigned in your system and will use to generated inventory
#	untqty - Quantity for the dataset to add inventory . Must be a number. Quantity used for all prtnums in prtnum_list
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
Feature: BASE-INV-4140 Mobile Inventory Transfer Multiple LPNs Undirected

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Inventory Imports"

	Then I assign "BASE-INV-4140" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the datasets (one for each prtnum/lodnum being added)"
	If I verify variable "prtnum_list" is assigned
	And I verify text $prtnum_list is not equal to ""
		Then I assign 1 to variable "prtnum_cnt"
		While I assign $prtnum_cnt th item from "," delimited list $prtnum_list to variable "prtnum"
			And I assign "Inv_Transfer" to variable "dataset_directory"
			Then I execute scenario "Perform MOCA Dataset"
			And I assign row 0 column "lodnum" to variable "xfer_lodnum"

			If I verify variable "xfer_lodnum_list" is assigned
			And I verify text $xfer_lodnum_list is not equal to ""
				Then I assign variable "xfer_lodnum_list" by combining $xfer_lodnum_list "," $xfer_lodnum
			Else I assign $xfer_lodnum to variable "xfer_lodnum_list"
			EndIf

			And I increase variable "prtnum_cnt" by 1
		EndWhile
		And I unassign variables "prtnum_cnt,prtnum,xfer_lodnum"
	EndIf

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
   
When I "cleanup the datasets relative to each lodnum"
	Then I assign 1 to variable "lodnum_cnt"
	If I verify variable "xfer_lodnum_list" is assigned
	And I verify text $xfer_lodnum_list is not equal to ""
		While I assign $lodnum_cnt th item from "," delimited list $xfer_lodnum_list to variable "xfer_lodnum"
			Then I assign $xfer_lodnum to variable "lodnum"
			And I assign "Inv_Transfer" to variable "cleanup_directory"
			Then I execute scenario "Perform MOCA Cleanup Script"

			And I increase variable "lodnum_cnt" by 1
		EndWhile
	EndIf

And I unassign variables "lodnum_cnt,xfer_lodnum"

@BASE-INV-4140
Scenario Outline: BASE-INV-4140 Mobile Inventory Transfer Multiple LPNs Undirected
CSV Examples: Test Case Inputs/BASE-INV-4140.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Mobile App"
	And I execute scenario "Mobile Login"

When I "navigate to the transfer screen and perform transfer"
	Then I execute scenario "Mobile Navigate to Inventory Transfer Menu"
	And I execute scenario "Mobile Inventory Transfer Undirected"
    
And I "validate the transfer occurred properly for all lodnums"
	Then I assign 1 to variable "lodnum_cnt"
	If I verify variable "xfer_lodnum_list" is assigned
	And I verify text $xfer_lodnum_list is not equal to ""
		While I assign $lodnum_cnt th item from "," delimited list $xfer_lodnum_list to variable "xfer_lodnum"
			Then I assign $xfer_lodnum to variable "xfer_lodnum"
			And I execute scenario "Inventory Transfer Validate Location"
			Then I increase variable "lodnum_cnt" by 1
		EndWhile
		And I unassign variables "lodnum_cnt,xfer_lodnum"
	EndIf

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"