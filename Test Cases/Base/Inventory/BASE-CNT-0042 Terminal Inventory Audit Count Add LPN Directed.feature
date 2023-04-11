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
# Test Case: BASE-CNT-0042 Terminal Inventory Audit Count Add LPN Directed.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description: This test case performs a audit count adding a new LPN not originally in the location in the Terminal
#
# Input Source: Test Case Inputs/BASE-CNT-0042.csv
# Required Inputs:
# 	stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 	lodnum - Load number being newly created. Can be a fabricated number. Used in Terminal and datasets processing.
#	new_lodnum - Load number of the newly added inventory created during audit count by user
# 	prtnum - Needs to be a valid part number that is assigned in your system but not in the location
#	new_prtnum - prtnum being used as part of new_lodnum in stoloc for newly added inventory created during audit count by user
# 	untqty - Inventory quantity being added
# 	reacod - System reason code for adjustment. Must exist as a valid reason code in the system
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
#	cnt_sysdate - Used as the schedule date during dataset count batch creation
#	cntbat - Used to name the count batch
#	cnttyp - type of count (A)
# Optional Inputs:
# None
#
# Assumptions:
# - This test case loads inventory into a location and performs an audit count in the Terminal
# - Note that user permissions must all be set up to run successfully
# - This test does create inventory to be counted in the dataset, but does require serialized parts in the WMS
# 
# Notes:
# - None
#
############################################################ 
Feature: BASE-CNT-0042 Terminal Inventory Audit Count Add LPN Directed
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Count Imports"

	Then I assign "BASE-CNT-0042" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Given I "load the Audit Count Dataset to create the Directed Audit Count against the location"
	Then I assign "Audit_Count_Creation" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

Then I "check for serialization and add required serial numbers if needed"
	And I assign $stoloc to variable "srcloc"
    Then I execute scenario "Get Item Serialization Type"
	If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
		And I execute scenario "Add Serial Numbers for Cradle to Grave"
	EndIf

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the datasets"
	Given I assign "Audit_Count_Creation" to variable "cleanup_directory"
	Then I execute scenario "Perform MOCA Cleanup Script"

	Then I assign "Inv_Terminal_Adjustment" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-CNT-0042
Scenario Outline: BASE-CNT-0042 Terminal Inventory Audit Count Add LPN Directed
CSV Examples: Test Case Inputs/BASE-CNT-0042.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Terminal"
	And I execute scenario "Terminal Login"

And I "assign work and naviate to menu"
	Then I execute scenario "Assign Work to User by Count Batch and Count Type"
	And I execute scenario "Terminal Navigate to Directed Work Menu"
	And I execute scenario "Terminal Inventory Count Process Directed Work Screen"

When I "perform and verify the audit count"
	Then I execute scenario "Terminal Inventory Audit Count Enter Location Directed Work"
	And I execute scenario "Terminal Inventory Audit Count Add LPN"
	And I execute scenario "Terminal Inventory Audit Count Complete Count"
	And I execute scenario "Terminal Exit Directed Work Mode"
	And I execute scenario "Inventory Audit Count Check Inventory"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"