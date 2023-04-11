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
# Utility: Terminal Pallet Building Utilities.feature
# 
# Functional Area: Undirected Pallet Building
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description: Utilities to perform Pallet Building
#
# Public Scenarios:
#	- Terminal Pallet Building - Handles the overall flow and logic of Pallet Building functionality
# 	- Open Pallet Building Menu Option - From the Undirected Menu, goes to the Pallet Build screen
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Pallet Building Utilities

@wip @public
Scenario: Terminal Pallet Building
#############################################################
# Description: From the terminal undirected menu screen, given the pallet building staging location, 
# performs the entirety of the pallet building functionality.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		pb_stage_loc - pallet building staging location
#   Optional:
#		pb_max_carton_count - maximum number of cartons that can be built into one pallet
# Outputs:
#	None
#############################################################

Given I "check the pallet build staging location to ensure there is at least one carton to pallet build"
	Given I execute scenario "Check Pallet Build Stage for Cartons"
	If I verify number $staged_carton_count is greater than 0
		Then I echo "Cartons found in pallet build staging location. Proceeding..."
		And I assign "YES" to variable "cartons_exist"
	Else I echo "No cartons found in pallet build staging location. Exiting test."
		Then I assign "NO CARTONS FOUND IN PALLET BUILD STAGE LOCATION - TEST ENDED" to variable "end_message"
		And I assign "NO" to variable "cartons_exist"
	EndIf

When I "process the Pallet Build"
	If I verify text $cartons_exist is equal to "YES"    
		Then I "enter the pallet build staging location"    
			And I enter $pb_stage_loc in terminal
			And I assign 0 to variable "DONE"
		
	Then I "build all cartons in pallet staging locations into pallets"
		While I see "Pallet Build" on line 1 in terminal within $wait_med seconds 
	 	And I verify number $DONE is equal to 0
	 		Then I execute scenario "Get Next Carton for Pallet Building"
			If I verify text $carton_found is equal to "YES"            
				Then I "process pallet building on the selected carton"
				And I execute scenario "Process Carton Pallet Build"         
				And I wait $wait_med seconds             
			Else I echo "There are no more cartons left in location " $pb_stage_loc ". We will exit the test."
				Then I assign 1 to variable "DONE"
			EndIf
		EndWhile
	ElsIf I echo "There are no cartons in the pallet build location, exiting test"
	EndIf

@wip @public
Scenario: Open Pallet Building Menu Option
#############################################################
# Description: From the terminal undirected menu screen, opens the pallet building menu.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#   Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "open the Picking Menu"
	Once I see "Undirected Menu" in terminal
	Then I type option for "Picking Menu" menu in terminal
	
When I "open the Pallet Building menu option"
	Once I see "Pallet Building" in terminal
	Then I type option for "Pallet Building" menu in terminal

Then I "validate I am on the Pallet Build screen"
	If I see "Pallet Build" on line 1 in terminal within $wait_med seconds 
		Then I echo "Pallet Build screen is open. OK to proceed"
	Else I echo "Incorrect screen. Exiting..."
		And I fail step with error message "ERROR: Incorrect RF screen selected. Exiting..."
	EndIf
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 2 in terminal
	ElsIf I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 17 in terminal
	Else I fail step with error message "ERROR: Cursor not in expected position to scan pallet build location"
	EndIf

#############################################################
# Private Scenarios:
#   Get Pallet Position for New Pallet - Runs a MSQL to determine pallet position for new pallet
#	Get Pallet Number in Pallet Position - Runs a MSQL to determine pallet number (lodnum) in a pallet position (palpos)
#	Process Carton Pallet Build - Handles the looping logic of performing pallet building after the location from which to pallet build is selected
#	Complete Pallet - Nests logic to see if the current pallet that is being built has been completed or if it should be completed based off maximum number of cartons to a pallet (pb_max_carton_count)
#	Check Pallet Build Stage for Cartons - Checks pallet build staging location for cartons available
#	Get Carton Count on Pallet Build Pallet - Get the carton count on a pallet that is currently being built
#	Get Next Carton for Pallet Building - Get the next carton for pallet building from the pallet build staging locations
#	Determine Pallet Build Mode - Determines the pallet build mode - new or adding to a pallet based on cursor position in the terminal screen
#############################################################

@wip @private
Scenario: Process Carton Pallet Build
#############################################################
# Description: Handles the looping logic of performing pallet building after the location from which to pallet build is selected
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		carton - Carton number in pallet build staging location
#   Optional:
#		None
# Outputs:
#	  None
#############################################################

Given I "enter the carton"
	Then I enter $carton in terminal

And I "determine if I need to start a new pallet or add to an existing pallet"
	When I execute scenario "Determine Pallet Build Mode"

When I "process pallet building based on pallet build mode (new or add to pallet)"
	If I verify text $mode is equal to "NEW_PALLET"
		Given I execute scenario "Get Pallet Position for New Pallet"
		
		If I verify text $palpos is not equal to "NONE"
			When I enter $palpos in terminal

			And I "enter load number for the new pallet"
				Then I assign "get_next_lodnum_for_new_pallet_build_pallet.msql" to variable "msql_file"
				And I execute scenario "Perform MSQL Execution"
				And I assign row 0 column "nxtnum" to variable "pallet"
				And I enter $pallet in terminal

			Then I "Check to see if pallet building is complete"
				Then I execute scenario "Complete Pallet"
				
		Else I echo "Out of Pallet Build Positions"
			Then I assign 1 to variable "DONE"
		Endif
		
	Elsif I verify text $mode is equal to "ADD_TO_PALLET"
		Then I "check the cursor position and copy the pallet position"
		And I "verify screen has loaded for information to be copied off of it"
			Then I verify screen is done loading in terminal within $max_response seconds

			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 11 column 1 in terminal 
				Then I copy terminal line 9 columns 1 through 4 to variable "palpos"
			Else I see cursor at line 5 column 7 in terminal within $wait_long seconds 
				Then I copy terminal line 4 columns 18 through 21 to variable "palpos"
			EndIf

		Then I "find the pallet assigned to the pallet position and enter it on the screen"
			Given I execute scenario "Get Pallet Number in Pallet Position"
			And I execute scenario "Terminal Clear Field"
			When I enter $pallet in terminal

		Then I "check to see if pallet building is complete"
			Then I execute scenario "Complete Pallet"
	Endif

@wip @private
Scenario: Complete Pallet
#############################################################
# Description: Nests logic to see if the current pallet that is being built has been completed or 
# if it should be completed based off maximum number of cartons to a pallet (pb_max_carton_count)
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#   Optional:
#		pb_max_carton_count - Maximum number of cartons to a pallet
# Outputs:
#	 None
#############################################################

If I see "completed" in terminal within $wait_med seconds 
	When I "acknowledge the pallet was automatically completed and deposit it to a staging location"
		And I press keys "ENTER" in terminal
		Once I see "Deposit" in terminal

	Then I "verify screen has loaded for information to be copied off of it"
		And I verify screen is done loading in terminal within $max_response seconds
	  
	And I "get the deposit location from the screen"
		If I verify text $term_type is equal to "handheld"
			Then I copy terminal line 12 columns 6 through 20 to variable "dep_loc"
	  	Else I verify text $term_type is equal to "vehicle"
			Then I copy terminal line 7 columns 7 through 20 to variable "dep_loc"
	  	EndIf
	
	Then I "deposit the pallet to its final location"
		And I execute scenario "Terminal Deposit"
		
	And I assign 1 to variable "DONE"
	
Else I "check for max carton count on the pallet and close if necessary"

	Given I execute scenario "Get Carton Count on Pallet Build Pallet"
	If I verify number $carton_count is greater than or equal to $pb_max_carton_count
		Then I "force the pallet to complete"
		  	Then I press keys "F6" in terminal
		  	If I verify text $term_type is equal to "handheld"
			  	Once I see cursor at line 4 column 1 in terminal
		  	Else I see cursor at line 3 column 10 in terminal within $max_response seconds 
		 	EndIf
			Then I enter $pallet in terminal
		
		And I "deposit the pallet"
			If I see "Load is not in" in terminal within $wait_med seconds 
				And I press keys "ENTER" in terminal
				And I press keys "F1" in terminal
			ElsIf I see "Deposit" in terminal within $wait_long seconds 
			And I wait $wait_short seconds 

		 	Then I "get the deposit location from the screen"
			 	And I "verify screen has loaded for information to be copied off of it"
					Then I verify screen is done loading in terminal within $max_response seconds
					
			  	If I verify text $term_type is equal to "handheld"
				  	Then I copy terminal line 12 columns 6 through 20 to variable "dep_loc"
			  	Else I verify text $term_type is equal to "vehicle"
					Then I copy terminal line 7 columns 7 through 20 to variable "dep_loc"
			  	EndIf
			  
			And I execute scenario "Terminal Deposit"
			Then I assign 1 to variable "DONE"
		Endif
	EndIf
Endif

@wip @private
Scenario: Determine Pallet Build Mode
#############################################################
# Description: Determines the pallet build mode - new or adding to a pallet based on cursor position 
# in the terminal screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#   Optional:
#		None
# Outputs:
#	 mode - Determine whether we are using a new pallet or adding to an existing pallet build pallet
#############################################################

If I see "contains a Different" in terminal within $wait_med seconds
	Then I press keys "ENTER" in terminal
EndIf

If I verify text $term_type is equal to "handheld"
	If I see cursor at line 9 column 1 in terminal within $wait_med seconds 
		Then I assign "NEW_PALLET" to variable "mode"
	ElsIf I see cursor at line 11 column 1 in terminal
		Then I assign "ADD_TO_PALLET" to variable "mode"
	EndIf
ElsIf I verify text $term_type is equal to "vehicle"
	If I see cursor at line 4 column 19 in terminal within $wait_med seconds 
		Then I assign "NEW_PALLET" to variable "mode"
	ElsIf I see cursor at line 5 column 7 in terminal
		Then I assign "ADD_TO_PALLET" to variable "mode"
	EndIf
Else I echo "The cursor is not in the expected position"
	Then I fail step with error message "ERROR: Cursor not at expected position after carton scan"
EndIf

@wip @private
Scenario: Get Next Carton for Pallet Building
#############################################################
# Description: Get the next carton for pallet building from the pallet build staging locations
# MSQL Files:
#	get_next_pallet_build_carton_in_staging_location.msql
# Inputs:
# 	Required:
#		pb_stage_loc - pallet build staging location
#   Optional:
#		None
# Outputs:
#	 carton_found - binary variable. YES or NO
#	 carton - sub load number (identifier) of the carton to be pallet built
#	 pallet_loc - The pallet build location
#	 consolidate_val - pallet build consolidation by (if applicable)
#############################################################

When I "execute MSQL to get the next carton for pallet building from the pallet build staging locations"
	Given I assign "get_next_pallet_build_carton_in_staging_location.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
  	If I verify MOCA status is 0
		Then I assign row 0 column "subnum" to variable "carton"
	  	And I assign row 0 column "pndloc" to variable "pallet_loc"
	  	And I assign row 0 column "consolidate_val" to variable "consolidate_val"
	  	And I assign "YES" to variable "carton_found"
  	Else I assign "NO" to variable "carton_found"
  	EndIf

@wip @private
Scenario: Check Pallet Build Stage for Cartons
#############################################################
# Description: Checks pallet build staging location for cartons available
# MSQL Files:
#	get_carton_count_in_pallet_build_stage.msql
# Inputs:
# 	Required:
#		pb_stage_loc - Pallet Building staging location
#   Optional:
#		None
# Outputs:
#	 staged_carton_count - Number of cartons available in the specified pallet build stage location
#############################################################

When I "expect a carton available for pallet building. If none found, then we will exit the test."
	Given I assign "get_carton_count_in_pallet_build_stage.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I assign row 0 column "staged_carton_count" to variable "staged_carton_count"
  
@wip @private
Scenario: Get Carton Count on Pallet Build Pallet
#############################################################
# Description: Get the carton count on a pallet that is currently being built
# MSQL Files:
#	get_carton_count_on_pallet_for_pallet_build.msql
# Inputs:
# 	Required:
#		pallet - lodnum of pallet being built currently
#   Optional:
#		None
# Outputs:
#	 carton_count - Number of cartons that have been built into the current pallet building pallet
#############################################################

When I "execute MSQL to get the carton count on a pallet that is currently being built"
	Given I assign "get_carton_count_on_pallet_for_pallet_build.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I assign row 0 column "carton_count" to variable "carton_count"

@wip @private
Scenario: Get Pallet Position for New Pallet
#############################################################
# Description: Runs a MSQL to determine pallet position for new pallet.
# MSQL Files:
#	get_pallet_build_position_for_new_pallet.msql
# Inputs:
# 	Required:
#		pallet_loc - Pallet Build location
#   Optional:
#		None
# Outputs:
#	  palpos - the pallet position for the new pallet
#############################################################

When I "execute a MSQL to determine pallet position for new pallet"
	Given I assign "get_pallet_build_position_for_new_pallet.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I assign row 0 column "palpos" to variable "palpos"

@wip @private
Scenario: Get Pallet Number in Pallet Position
#############################################################
# Description: Runs a MSQL to determine pallet number (lodnum) in a pallet position (palpos).
# MSQL Files:
#	get_pallet_in_pallet_build_position.msql
# Inputs:
# 	Required:
#		pallet_loc - Pallet Build location
#		palpos - the pallet position to check 
#   Optional:
#		None
# Outputs:
#	  pallet - load number of pallet being built currently
#############################################################

When I "execute a MSQL to determine pallet number (lodnum) in a pallet position (palpos)"
	Given I assign "get_pallet_in_pallet_build_position.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I assign row 0 column "lodnum" to variable "pallet"