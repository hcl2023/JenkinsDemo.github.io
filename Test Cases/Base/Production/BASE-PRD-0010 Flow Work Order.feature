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
# Test Case: BASE-PRD-0010 Flow Work Order.feature
# 
# Functional Area: Production
# Author: Tryon Solutions 
# Blue Yonder WMS Version:  Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, Web, MOCA
# 
# Description:
# This test case goes through the whole work order processing cycle for one work order. 
# It starts with creating the work order and ends with closing the work order and removing
# all the work order related data in the end, including the finished goods.
# 
# Input Source: Test Case Inputs/BASE-PRD-0010.csv
# Required Inputs:
#	wko_typ	- Work Order type
#	wkonum - Work Order number
#	wkorev - Work Order revision
#   tlp_prtnum - Top level part number
#   tlp_prt_client_id - Top level part client
#   bomnum - Bill of material number
#	invsts - Inventory Status
#	prdqty - Production Qty
#	prdlin - Production Line
#	rcvqty - Receive Qty
# 	pickMethod - Picking Method
# 	over_consumption - Over Consumption Allowed
#	oprcod - Operation Code
# Optional Inputs:
# None
#
# Assumptions:
# - work order production line, staging location and workstation is setup
# - BOM for top level part exists (could be one or many details)
# - inventory for components exist
# - allocation search paths exist to make allocation work
# - there is room to store the finished goods
# - storage search path exists
# - no dataset load is needed
# 
# Notes:
# - Change the input parameters in this feature to the names setup in your environment
#   E.g. the BOM number should match an existing BOM number.
# - Make sure the 'rcvqty' matches the 'prdqty' if you don't want to create a discrepancy
#   in over- or under-consuming inventory.
# 
############################################################ 
Feature: BASE-PRD-0010 Flow Work Order

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Work Order Imports"
	Then I execute scenario "Web Environment Setup"

	And I assign "BASE-PRD-0010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "cleanup the dataset, since there was no initial dataset to load"
	Then I assign "WKO_Work_Order" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
    
After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "WKO_Work_Order" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-PRD-0010
Scenario Outline: BASE-PRD-0010 Flow Work Order
CSV Examples: Test Case Inputs/BASE-PRD-0010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Given I execute scenario "Web Login"
And I execute scenario "Web Open Work Order Screen"
When I execute scenario "Web Create Work Order"
And I execute scenario "Web Open Work Order Screen"
And I execute scenario "Web Allocate Work Order"

Then I execute scenario "Terminal Login"
And I execute scenario "Assign Work Order Picks to User"
And I execute scenario "Terminal Navigate to Directed Work Menu"
And I execute scenario "Terminal Pick Work Order"

Then I execute scenario "Web Open Work Order Screen"
And I execute scenario "Web Start Work Order"

Then I execute scenario "Terminal Navigate Quickly to Undirected Menu"
And I execute scenario "Terminal Move Inventory to Workstation"
And I execute scenario "Terminal Receive Finished Goods"

And I execute scenario "Web Open Work Order Screen"
And I execute scenario "Web Complete Work Order"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"