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
# Test Case: BASE-RCV-4070 Mobile Inbound Unload All.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
# 
# Description:
# This Test Case will exercise Receiving Unload Shipment functionality in the Mobile App.
#
# Input Source: Test Case Inputs/BASE-RCV-4070.csv
# Required Inputs:
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
#	yard_loc - This is where your Trailer needs to be checked in. Must be a valid and open dock door.
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	prtnum - This needs to be a valid part number that is assigned in your system. Will use the default client_id.
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The number expected
# 	supnum - A valid supplier
# Optional Inputs: 
#	trac_ref - tracking reference for dispatch information
#	driver_lic - drivers license for dispatch information
#	driver_nam - drivers name for dispatch information
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: BASE-RCV-4070 Mobile Inbound Unload All

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Receiving Imports"

	Then I assign "BASE-RCV-4070" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Receiving" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Receiving" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-4070
Scenario Outline: BASE-RCV-4070 Mobile Inbound Unload All
CSV Examples: Test Case Inputs/BASE-RCV-4070.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Mobile App and navigate to the Unload Ship Screen"
	Then I execute scenario "Mobile Login"
	And I execute scenario "Mobile Receiving Unload Shipment Menu"
    
When I "unload the shipment and dispatch the equipment"
	Then I execute scenario "Mobile Unload Shipment"
	And I execute scenario "Mobile Process Workflow"
	And I execute scenario "Mobile Confirm Dispatch Equipment"
	And I execute scenario "Mobile Dispatch Equipment"
	And I execute scenario "Mobile Confirm Dispatch Equipment"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"