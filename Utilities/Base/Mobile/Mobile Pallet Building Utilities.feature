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
# Utility: Mobile Pallet Building Utilities.feature
# 
# Functional Area: Pallet Building
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile
#
# Description: Utilities to perform Pallet Building with the Mobile App.
#
# Public Scenarios:
#	- Mobile Pallet Building - Handles the overall flow and logic of Pallet Building functionality
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Pallet Building Utilities

@wip @public
Scenario: Mobile Pallet Building
#############################################################
# Description: From the Mobile App undirected menu screen, given the pallet building staging location, 
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
	Then I execute scenario "Check Pallet Build Stage for Cartons"
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
			And I assign "Location" to variable "input_field_with_focus"
			Then I execute scenario "Mobile Check for Input Focus Field"
			And I type $pb_stage_loc in element "name:stoloc" in web browser within $max_response seconds
			Then I press keys "ENTER" in web browser

			And I assign 0 to variable "DONE"
		
	Then I "build all cartons in pallet staging locations into pallets"
		While I verify number $DONE is equal to 0
		And I see "Pallet Build" in element "className:appbar-title" in web browser within $wait_med seconds
	 		Then I execute scenario "Get Next Carton for Pallet Building"
			If I verify text $carton_found is equal to "YES"            
				Then I "process pallet building on the selected carton"
					And I execute scenario "Mobile Process Carton Pallet Build"         
					And I wait $screen_wait seconds             
			Else I echo "There are no more cartons left in location " $pb_stage_loc ". We will exit the test."
				Then I assign 1 to variable "DONE"
			EndIf
		EndWhile
	ElsIf I echo "There are no cartons in the pallet build location, exiting test"
	EndIf

#############################################################
# Private Scenarios:
#	Mobile Process Carton Pallet Build - Handles the looping logic of performing pallet building after the location from which to pallet build is selected
#	Mobile Complete Pallet - Nests logic to see if the current pallet that is being built has been completed or if it should be completed based off maximum number of cartons to a pallet (pb_max_carton_count)
#	Mobile Determine Pallet Build Mode - Determines the pallet build mode - new or adding to a pallet based screen data in the Mobile screen
#############################################################

@wip @private
Scenario: Mobile Process Carton Pallet Build
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
	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I clear all text in element "name:lod_id" in web browser within $max_response seconds
	Then I type $carton in element "name:lod_id" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "determine if I need to start a new pallet or add to an existing pallet"
	When I execute scenario "Mobile Determine Pallet Build Mode"

When I "process pallet building based on pallet build mode (new or add to pallet)"
	If I verify text $mode is equal to "NEW_PALLET"
		Then I execute scenario "Get Pallet Position for New Pallet"
		
		If I verify text $palpos is not equal to "NONE"
			Then I assign "Pallet Position" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			And I clear all text in element "name:palpos" in web browser within $max_response seconds
			Then I type $palpos in element "name:palpos" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser

			And I "enter load number for the new pallet"
				Then I assign "get_next_lodnum_for_new_pallet_build_pallet.msql" to variable "msql_file"
				And I execute scenario "Perform MSQL Execution"
				And I assign row 0 column "nxtnum" to variable "pallet"

				Then I assign "LPN" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"
				And I clear all text in element "name:lodnum" in web browser within $max_response seconds
				Then I type $pallet in element "name:lodnum" in web browser within $max_response seconds
				And I press keys "ENTER" in web browser

			Then I "check to see if pallet building is complete"
				And I execute scenario "Mobile Complete Pallet"
				
		Else I echo "Out of Pallet Build Positions"
			Then I assign 1 to variable "DONE"
		Endif
		
	Elsif I verify text $mode is equal to "ADD_TO_PALLET"
		Then I "check screen data and copy the pallet position"
			And I copy text inside element "xPath://span[contains(text(),'Pallet Position')]/ancestor::aq-displayfield[contains(@id,'palpos')]/descendant::span[contains(@class,'data')]" in web browser to variable "palpos" within $max_response seconds

		Then I "find the pallet assigned to the pallet position and enter it on the screen"
			Given I execute scenario "Get Pallet Number in Pallet Position"

			Then I assign "LPN" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			And I clear all text in element "name:lodnum" in web browser within $max_response seconds
			Then I type $pallet in element "name:lodnum" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser

		Then I "check to see if pallet building is complete"
			And I execute scenario "Mobile Complete Pallet"
	Endif

@wip @private
Scenario: Mobile Complete Pallet
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

Given I assign "completed" to variable "mobile_dialog_message"
And I execute scenario "Mobile Set Dialog xPath"
If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
	When I "acknowledge the pallet was automatically completed and deposit it to a staging location"
		And I press keys "ENTER" in web browser
		Once I see "Deposit" in element "className:appbar-title" in web browser
	  
	And I "get the deposit location from the screen"
		Then I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'dsploc')]/descendant::span[contains(@class,'data')]" in web browser to variable "dep_loc" within $max_response seconds
	
	Then I "deposit the pallet to its final location"
		And I execute scenario "Mobile Deposit"
		
	And I assign 1 to variable "DONE"
	
Else I "check for max carton count on the pallet and close if necessary"

	Given I execute scenario "Get Carton Count on Pallet Build Pallet"
	If I verify number $carton_count is greater than or equal to $pb_max_carton_count
		Then I "force the pallet to complete"
		  	Then I press keys "F6" in web browser
			And I execute scenario "Mobile Wait for Processing"

            Then I assign "LPN" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I type $pallet in element "name:invtid" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
		
		And I "deposit the pallet"
			Then I assign "Load is not in" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds 
				Then I press keys "ENTER" in web browser
				And I execute scenario "Mobile Wait for Processing"
				And I press keys "F1" in web browser
			ElsIf I see "Deposit" in element "className:appbar-title" in web browser within $wait_long seconds 
				And I wait $wait_short seconds 

		 		Then I "get the deposit location from the screen"
					And I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'dsploc')]/descendant::span[contains(@class,'data')]" in web browser to variable "dep_loc" within $max_response seconds
			  
				And I execute scenario "Mobile Deposit"
				Then I assign 1 to variable "DONE"
			Endif
	EndIf
Endif

@wip @private
Scenario: Mobile Determine Pallet Build Mode
#############################################################
# Description: Determines the pallet build mode - new or adding to a pallet based on screen data
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

	Given I assign "contains a Different" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	EndIf

	Then I assign "Pallet Position" to variable "input_field_with_focus"
	And I assign variable "mobile_focus_elt" by combining "xPath://div[@class='mat-form-field-infix']/descendant::mat-label[contains(text(),'" $input_field_with_focus "')]"
	If I see element $mobile_focus_elt in web browser within $screen_wait seconds
		Then I assign "NEW_PALLET" to variable "mode"
	Else I assign "ADD_TO_PALLET" to variable "mode"
	EndIf