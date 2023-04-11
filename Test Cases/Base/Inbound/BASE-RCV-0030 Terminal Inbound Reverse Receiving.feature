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
# Test Case: BASE-RCV-0030 Terminal Inbound Reverse Receiving.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# Performs Terminal Reverse Receiving
#
# Input Source: Test Case Inputs/BASE-RCV-0030.csv
# Required Inputs:
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
# 	invnum - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
# 	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in. Must be a valid and open dock door.
# 	invtyp - This need to be a valid Invoice Type, that is assigned in your system
# 	prtnum - This needs to be a valid part number that is assigned in your system. Will use client_id in Environment.feature
# 	rcvsts - Receiving status created on the Invoice Line being loaded
# 	expqty - This can be a fabrication, but assumes simple, standard LPN receiving
# 	supnum - This needs to be a valid supplier, assigned in your system
#	rec_loc - the receiving staging lane used for staging putaway, must be valid
#	uomcod - valid Unit of Measure
#	ftpcod - valid footprint code
#	untqty - the amount received
#	lodnum - the load number
#	invsts - a valid inventory status
#	carcod - Carrier code of the trailer
# Optional Inputs:
#	None
#
# Assumptions:
# - Load is received and trailer is not dispatched/closed
#
# Notes:
# None
#
############################################################
Feature: BASE-RCV-0030 Terminal Inbound Reverse Receiving
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"
	
	Then I assign "BASE-RCV-0030" to variable "test_case"
	When I execute scenario "Test Data Triggers"

	Given I execute scenario "Terminal Receiving Imports"

And I "load the dataset"	
	Then I assign "Putaway" to variable "dataset_directory"    
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Putaway" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-0030
Scenario Outline: BASE-RCV-0030 Terminal Inbound Reverse Receiving
CSV Examples: Test Case Inputs/BASE-RCV-0030.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "open the Terminal Receiving Menu"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal LPN Reverse Receipt Menu"

When I "reverse the Receipt"
	And I execute scenario "Terminal Reverse Receipt"
    
Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"