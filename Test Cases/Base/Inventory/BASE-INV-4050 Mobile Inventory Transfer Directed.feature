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
# Test Case: BASE-INV-4050 Mobile Inventory Transfer Directed.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This test case performs a full inventory move as Directed work in Mobile
#
# Input Source: Test Case Inputs/BASE-INV-4050.csv
# Required Inputs:
# 	srcloc - Where the adjustment will take place. Must be a valid adjustable location in the system
#	dstloc - Destination Location.  Where we deposit the inventory.
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal and datasets processing.
#			 (Note: When lodnum = 'CYC-LOAD-XFER', Cycle will generate a new LPN when processing the dataset.
#			 otherwise, it will use the input lodnum.)
# 	prtnum - Needs to be a valid part number that is assigned in your system
# 	ftpcod - Footprint code for this part.  Must be a valid footprint code
#	untqty - Quantity for the dataset to add inventory . Must be a number.
# Optional Inputs:
# None
#
# Assumptions: 
# - The Mobile/User used is ineligible for directed work
# 
# Notes:
# None
#
############################################################ 
Feature: BASE-INV-4050 Mobile Inventory Transfer Directed
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Inventory Imports"

	Then I assign "BASE-INV-4050" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "true" to variable "directed"
	And I assign "Inv_Transfer" to variable "dataset_directory"
	Then I execute scenario "Perform MOCA Dataset"
	And I assign row 0 column "lodnum" to variable "xfer_lodnum"
	And I assign row 0 column "reqnum" to variable "xfer_reqnum"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Inv_Terminal_Adjustment" to variable "cleanup_directory"
	And I assign $xfer_lodnum to variable "lodnum"
	And I assign $dstloc to variable "stoloc"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-4050
Scenario Outline: BASE-INV-4050 Mobile Inventory Transfer Directed
CSV Examples: Test Case Inputs/BASE-INV-4050.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the mobile application"
	And I execute scenario "Mobile Login"
    
When I "assign work, navigate to directed work and perform the transfer"
	Then I execute scenario "Assign Work to User by Operation and Lodnum"
	And I execute scenario "Mobile Navigate to Directed Work Menu"
	When I execute scenario "Mobile Inventory Transfer Directed"
	And I execute scenario "Mobile Exit Directed Work Mode"

And I "validate the transfer completed"
	Then I execute scenario "Inventory Transfer Validate Location"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"