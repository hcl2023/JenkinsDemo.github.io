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
# Test Case: BASE-SHP-1080 Web Outbound Remove Load from Trailer.feature
#
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This test case will Remove Load from Trailer in the Web
#
# Input Source: Test Case Inputs/BASE-SHP-1080.csv
# Required Inputs:
# 	ordnum - This will be used as the ordnum when creating the order 
#	ship_id - This will be used as the ship_id when creating the shipment
#	adr_id - This will be used as the adr_id when creating the order
# 	cstnum - This will be used as the cstnum when creating the order
# 	carcod - This will be used as the carrier for the shipment
# 	srvlvl - This will be used as the service level for the shipment
# 	ordtyp - This will be used as the order type for the order
# 	prtnum - This will be used as the prtnum for the order
# 	untqty - This will be used as the order qty for the order
# 	invsts_prg - This will be used as the inventory status progression on the order line
#	wave_num - Wave Number
#	move_id - Load ID
#	trlr_id - Unique identifier for the trailer in the system.
#	dock_door - Physical location in the yard where the trailer is located.
# Optional Inputs:
# 	None
# 
# Assumptions:
# None
#
# Notes:
# None
# 
############################################################ 
Feature: BASE-SHP-1080 Web Outbound Remove Load from Trailer
 
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

	Then I assign "BASE-SHP-1080" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Web_Outbound_Shipment" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Outbound_Shipment" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-SHP-1080
Scenario Outline: BASE-SHP-1080 Web Outbound Remove Load from Trailer
CSV Examples: Test Case Inputs/BASE-SHP-1080.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web and navigate to Door Activity Screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Door Activity Screen"
    
When I "remove Load from Trailer"
	Then I execute scenario "Web Outbound Remove Load from Trailer"

Then I "verify Load Removed from Transport Equipment"
	Then I execute scenario "Validate Load Removed from Transport Equipment"

And I "execute post-test scenario actions (including post-validations)"
	Then I execute scenario "End Post-Test Activities"