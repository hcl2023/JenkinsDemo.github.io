###########################################################
# Copyright 2020, Tryon Solutions, Inc.
# All rights reserved.  Proprietary and confidential.
#
# This file is subject to the license terms found at 
# https://www.cycleautomation.com/enduserlicenseagreement/
#
# The methods and techniques described herein are considered
# confidential and/or trade secrets. 
# No part of this file may be copied, modified, propagated,
# or distributed except as authorized by the license.
############################################################ 
# Utility: Terminal Picking Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: MOCA, Terminal
#
# Description: Utilities that are common across all picking operations - including getting and validating data.
#
# Public Scenarios:
#	 - Check Pick Directed Work Assignment by Operation and Location - Checks whether there are remaining picks for the assigned user at the specified Location.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Picking Utilities

@wip @public
Scenario: Check Pick Directed Work Assignment by Operation and Location
############################################################
# Description: Returns MOCA status of 0 when there are 
# Picks assigned to the active user corresponding to the 
# Operation Code and Location specified.
# MSQL Files:
#	check_pick_directed_work_by_operation_and_location_assigned_to_user.msql
# Inputs:
# 	Required:
#		oprcod - Operation Code
#		srcloc - Source Location
#		devcod - Device Code (Terminal Id)
#		username - Username logged into this device
# 	Optional:
#       None
# Outputs:
#	reqnum  Work Request Id
#############################################################

When I "search MOCA for picks assigned to this user at this location"
	Given I assign "check_pick_directed_work_by_operation_and_location_assigned_to_user.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"