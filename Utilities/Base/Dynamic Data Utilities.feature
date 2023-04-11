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
# Utility: Dynamic Data Utilities.feature
# 
# Functional Area: Data Setup
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: None
#
# Description:
# This utility contains scenarios for the dynamic data functionality
#
# Public Scenarios:  
# 	- Get Value from CSV for Dynamic Data - Get a value from a CSV
#	- Get Value from Cycle Variable - Return the value currently stored in a cycle variable (for reassignment)
#	- Use Value from Where Clause - Return the literal value from the DD's where clause
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Dynamic Data Utilities

@wip @public
Scenario: Get Value from CSV for Dynamic Data
#############################################################
# Description: 
# This function will pull the next value from a single column
# CSV file.  The row taken is removed. 
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		where_clause - path and name of CSV file
# 	Optional:
#		None		
# Outputs:
# 	next_csv_value - value read from the csv
#############################################################

Given I "read the next line from the file and assign it to value"
	Given I assign variable "csv_file" by combining $where_clause
    Then I verify file $csv_file exists
    Then I remove next value from $csv_file and assign to variable "next_csv_value"

@wip @public
Scenario: Get Value from Cycle Variable
#############################################################
# Description: 
# This function will return the value currently stored in a cycle variable.  This will
# get used when earlier dynamic data calls returned the needed value but in a field
# name that is different than the current field being populated.   For instance, an earlier
# call might return stoloc, but the test input field needed to be populated is dstloc.  In
# this example the dynamic data setup would specify stoloc in the where_clause.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		where_clause - Variable to be assigned.  Passed from the dynamic data instructions.
#		variable - field being processed by dynamic data processing (automatically populated)
# 	Optional:
#		None		
# Outputs:
# 	value - Field to be assigned to dynamic data
#############################################################

If I assign contents of variable $where_clause to "value"
Else I assign variable "error_message" by combining "Source variable " $where_clause " is not defined to assign to " $variable
	And I fail step with error message $error_message
EndIf

@wip @public
Scenario: Use Value from Where Clause
#############################################################
# Description: 
# This function will return the value currently stored in a cycle variable.   
# matching the variable being processed.  If the rare case in which a an 
# input value starts with ?, this function and be used pass the value
# to the test case.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		where_clause - Value to be assigned.  Passed from the dynamic data instructions. 
# 	Optional:
#		None		
# Outputs:
# 	value - Field to be assigned to dynamic data
#############################################################

Given I assign $where_clause to variable "value"