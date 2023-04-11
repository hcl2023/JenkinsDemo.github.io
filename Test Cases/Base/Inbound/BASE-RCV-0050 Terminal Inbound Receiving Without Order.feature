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
# Test Case: BASE-RCV-0050 Terminal Inbound Receiving Without Order.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# Performs Terminal Receiving WithOut Order 
#
# Input Source: Test Case Inputs/BASE-RCV-0050.csv
# Required Inputs:
#   rec_quantity - the quantity to be receive 
#	lodnum - the load to associate the received goods with
#	prtnum - the part to receive
#	reason - reason for receiveing
#	status - a valid inventory status
#	putaway_method - 1 is Directed, 2 is Sorted, 3 is Undirected.
#	deposit_loc - If Storage location is provided: storage_loc
#				- Else if Receive Stage location is provided: rec_stg_loc
#
# Optional Inputs:
#	None
#
# Assumptions:
#  None
#
# Notes:
# None
#
############################################################
Feature: BASE-RCV-0050 Terminal Inbound Receiving Without Order
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"
	
	Then I assign "BASE-RCV-0050" to variable "test_case"
	When I execute scenario "Test Data Triggers"

	Given I execute scenario "Terminal Receiving Imports"

And I "load the dataset"	
	Then I assign "Rcv_wo_Order" to variable "dataset_directory"    
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Rcv_wo_Order" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-0050
Scenario Outline: BASE-RCV-0050 Terminal Inbound Receiving Without Order
CSV Examples: Test Case Inputs/BASE-RCV-0050.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "open the Terminal Receiving Menu"
	When I execute scenario "Terminal Login"
	And I execute scenario "Terminal Receiving Without Order Menu"

When I "Receive Without Order"
	And I execute scenario "Terminal Receiving Without Order"
    
Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"
 