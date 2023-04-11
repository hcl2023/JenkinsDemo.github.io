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
# Test Case: BASE-WAV-1040 Web Outbound Plan Wave Remove Stop.feature
# 
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This Test Case loads an order, plans a wave, creates a load and assigns a stop to it via MSQL. It then removes stop from the load in the Web
# 
# Input Source: Test Case Inputs/BASE-WAV-1040.csv
# Required Inputs:
# 	ordnum - This will be used as the ordnum when creating the order to be loaded onto the trailer
#	ship_id - This will be used as the ship_id when creating the shipment to be loaded onto the trailer
#	adr_id - This will be used as the adr_id when creating the order to be loaded onto the trailer
#	client_id - This will be used as the client_id for the outbound order
# 	cstnum - This will be used as the cstnum when creating the order to be loaded onto the trailer
# 	carcod - This will be used as the carrier for the shipment
# 	srvlvl - This will be used as the service level for the shipment
# 	ordtyp - This will be used as the order type for the order
# 	prtnum - This will be used as the prtnum for the order
# 	untqty - This will be used as the order qty for the order
# 	invsts_prg - This will be used as the inventory status progression on the order line
# 	wave_num - This will be used as the wave number for the shipment
# 	move_id - This will be used as the move ID assigned to the trailer
# Optional Inputs:
#	None
#
# Assumptions:
# - User has permissions for functions
#
# Notes:
# None
#
############################################################ 
Feature: BASE-WAV-1040 Web Outbound Plan Wave Remove Stop
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Outbound Planner Imports"
    Then I execute scenario "Web Outbound Trailer Imports"
	And I execute scenario "Web Environment Setup"

	And I assign "BASE-WAV-1040" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Web_Outbound_WavePlan" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Outbound_WavePlan" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-WAV-1040
Scenario Outline: BASE-WAV-1040 Web Outbound Plan Wave Remove Stop
CSV Examples: Test Case Inputs/BASE-WAV-1040.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web"
	And I execute scenario "Web Login"

And I "log into the Web and navigate to Outbound Screen"
	Then I execute scenario "Web Navigate to Outbound Planner Outbound Screen"
    
And I "navigate to the load screen"
	Then I execute scenario "Web Validate Load"

And I "Delete the Stop from Load"
	Then I execute scenario "Web Delete Stop"
    
And I "validate Stop is Deleted"
	Then I execute scenario "Validate Stop Deleted"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"