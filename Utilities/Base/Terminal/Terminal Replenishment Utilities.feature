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
# Utility: Terminal Replenishment Utilities.feature
# 
# Functional Area: Replenishment
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: MOCA, Terminal
#
# Description: Utilities that are common across all replenishment operations - including getting and validating data.
#
# Public Scenarios:
#	- Terminal Replenishment - performs Case or Pallet Replenishment
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Replenishment Utilities

@wip @public
Scenario: Terminal Replenishment
#############################################################
# Description: This scenario performs top-level work for a
# case or pallet replenishment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		One of the optional parameters
#	Optional:
#		palloc - pallet location where replenishment should occur
#		casloc - case location where replenishment should occur
# Outputs:
# 	None           
#############################################################

Given I "wait some time for Replenishment Work to release" which can take between $wait_long seconds and $max_response seconds 

And I "obtain the Work Reference"
	If I verify variable "palloc" is assigned
		Then I assign $palloc to variable "t_storage_location"
		And I assign "pallet" to variable "replen_type"
	ElsIf I verify variable "casloc" is assigned
		Then I assign $casloc to variable "t_storage_location"
		And I assign "case" to variable "replen_type"
	Else I fail step with error message "ERROR: Neither palloc or casloc location variables were defined"
	Endif

	When I execute scenario "Get Replenishment Pick Work Reference"
	And I execute scenario "Get Directed Replenishment Work by Work Reference and Operation"
	If I verify MOCA status is 0
	Else I assign variable "error_message" by combining "ERROR: We do not have any Replenishment Picks. Exiting..."
		Then I fail step with error message $error_message
	EndIf 
	
And I "confirm Directed Work exists"
	If I see "Pickup Product At" in terminal within $wait_long seconds
		Then I echo "I'm good to proceed as there are directed works"
   	Else I assign variable "error_message" by combining "ERROR: There are no directed replenishment picks. Exiting..."
		Then I fail step with error message $error_message
	EndIf

Then I "perform all of the Replenishment picks"
	Given I assign 0 to variable "DONE"
	While I see "Pickup Product At" in terminal within $wait_med seconds 
	And I verify number $DONE is equal to 0
		Given I "verify screen has loaded for information to be copied off of it"
			Then I verify screen is done loading in terminal within $max_response seconds

		Given I "copy the Source Location"
			If I verify text $term_type is equal to "handheld"
				Then I copy terminal line 4 columns 1 through 20 to variable "srcloc"
			Else I verify text $term_type is equal to "vehicle"
				Then I copy terminal line 3 columns 20 through 40 to variable "srcloc"
			EndIf 
		
		When I "perform each Replenishment pick"
			Then I execute scenario "Check Pick Directed Work Assignment by Operation and Location"
			If I verify MOCA status is 0
				Given I assign row 0 column "reqnum" to variable "reqnum"
				And I assign row 0 column "wh_id" to variable "wh_id"
				When I execute scenario "Terminal Process Replenishment Pick"
				Then I execute scenario "Get Directed Replenishment Work by Work Reference and Operation"
				And I execute scenario "Terminal Deposit"
			Else I echo "The Current Work is not a Pallet Replen Pick or the Work is not assigned to the Current User. Exiting..."
				Then I assign "1" to variable "DONE"
			EndIf
	EndWhile

#############################################################
# Private Scenarios:
#	Terminal Process Replenishment Pick - Directed work pickup and process.
#	Get Replenishment Pick Work Reference - Checks whether a replenishment was released.
#	Get Directed Replenishment Work by Work Reference and Operation - Checks whether Pallet Replenishment Picks exist for specified order.
#############################################################

@wip @private
Scenario: Terminal Process Replenishment Pick
#############################################################
# Description: From directed work, once you are on the 
# Replenish Pick Screen, process the screen inputs.
# These inputs are slightly different for case versus pallet
# replenishments.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		replen_type - either case or pallet
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "press Enter to Acknowledge"
	When I press keys "ENTER" in terminal
	Once I see "Replenish Pick" in terminal
	Then I "verify screen has loaded for information to be copied off of it"
		And I verify screen is done loading in terminal within $max_response seconds
 
And I "copy the replenishment pick source location from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 2 columns 5 through 20 to variable "srcloc"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 2 columns 5 through 29 to variable "srcloc"
	EndIf
	And I execute groovy "srcloc = srcloc.trim()"
 
And I "copy the part number from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 5 columns 5 through 20 to variable "prtnum"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 3 columns 26 through 40 to variable "prtnum"
	EndIf
	And I execute groovy "prtnum = prtnum.trim()"
 
And I "copy the client ID from the terminal screen"
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 11 columns 5 through 20 to variable "client_id"
	Else I verify text $term_type is equal to "vehicle"
		Then I copy terminal line 7 columns 5 through 20 to variable "client_id"
	EndIf
	And I execute groovy "client_id = client_id.trim()"
 
And I "get a case or pallet number from the pick location that will be the case we will pick"
	Then I execute scenario "Get Case Number from Source Location for Picking"
	If I verify MOCA status is 0
		Then I assign row 0 column "lodnum" to variable "srclod"
	Else I assign variable "error_message" by combining "ERROR: The inventory in this location is not equal to what we expect to pick"
		Then I fail step with error message $error_message
	EndIf 
 
When I "complete Replenishment Screen for either case or pallet replenishment"
	Then I enter $srclod in terminal
	If I verify text $replen_type is equal to "case"
		Then I press keys "ENTER" in terminal
	EndIf

@wip @private
Scenario: Get Replenishment Pick Work Reference
#############################################################
# Description: This scenario runs MSQL to determine if
# the replenishment has been processed and is available in the
# pckwrk_view table.
# MSQL Files:
#	get_emergency_replen_work_reference_by_part_location_operation.msql
# Inputs:
#	Required:
#		t_storage_location - Storage Location containing the case or pallet inventory
#		prtnum - Part Number
#		oprcod - Operation Code
#	Optional:
#		None
# Outputs:
# 	wrkref - Work Reference Id           
#############################################################
	
When I "search MOCA to see whether pckwrk_view table has a replenishment entry"
	And I assign "get_emergency_replen_work_reference_by_part_location_operation.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "wrkref" to variable "wrkref"
	Else I assign variable "error_message" by combining  "ERROR: Could not find replenishment from the source location" $t_storage_location
		Then I fail step with error message $error_message
	EndIf
	
@wip @private
Scenario: Get Directed Replenishment Work by Work Reference and Operation
#############################################################
# Description: Returns MOCA status of 0 when there are 
# Pallet Replenishment Picks found in MOCA for this order.
# MSQL Files:
#	get_replen_directed_work_by_work_reference_and_operation.msql
# Inputs:
# 	Required:
# 		oprcod - Operation Code.
#		wrkref - Work Reference number.
# 	Optional:
#		None
# Outputs:
#	None
#############################################################

When I "search for any Pallet Replenishment Picks in MOCA"
	And I assign "get_replen_directed_work_by_work_reference_and_operation.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"
	
@wip @private
Scenario: Get Case Number from Source Location for Picking
############################################################
# Description: Returns MOCA status of 0 when there are 
# Cases in the specified location containing the 
# Part Number specified.
# MSQL Files:
#	get_case_number_from_source_location_for_picking.msql
# Inputs:
# 	Required:
#		srcloc - Source Location
#		prtnum - Part Number
# 	Optional:
#       None
# Outputs:
#	None (result set is available after scenario completes)
#############################################################

When I "search MOCA for a case number from this location with the specified prtnum."
	And I assign "get_case_number_from_source_location_for_picking.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"