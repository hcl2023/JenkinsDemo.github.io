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
# Test Case: BASE-WAV-1030 Web Outbound Unallocate Wave.feature
# 
# Functional Area: Allocation
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This Test Case loads an order, inventory and allocates a wave via MSQL. It then unallocates the wave in the Web.
# 
# Input Source: Test Case Inputs/BASE-WAV-1030.csv
# Required Inputs:
# 	ordnum - This will be used as the ordnum when creating the order to be loaded onto the trailer
#	ship_id - This will be used as the ship_id when creating the shipment to be loaded onto the trailer
#	adr_id - This will be used as the adr_id when creating the order to be loaded onto the trailer
# 	cstnum - This will be used as the cstnum when creating the order to be loaded onto the trailer
# 	carcod - This will be used as the carrier for the shipment
# 	srvlvl - This will be used as the service level for the shipment
# 	ordtyp - This will be used as the order type for the order
# 	prtnum - This will be used as the prtnum for the order
# 	untqty - This will be used as the order qty for the order
# 	invsts_prg - This will be used as the inventory status progression on the order line
# 	wave_num - This will be used as the wave number for the shipment
# 	move_id - This will be used as the move ID assigned to the trailer
# 	dock - This will be used as the dock location for the trailer
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
Feature: BASE-WAV-1030 Web Outbound Unallocate Wave
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Wave Imports"
	Then I execute scenario "Web Environment Setup"

	And I assign "BASE-WAV-1030" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Allocate_Carton_Picks" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Allocate_Carton_Picks" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-WAV-1030
Scenario Outline: BASE-WAV-1030 Web Outbound Unallocate Wave
CSV Examples: Test Case Inputs/BASE-WAV-1030.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web"
	And I execute scenario "Web Login"

And I "navigate to the Outbound Planner Waves and Picks Screen"
	Then I execute scenario "Web Navigate to Outbound Planner Waves and Picks"
    
And I "navigate to the Picking Waves and Picks screen"
	Then I execute scenario "Web Navigate to Picking Waves and Picks"

When I "perform an unallocate Wave operation"
	Then I execute scenario "Web Unallocate Wave"
    
And I "validate Wave is unallocated"
	Then I execute scenario "Validate Wave Unallocated"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"