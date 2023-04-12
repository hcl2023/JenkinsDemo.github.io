###########################################################
# Copyright 2021, Cycle Labs, Inc.
# All rights reserved.  Proprietary and confidential.
#
# This file is subject to the license terms found at
# https://cyclelabs.io/terms/
#
# The methods and techniques described herein are considered
# confidential and/or trade secrets.
# No part of this file may be copied, modified, propagated,
# or distributed except as authorized by the license.
############################################################
# Test Case: BASE-API-8020 API Purchase Order.feature
#
# Functional Area: Inventory
# Author: Cycle Labs
# Blue Yonder WMS Version: Consult Release Notes
# Test Case Type: Pre-Validation
# Blue Yonder Interfaces Interacted With: API
#
# Description:
# This Test Case sends a Purchase Order
#
# Input Source: Test Case Inputs/BASE-API-8020.csv
# Required Inputs:
#
# Assumptions:
# - None
#
# Notes:
#
############################################################
Feature: BASE-API-8010 API Alternate Item Lookups

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "API Imports"

	Then I assign "BASE-API-8020" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "mention there is no dataset to load"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "mention there is no dataset to cleanup"

@BASE-API-8020
Scenario Outline: BASE-API-8020 API Purchase Order
CSV Examples: Test Case Inputs/BASE-API-8020.csv

Given I "execute pre-test scenario actions (including pre-validations)   "
	And I execute scenario "Begin Pre-Test Activities"
	
# Prerequisites: API Environment Variables are set correctly and Verify API in Verify Environment Utility
And I "construct the transaction file and endpoint"
	When I replace variables in XML file $xml_file and store as variable "request_xml"
	And I assign variable "api_endpoint" by combining "/ws/integration/api/UC_PURCHASE_ORDER"

When I "send the XML Purchase Order file to the API endpoint"
	When I execute scenario "API POST XML"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"