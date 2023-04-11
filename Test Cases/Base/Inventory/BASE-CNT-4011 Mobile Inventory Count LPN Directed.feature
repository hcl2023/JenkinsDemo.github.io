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
# Test Case: BASE-CNT-4011 Mobile Inventory Count LPN Directed.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This test case performs an LPN count on Mobile App using Directed work.
#
# Input Source: Test Case Inputs/BASE-CNT-4011.csv
# Required Inputs:
#	cntbat - Count Batch we are working on. Must be a valid count batch with released counts
#	cnttyp - Count Type. For this script, it has to be a count type that has the 'Detail Count' setting to On
#	stoloc - Where the count will take place. Must be a valid location in the system that has a count 
#			 in the count batch cntbat. Script will get next eligible location if not defined
# 	committed_inventory_in_count_loc - count if committed inventory in location? Y or N
# Optional Inputs:
#	lodnum - The LPN to count in a location. Must be a valid LPN in the location we want to count 
#			 (or another one to create a mismatch). Script will get next eligible LPNs in location if not defined

# Assumptions: 
# - Setup LPN counting correctly: The WMS lets you setup a combination of count types and count zones that result 
#	in errors while executing the LPN counts. When a location in a zone that allows LPN counting, but the count type itself
#	does not allow for LPN counting (eg. ABC Cycle Count), the Mobile App still goes into LPN counting screens but errors at
#	some point, complaining that an operation code is needed. When setting up the test data, both the count type and 
#	count zone should be eligible for LPN counting. Detail: the problem is really because of an empty cnttyp.lpncnt_oprcod.
# - For Directed work, the user and Mobile App need to be setup to do cycle count work. And there should be no
#	other directed work in the system that the user and device are eligible for. Only count work should show
#	up on the Mobile App.
# - Locations, parts, clients, reason codes are set up for counting
# - The cnttyp specified in is set up for LPN counting
# 
# Notes:
# - Test Case Inputs (CSV) - Examples:
# 	Example Row: specifying stoloc and lodnum
#	Example Row: specifying stoloc but not lodnum
#
############################################################ 
Feature: BASE-CNT-4011 Mobile Inventory Count LPN Directed
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Count Imports"

	Then I assign "BASE-CNT-4011" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Inv_Count_LPN" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Inv_Count_LPN" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-CNT-4011
Scenario Outline: BASE-CNT-4011 Mobile Inventory Count LPN Directed
CSV Examples: Test Case Inputs/BASE-CNT-4011.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Mobile App"
	Then I execute scenario "Mobile Login"

And I "assign work to the user and navigate to directed work screen"
	Then I execute scenario "Assign Work to User by Count Batch and Count Type"
    And I execute scenario "Mobile Navigate to Directed Work Menu"

When I "prcocess the LPN Count"
	Then I execute scenario "Mobile Inventory Count Process Directed Work Screen"
    And I execute scenario "Mobile Inventory Perform LPN Count"
	And I execute scenario "Mobile Exit Directed Work Mode"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"