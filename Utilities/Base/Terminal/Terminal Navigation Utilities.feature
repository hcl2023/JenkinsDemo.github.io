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
# Utility: Terminal Navigation Utilities.feature
# 
# Functional Area: Terminal
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Terminal
#
# Description: Utility Scenarios that navigate to certain parts of the Terminal
#
# Public Scenarios:
#	- Terminal Navigate to Undirected Menu - From most screens, navigate to the Undirected Menu
#	- Terminal Navigate Quickly to Undirected Menu - Will navigate to Undirected Menu, not checking for deposit steps
#	- Terminal Navigate to Directed Work Menu - From the Undirected Menu, navigates to the Directed Work Menu
#	- Terminal Navigate to Load Equipment Menu - From the Undirected Menu, navigates to the Load Equipment Menu
#	- Terminal Navigate to Close Equipment Menu - From the Undirected Menu, navigates to the Close Equipment Menu
#	- Terminal Navigate to Dispatch Equipment Menu - From the Undirected Menu, navigates to the Dispatch Equipment Menu
#	- Terminal Navigate to LTL Load Menu - From the Undirected Menu, navigates to the LTL Load Menu
#	- Terminal Exit Directed Work Mode - From Directed Work, whatever state it is in, exit the mode.
#	- Terminal Navigate to Cycle Count Menu - From the Undirected Menu, navigates to the Cycle Count Entry screen
#	- Terminal Navigate to Audit Count Menu - From the Undirected Menu, navigates to the Audit Count Entry screen
#	- Terminal Inventory Status Change Menu - Navigate to the Inventory Status Screen
#	- Terminal Inventory Adjustment Menu - Navigate to the Innventory Adjustment Screen
#	- Terminal Receiving Unload Shipment Menu - Navigate to the Receiving Unload Shipment Screen
#	- Terminal Navigate to Inventory Transfer Menu - Navigate to the Inventory Transfer/Move Screen
#	- Terminal Receiving Complete Receiving Menu - Navigate to the Receiving Complete Rcv Screen
#	- Terminal Inventory Display Menu - Navigate to Inventory Display Screen
#	- Terminal Inventory Location Display Menu - Navigate to Inventory Location Display Screen
#	- Terminal Shipping Manual Outbound Audit Menu - Navigate to Manual Outbound Audit Screen
#	- Terminal Navigate to Partial Inventory Move Menu - Navigate to the Terminal Partial Inventory Move Screen
#	- Terminal Navigate to Reopen Equipment Menu - Navigate to the Terminal Reopen Equipment Menu
#	- Terminal Navigate to Unload Equipment Menu - Navigate to the Terminal Unload Equipment Menu
#	- Terminal Navigate to Manual Count Menu - Navigate to the Terminal Manual Count Menu
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Navigation Utilities

@wip @public
Scenario: Terminal Navigate Quickly to Undirected Menu
#############################################################
# Description: This will navigate to the Undirected Menu from most Terminal screens.
# If will bypass deposit and other checks and simply do the traversal home.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I assign 0 to variable "undir_loop_counter"
And I assign 50 to variable "undir_loop_max"
While I verify number $undir_loop_counter is less than or equal to $undir_loop_max
	Then I verify screen is done loading in terminal within $max_response seconds
	If I do not see "ndirected Menu" in terminal within $wait_short seconds 
		Given I press keys "F1" in terminal
		
		If I see "Logout" in terminal within $wait_short seconds 
		And I see "Y|N" in terminal
        	If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 16 column 20 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 8 column 21 in terminal
            Endif
			Then I press keys "N" in terminal
		Endif
		
		If I see "Invalid" in terminal within $wait_short seconds 
		And I see "Enter" in terminal
	  		Once I press keys "ENTER" in terminal
	  		And I wait $wait_short seconds 
		Endif
	Else I increase variable "undir_loop_counter" by $undir_loop_max
	Endif
	Then I increase variable "undir_loop_counter" by 1
EndWhile

@wip @public
Scenario: Terminal Navigate to Undirected Menu
#############################################################
# Description: This will navigate to the Undirected Menu from most Terminal screens.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I assign 0 to variable "undir_loop_counter"
And I assign 50 to variable "undir_loop_max"
And I assign 0 to variable "at_login_screen"
While I verify number $undir_loop_counter is less than or equal to $undir_loop_max
And I verify number $at_login_screen is equal to 0
	If I do not see "ndirected Menu" in terminal within $wait_med seconds 
		Given I press keys "F1" in terminal
		
		If I see "Logout" in terminal within $screen_wait seconds 
		And I see "Y|N" in terminal
        	If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 16 column 20 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 8 column 21 in terminal
            Endif
			Then I press keys "N" in terminal
		Endif
		
		If I see "Invalid" in terminal within $wait_short seconds 
		And I see "Enter" in terminal
	  		Once I press keys "ENTER" in terminal
	  		And I wait $wait_short seconds 
		Endif
		
		If I see "Login" on line 1 in terminal within $wait_short seconds 
		And I see "User ID:" in terminal
		And I see "Password:" in terminal
			Then I assign 1 to variable "at_login_screen"
		Endif
		
		If I see "Load Preparation" on line 1 in terminal within $wait_short seconds 
		And I see "fully prepared" in terminal
		And I see "Y|N" in terminal
			Then I enter "Y" in terminal
		Endif
		
		If I see "MRG" on line 1 in terminal within $wait_short seconds 
		And I see "Lod:" in terminal within $wait_short seconds 
			Then I execute scenario "Terminal Deposit"
		Endif
		
		If I see "Inventory Deposit" on line 1 in terminal within $wait_short seconds 
			Then I execute scenario "Terminal Inventory Deposit"
		Endif
		If I see "ÿý" on line 1 in terminal within $wait_short seconds 
			Once I press keys "ENTER" in terminal
		Endif
		
		If I see "Authenti" on line 1 in terminal within $wait_short seconds 
			Given I execute scenario "Check for Authentication Screen"
		Endif
		
		If I see "Could Not Allocate" in terminal within $wait_short seconds 
			Then I press keys "ENTER" in terminal
			And I execute scenario "Check for Recovery Mode"
		ElsIf I see "Recovery" in terminal within $wait_short seconds 
			Then I execute scenario "Check for Recovery Mode"
		EndIf
		
		Given I execute scenario "Check for F6"
		If I see "Depsoit Options" on line 1 in terminal within $wait_short seconds 
			If I see "Vehicle" in terminal within $screen_wait seconds 
			And I see "Full" in terminal
				Once I see "Y|N" in terminal
				Once I press keys "Y" in terminal
				Then I execute scenario "Terminal Deposit"
			EndIf
		Endif
	Else I increase variable "undir_loop_counter" by $undir_loop_max
	Endif
	Then I increase variable "undir_loop_counter" by 1
EndWhile

@wip @public
Scenario: Terminal Exit Directed Work Mode
#############################################################
# Description: From Directed Work, exit to the Undirected Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I assign 100 to variable "max_exit_loops"
And I assign 0 to variable "exit_current_loops"
While I do not see "Undirected" in terminal within $wait_short seconds
And I verify number $exit_current_loops is less than $max_exit_loops
	And I wait $wait_short seconds
	If I see "Directed Mode" in terminal
		Then I press keys "F1" in terminal
	Elsif I see "Press Enter To Ack" in terminal
		Then I press keys "F1" in terminal
	EndIf
    Then I increase variable "exit_current_loops" by 1
EndWhile

And I wait $wait_med seconds

@wip @public
Scenario: Terminal Navigate to Directed Work Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Directed Work Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

When I "navigate to the Undirected Menu"
	Once I see "Undirected Menu" in terminal
    If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
    Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 7 column 18 in terminal
	Endif
	And I wait $screen_wait seconds
	When I type option for "Directed Work" menu in terminal
    
Given I "wait for directed work to appear"
	Then I "wait some time for directed work" which can take between $wait_med seconds and $wait_long seconds

@wip @public
Scenario: Terminal Navigate to Load Equipment Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Load Equipment Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the Shipment Menu"
	Once I see "Undirected Menu" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Shipment Menu" menu in terminal

When I "navigate to the Load Equip screen"
	Once I see "Load Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Load Equip" menu in terminal

Then I "validate we are on the Load Equip screen"
	Once I see "Stop:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 20 in terminal
	Endif
	Then I execute scenario "Terminal Clear Field"
 
@wip @public
Scenario: Terminal Navigate to Close Equipment Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Close Equipment Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the Shipment Menu"
	Once I see "Undirected Menu" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Shipment Menu" menu in terminal

When I "navigate to the Close Equip screen"
	Once I see "Close Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Close Equip" menu in terminal

Then I "validate we are on the Close Equip screen"
	Once I see "Close Equip" in terminal 
	Once I see "Car Cod:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 3 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 20 in terminal
	Endif
	Then I execute scenario "Terminal Clear Field"

@wip @public
Scenario: Terminal Navigate to Dispatch Equipment Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Close Equipment Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the Shipment Menu"
	Once I see "Undirected Menu" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Shipment Menu" menu in terminal

When I "navigate to the Next screen in Shipment Menu"
	Once I see "Load Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Next" menu in terminal

When I "navigate to the Dispatch Equip screen"
	Once I see "Dispatch Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Dispatch Equip" menu in terminal

Then I "validate we are on the Dispatch Equip screen"
	Once I see "Dispatch Equip" on line 1 in terminal 
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 3 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 2 column 11 in terminal
	Endif
	Then I execute scenario "Terminal Clear Field"
 
@wip @public
Scenario: Terminal Navigate to LTL Load Menu
#############################################################
# Description: From the Undirected Menu, navigate to the LTL Load Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the Shipment Menu"
	Once I see "Undirected Menu" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Shipment Menu" menu in terminal

When I "navigate to the LTL Loading Menu"
	Once I see "LTL Loading" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "LTL Loading" menu in terminal

Then I "validate we are on the LTL Loading screen"
	Once I see "Dock:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 10 in terminal
	Endif
	Then I execute scenario "Terminal Clear Field"

@wip @public
Scenario: Terminal Navigate to Cycle Count Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Cycle Count Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the Cycle Count Menu"
	Once I see "Undirected Menu" in terminal 
    If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Cycle Count Menu" menu in terminal
    
When I "navigate to the Cycle Count screen"
	Once I see "Manual Count" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Cycle Count" menu in terminal
    
Then I "validate we are on the Cycle Count screen"
	Once I see "Cycle Count Entry" in terminal 
    Once I see "Count Zone" in terminal
  	And I verify screen is done loading in terminal within $max_response seconds

@wip @public
Scenario: Terminal Navigate to Audit Count Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Audit Count Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Count Audit Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal 
	Once I see "Cycle Count Menu" in terminal 
	Then I wait $wait_short seconds
	
	Then I type option for "Cycle Count Menu" menu in terminal
	Once I see "Cycle Count Men" in terminal 
	Once I see "Count Audit" in terminal 
	Then I wait $wait_short seconds 

	Then I type option for "Count Audit" menu in terminal
	Once I see "Count Audit" in terminal 
	Once I see "Count Batch:" in terminal 
	Once I see "Loc:" in terminal 
	And I verify screen is done loading in terminal within $max_response seconds

@wip @public
Scenario: Terminal Navigate to Inventory Transfer Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Inventory Transfer/Move screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
############################################################# 

Given I "navigate to the Full Inventory Move Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal 
	And I type option for "Inventory Menu" menu in terminal
	Once I see "Full Inv Move" in terminal
	And I type option for "Full Inv Move" menu in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see "Full Inv Move" on line 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see "Full Inventory Move" on line 1 in terminal
	Endif
    And I verify screen is done loading in terminal within $max_response seconds

    
@wip @public
Scenario: Terminal Inventory Status Change Menu
#############################################################
# Description: This scenario traverses to the Maint Menu and
# Status Change sub-menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "navigate to Terminal Inventory Status Change Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected" in terminal
	Given I press keys "F7" in terminal
	Once I see "Maint Menu" in terminal
	Then I type option for "Maint Menu" menu in terminal
	Once I see "Status Change" in terminal
	And I type option for "Status Change" menu in terminal
    And I verify screen is done loading in terminal within $max_response seconds

@wip @public
Scenario: Terminal Inventory Adjustment Menu
#############################################################
# Description: Traverse to the Terminal Inventory Adjustment Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Terminal Inventory Adjustment Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Inventory Menu" menu in terminal
	Once I see "Inventory Dsp" in terminal 
	Then I type option for "Next" menu in terminal
	Once I see "Inventory Adjust" in terminal 
	Then I type option for "Inventory Adjust" menu in terminal
	Once I see "Inventory Adjustment" in terminal
    And I verify screen is done loading in terminal within $max_response seconds
    
@wip @public
Scenario: Terminal Inventory Display Menu
#############################################################
# Description: Traverse to the Terminal Inventory Display Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Terminal Inventory Display Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Inventory Menu" menu in terminal
	Once I see "Inventory Dsp" in terminal 
	Then I type option for "Inventory Dsp" menu in terminal
	Once I see "Inventory Dsp" in terminal 
    And I verify screen is done loading in terminal within $max_response seconds
    
@wip @public
Scenario: Terminal Receiving Unload Shipment Menu 
#############################################################
# Description: Traverse to the Terminal Receiving Upload Ship Screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Terminal Receiving Unload Shipment Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Receiving Menu" menu in terminal
	Once I see "Receiving Menu" on line 1 in terminal
	Then I type option for "Next" menu in terminal
	Once I see "Unload Ship" in terminal
	Then I type option for "Unload Ship" menu in terminal
	Once I see "Unload Ship" on line 1 in terminal
    And I verify screen is done loading in terminal within $max_response seconds
    
@wip @public
Scenario: Terminal Receiving Complete Receiving Menu 
#############################################################
# Description: Traverse to the Terminal Receiving Complete Rcv Screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Terminal Receiving Complete Rcv Screen"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Receiving Menu" menu in terminal
	Once I see "Receiving Menu" on line 1 in terminal
	Then I type option for "Complete Rcv" menu in terminal
	Once I see "Complete Receiving" on line 1 in terminal
    And I verify screen is done loading in terminal within $max_response seconds
    
@wip @public
Scenario: Terminal Inventory Location Display Menu
#############################################################
# Description: Traverse to the Terminal Inventory Location Display Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Terminal Inventory Display Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Inventory Menu" menu in terminal
	Once I see "Inventory Dsp" in terminal 
	Then I type option for "Next" menu in terminal
	Once I see "Location Display" in terminal 
	Then I type option for "Location Display" menu in terminal
	Once I see "Location Display" on line 1 in terminal 
    And I verify screen is done loading in terminal within $max_response seconds
    
@wip @public
Scenario: Terminal Shipping Manual Outbound Audit Menu
#############################################################
# Description: Traverse to the Manual Outbound Audit screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Manual Outbound Audit Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Shipment Menu" menu in terminal
	Once I see "Next" in terminal 
	Then I type option for "Next" menu in terminal
	Once I see "Man Out Audit" in terminal
	Then I type option for "Man Out Audit" menu in terminal
	Once I see "RF Outbound Audit" on line 1 in terminal 
    And I verify screen is done loading in terminal within $max_response seconds

@wip @public
Scenario: Terminal Navigate to Partial Inventory Move Menu
#############################################################
# Description: Navigate to the Terminal Partial Inventory Move Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Terminal Inventory Display Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Inventory Menu" menu in terminal
	Once I see "Part Inv Move" in terminal 
	Then I type option for "Part Inv Move" menu in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see "Part Inv Move" on line 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see "Partial Inventory Move" on line 1 in terminal
	Endif
	And I verify screen is done loading in terminal within $max_response seconds
	
@wip @public
Scenario: Terminal Navigate to Manual Count Menu
#############################################################
# Description: Navigate to the Terminal Manual Count Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "navigate to Terminal Manual Count Menu"
	Then I wait $wait_short seconds 
	Once I see "Undirected Menu" in terminal
	Then I type option for "Cycle Count Menu" menu in terminal
	Once I see "Manual Count" in terminal
	And I wait $screen_wait seconds
	Then I type option for "Manual Count" menu in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see "Manual Count" on line 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see "Manual Count" on line 1 in terminal
	Endif
	And I verify screen is done loading in terminal within $max_response seconds

@wip @public
Scenario: Terminal Navigate to Reopen Equipment Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Reopen Equipment Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the Shipment Menu"
	Once I see "Undirected Menu" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Shipment Menu" menu in terminal

When I "navigate to the Next screen in Shipment Menu"
	Once I see "Load Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Next" menu in terminal

Then I "navigate to the Reopen Equipment Screen"
	Once I see "Reopen Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Reopen Equip" menu in terminal	
    
@wip @public
Scenario: Terminal Navigate to Unload Equipment Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Unload Equipment Menu
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the Shipment Menu"
	Once I see "Undirected Menu" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Shipment Menu" menu in terminal

When I "navigate to the Unload Equip in Shipment Menu"
	Once I see "Unload Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 18 in terminal
	Endif
	When I type option for "Unload Equip" menu in terminal

#############################################################
# Private Scenarios:
#   None
#############################################################