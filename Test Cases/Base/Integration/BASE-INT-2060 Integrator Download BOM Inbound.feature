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
# Test Case: BASE-INT-2060 Integrator Download BOM Inbound.feature
#
# Functional Area: Integration
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, Integration
#
# Description: 
# This test case runs the BOM Inbound Transaction for Add, Change, and Delete
#
# Input Source: Test Case Inputs/BASE-INT-2060.csv
# Required Inputs:
#	bomnum - Bill of Material Number used for validation and After Scenario purge
#	system - Integrator host system for transaction.  Must be valid enabled system in WMS Integrator
#	tran_name - Name of transaction.  Must be valid enabled transaction in WMS Integrator
#	pre_validation - Cycle scenario to run to perform pre_validations logic
#	post_validation - Cycle scenario to run to perform post validation logic 
#	detail_file_name - CSV file containing the transactions to process
# Optional Inputs:  
#	None
#
# Input Detail Source: Test Case Inputs/Details/BASE-INT-2060-01.csv
# Detail Required Inputs:
# 	trntyp - Transaction Type (A-Add, C-Change, D-Delete)
#	transaction_file_name - Name of the transaction file
#	field_to_validate_change - Database field used to validate change transaction succeeded. Required for change transactions
#	table_to_validate_change - Database table used to validate change transaction succeeded. Required for change transactions
# Detail Optional Inputs:
# 	wms_inbound_directory - Path to inbound directory on WMS system. wms_inbound_directory environment variable used by default. 
#	destination_file_name - Name to use when copying file to server. transaction_file_name is used by default.
#
# Assumptions:
# - Assumption is the event BOM_INB_IFD is enabled and mapped to correct system
# - The client_id and wh_id configured in Environment.feature match the data in the inbound IFD 
#   and will be used for validation, if they do not match, then define client_id and wh_id in local data override
#
# Notes:
# - Create an XML file representative of what the host would send for BOM Download
# - Provide bomnum for the validation step
# - Provide a trntyp variable value indicating "A" for Add record, "C" for Change record, or "D" for Delete record
# - Provide a clause variable value for validating changed BOM data after processing the Change file
#
############################################################
Feature: BASE-INT-2060 Integrator Download BOM Inbound

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Integration Imports"

	Then I assign "BASE-INT-2060" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "cleanup the dataset, since there was no initial dataset to load"
	Then I assign "Int_BOM_Download" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
    
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Int_BOM_Download" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INT-2060
Scenario Outline: BASE-INT-2060 Integrator Download BOM Inbound
CSV Examples: Test Case Inputs/BASE-INT-2060.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "process each row in the transaction file"
	Given I assign variable "detail_file" by combining "Test Case Inputs/Details/" $detail_file_name
	While I assign values in next row from $detail_file to variables

		Given I "process the correct tranaction type logic"
			If I verify text $trntyp is equal to "A" ignoring case
				Then I execute scenario "Process Integration Add Transaction"
			Elsif I verify text $trntyp is equal to "C" ignoring case
				Then I execute scenario "Process Integration Change Transaction"
			Elsif I verify text $trntyp is equal to "D" ignoring case
				Then I execute scenario "Process Integration Delete Transaction"   
			EndIf
	EndWhile

And I "execute post-test scenario actions (including post-validations)"
	Then I execute scenario "End Post-Test Activities"