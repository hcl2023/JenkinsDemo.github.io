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
# Utility: Terminal Trailer Move Utilities.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# This Utility contains scenarios to perform actions specific to trailer moves in the terminal
#
# Public Scenarios:
# 	- Terminal Trailer Moving - top-level move scenario in terminal
# 	- Terminal Verify and Escalate Directed Work - verifies if it is directed work and escalates if appropriate
#	- Create Trailer Move Work - creates trailer move work
#	- Trailer Moving Post Move Checks - used by terminal and web to verify trailer is in expected final location
#	- Trailer Move Post Work Checks - used by terminal and web to validate trailer work exists or is in expected final location
# 	- Trailer Validate Move Data - used by terminal and web to verify trailer is created and checked in
#
# Assumptions:
# None
#
# Notes:
# - The Scenarios without Terminal in their name are used in both
#   Web and Terminal test cases
#
############################################################
Feature: Terminal Trailer Move Utilities

@wip @public
Scenario: Terminal Trailer Moving
#############################################################
# Description: This scenario moves a trailer using the Terminal
# MSQL Files:
#	None
# Inputs:
#     Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       move_to_dock_loc - Location trailer will be moved to
#       check_in_dock_loc - Location trailer will be checked in to
#		work_queue_or_immediate - Variable that indicates when the move is performed
#	Optional:
#		None
# Outputs:
#      None                        
#############################################################

If I verify variable "work_queue_or_immediate" is assigned
And I verify text $work_queue_or_immediate is equal to "work_queue" 
	Then I "Have to go to the yard work screen to get my trailer move"
		Once I see "Yard Menu" in terminal
		Then I type option for "Yard Menu" menu in terminal within $wait_short seconds
		Once I see "Yard Menu" in terminal
		
		Once I see "Select Yard Work" in terminal
		When I type option for "Select Yard Work" menu in terminal
		Once I see "Work Selection" in terminal  
		Once I see $move_to_dock_loc in terminal 
		Once I see $check_in_dock_loc in terminal 
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 2 column 1 in terminal 
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 1 in terminal 
		EndIf 
		Then I press keys "ENTER" in terminal
		
Else I "Have to go to the Pickup Equipment Screen Manually (immediate case)"
	Once I see "Shipment Menu" in terminal
	Then I type option for "Shipment Menu" menu in terminal within $wait_short seconds
	Once I see "Shipment Menu" in terminal
	
	Once I see "Pickup Equip" in terminal
	Then I type option for "Pickup Equip" menu in terminal within $wait_short seconds
	Once I see "Equip Pickup" in terminal
	Once I see "Eq Num:" in terminal
	Once I see "Car Cod:" in terminal
	Once I see "Src Loc:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 2 column 10 in terminal 
	EndIf 
	Then I enter $trlr_num in terminal
	
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 10 in terminal 
	EndIf 
	Then I press keys "ENTER" in terminal
EndIf 

And I "verify I am ready to enter data"
	Once I see $trlr_num in terminal
	Once I see $check_in_dock_loc in terminal
	Once I see $carcod in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 10 in terminal 
	EndIf

And I "enter the trailer's current location"  
	Then I enter $check_in_dock_loc in terminal
	Once I see "Ok to move transport" in terminal
	Once I see "equipment?" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 16 column 18 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 39 in terminal
	EndIf  
	Then I type "Y" in terminal
	And I wait $wait_med seconds 

And I "move the trailer to the destination location"
	Once I see $trlr_num in terminal
	Once I see $check_in_dock_loc in terminal
	Once I see $carcod in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 14 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 13 in terminal 
	EndIf  
	Then I enter $move_to_dock_loc in terminal
	
	Once I see "OK" in terminal
	Once I see "Activity" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 16 column 17 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 29 in terminal
	EndIf  
	Then I type "Y" in terminal

And I "Confirm Operation is complete and return to the Undirected Menu"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 16 column 12 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 30 in terminal  
	EndIf 
	Once I see "Equip Deposited" in terminal 
	Once I see "Press Enter" in terminal
	Then I press keys "ENTER" in terminal
	And I press keys "F1" in terminal 2 times with $wait_short seconds delay
	And I wait $wait_med seconds

@wip @public
Scenario: Terminal Verify and Escalate Directed Work
#############################################################
# Description: This scenario verifies directed work is required and escalates it if so
# MSQL Files:
#	None
# Inputs:
# 	Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       username - User performing the work
#       move_to_dock_loc - Location trailer will be moved to
#       check_in_dock_loc - Location trailer will be checked in to
#		work_queue_or_immediate - Variable that indicates when the move is performed
#	Optional:
#		None
# Outputs:
# 		None                 
#############################################################

If I verify variable "work_queue_or_immediate" is assigned
And I verify text $work_queue_or_immediate is equal to "work_queue" 
	Then I execute scenario "Terminal Increase Trailer Move Directed Work Priority"
Endif

@wip @public
Scenario: Trailer Validate Move Data
#############################################################
# Description: This scenario verifies trailer is created and checked in
# MSQL Files:
#	validate_trailer_move.msql
# Inputs:
#	Required:
#		trlr_num - Trailer Number
#		carcod - Carrier Code
#		check_in_dock_loc - Location trailer will be check in to
#	Optional:
#		None
# Outputs:
#	None                     
#############################################################

Given I assign $check_in_dock_loc to variable "validate_loc"
And I assign "validate_trailer_move.msql" to variable "msql_file"
Then I execute scenario "Perform MSQL Execution"
If I verify MOCA status is 0
	Then I echo "Trailer Exists In Correct Location!"
Else I fail step with error message "ERROR: Trailer does not exist where we expect!"
Endif

@wip @public
Scenario: Trailer Moving Post Move Checks
#############################################################
# Description: This scenario verifies trailer is in expected final location
# MSQL Files:
#	validate_trailer_move.msql
# Inputs:
#     Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       move_to_dock_loc - Location trailer will be moved to
#	Optional:
#		None
# Outputs:
#		None                     
#############################################################

Given I assign $move_to_dock_loc to variable "validate_loc"
And I assign "validate_trailer_move.msql" to variable "msql_file"
Then I execute scenario "Perform MSQL Execution"
If I verify MOCA status is 0
	Then I echo "Trailer Exists In Correct Location!"
Else I fail step with error message "ERROR: Trailer does not exist where we expect!"
Endif

@wip @public
Scenario: Trailer Move Post Work Checks
#############################################################
# Description: This scenario verifies trailer work exists or is in expected final location
# MSQL Files:
#	verify_trailer_move_directed_work.msql
# Inputs:
# 	Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       move_to_dock_loc - Location trailer will be moved to
#		check_in_dock_loc - Location trailer will be check in to
#       username - User performing the work
#		work_queue_or_immediate - Indicates move method
# 	Optional:
#		None
# Outputs:
#		None              
#############################################################

If I verify variable "work_queue_or_immediate" is assigned
And I verify text $work_queue_or_immediate is equal to "work_queue" 
	Then I assign "verify_trailer_move_directed_work.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
Else I execute scenario "Trailer Moving Post Move Checks"
EndIf

@wip @public
Scenario: Create Trailer Move Work
#############################################################
# Description: This scenario creates trailer move work
# MSQL Files:
#	create_trailer_move_work_for_terminal.msql
# Inputs:
# 	Required:
#       None
#	Optional:
#		None
# Outputs:
#		None                     
#############################################################

Given I assign "create_trailer_move_work_for_terminal.msql" to variable "msql_file"
Then I execute scenario "Perform MSQL Execution"
And I verify MOCA status is 0

#############################################################
# Private Scenarios:
#	Terminal Increase Trailer Move Directed Work Priority - escalates trailer move directed work
#############################################################

@wip @private
Scenario: Terminal Increase Trailer Move Directed Work Priority
#############################################################
# Description: This scenario escalates trailer move directed work
# MSQL Files:
#	escalate_trailer_move_directed_work_priority.msql
# Inputs:
# 	Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       username - User performing the work
#       move_to_dock_loc - Location trailer will be moved to
#       check_in_dock_loc - Location trailer will be check in to
#	Optional:
#		None
# Outputs:
# 		None      
#############################################################

Given I assign "escalate_trailer_move_directed_work_priority.msql" to variable "msql_file"
Then I execute scenario "Perform MSQL Execution"
And I verify MOCA status is 0