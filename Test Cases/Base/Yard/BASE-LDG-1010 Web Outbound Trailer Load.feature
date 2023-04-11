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
# Test Case: BASE-LDG-1010 Web Outbound Trailer Load.feature
#
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This test case will handle loading a trailer in the Web
#
# Input Source: Test Case Inputs/BASE-LDG-1010.csv
# Required Inputs:
#   ordnum - This will be used as the ordnum when creating the order to be loaded onto the trailer
#   ship_id - This will be used as the ship_id when creating the shipment to be loaded onto the trailer
#   adr_id - This will be used as the adr_id when creating the order to be loaded onto the trailer
#   cstnum - This will be used as the cstnum when creating the order to be loaded onto the trailer
#   carcod - This will be used as the carrier for the shipment
#   srvlvl - This will be used as the service level for the shipment
#   ordtyp - This will be used as the order type for the order
#   prtnum - This will be used as the prtnum for the order
#   untqty - This will be used as the order qty for the order
#   invsts_prg - This will be used as the inventory status progression on the order line
#   wave_num - This will be used as the wave number for the shipment
#   move_id - This will be used as the move ID assigned to the trailer
#   trlr_id - This will be used as the trailer ID for the trailer
#   dock - This will be used as the dock location for the trailer
#   pck_dstloc - This will be used as the location the order is picked to
#   operation - LOAD will load the trailer, LC will load and close the trailer, LCD will load, close, and dispatch the trailer
# Optional Inputs:
#	None
#
# Assumptions:
# - Sufficient pickable and shippable inventory for the order
# - Dock door for the dataset is an open and usable dock door
# - The trailer has a single stop assigned and the stop is fully picked and staged
# - Load trailer function will utilize move immediately rather than work queue for loading
#
# Notes:
# - This Test Case can use an existing trailer by setting create_data to FALSE and supplying a valid move_id
# 
############################################################ 
Feature: BASE-LDG-1010 Web Outbound Trailer Load

Background: 
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Trailer Move Imports"
	Then I execute scenario "Web Outbound Trailer Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-LDG-1010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Web_Outbound_Trailer_Common" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Outbound_Trailer_Common" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-LDG-1010
Scenario Outline: BASE-LDG-1010 Web Outbound Trailer Load
CSV Examples: Test Case Inputs/BASE-LDG-1010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I execute scenario "Web Login"
And I execute scenario "Web Assign Close and Dispatch Variables"
And I execute scenario "Web Open Shipping Loads Screen"
And I execute scenario "Web Search for Load"
And I execute scenario "Web Shipping Loads Process Trailer Safety Check"
And I execute scenario "Web Select Load Row"
And I execute scenario "Web Set Load Stop"
And I execute scenario "Web Verify Dock Door Ready"
And I execute scenario "Web Select Move Immediately, Close, and Dispatch"
And I execute scenario "Web Click Save"
And I execute scenario "Web Verify Paperwork"
And I execute scenario "Web Verify Confirmation"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"