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
# Utility: Mobile Navigation Utilities.feature
# 
# Functional Area: Mobile
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile
#
# Description: Utility Scenarios that navigate to certain parts of the Mobile App
#
# Public Scenarios:
#	- Mobile Putaway Menu - Navigate to the Undirected Putwaway screen
#	- Mobile Navigate to Directed Work Menu - From the Undirected Menu, navigates to the Directed Work Menu
#	- Mobile Exit Directed Work Mode - From Directed Work, whatever state it is in, exit the mode.
#	- Mobile Navigate to Cycle Count Menu - From the Undirected Menu, navigates to the Cycle Count Entry screen
#	- Mobile Inventory Status Change Menu - Navigate to the Inventory Status Screen
#	- Mobile Navigate to Inventory Transfer Menu - Navigate to the Inventory Transfer/Move Screen
#	- Mobile Inventory Display Menu - Navigate to Inventory Display Screen
#	- Mobile Inventory Location Display Menu - Navigate to Inventory Location Display Screen
#	- Mobile LPN Receiving Menu - navigates to LPN Receiving menu
#	- Mobile Navigate Quickly to Undirected Menu - Navigate to Undirected Menu Quickly (no checks for deposit needs)
#	- Mobile Complete Receiving Menu - Navigate to the Receiving Complete Rcv Screen
#	- Mobile Putaway Menu - Navigate to the Undirected Putwaway screen
#	- Mobile LPN Reverse Receipt Menu - navigates to the Reverse Order screen
#	- Mobile Receiving Without Order Menu - navigates to the Receive Without Order screen
#	- Mobile Receiving Unload Shipment Menu - Navigate to the Receiving Unload Shipment Screen
#	- Mobile Navigate to Audit Count Menu - From the Undirected Menu, navigates to the Audit Count Entry screen
#	- Mobile Navigate to Partial Inventory Move Menu - Navigate to the Mobile App Partial Inventory Move Screen
#	- Mobile Navigate to Select Yard Menu - Navigate to the Mobile Select Yard Screen
#	- Mobile Navigate to Shipment Pickup Equipment Menu - Navigate to the Mobile Shipment Pickup Equipment Screen
#	- Mobile Navigate to Manual Count Menu - Navigate to the Mobile Manual Count Menu
#	- Mobile Navigate to Unload Equipment Menu - Navigate to the Mobile App Unload Equipment Menu
#	- Mobile Navigate to Reopen Equipment Menu - Navigate to the Mobile App Reopen Equipment Menu
#	- Mobile Navigate to LTL Load Menu - From the Undirected Menu, navigates to the LTL Load Menu
#	- Mobile Navigate to Load Equipment Menu - From the Undirected Menu, navigates to the Load Equipment Menu
#	- Mobile Shipping Manual Outbound Audit Menu - Navigate to Manual Outbound Audit Screen
#	- Mobile Navigate to Unpick Menu - Navigate to the Mobile App unpick menu
# 	- Mobile Open Pallet Building Menu Option - From the Undirected Menu, go to the Pallet Build screen
# 	- Mobile Navigate to Carton Pick Menu - From the Undirected Menu, goes to the Carton Pick screen
#	- Mobile Work Assignment Menu - Navigates to the Work Assignment screen
#	- Mobile Navigate to Pick Product Screen - Navigate to the Pick Product screen
#	- Mobile Navigate to Dispatch Equipment Menu - Navigate to the Shipping, Dispatch screen
#	- Mobile Navigate to Close Equipment Menu - Navigate to the Shipping, Close screen
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Navigation Utilities

@wip @public
Scenario: Mobile Navigate to Pick Product Screen
#############################################################
# Description: This scenario Navigates to Pick Product screen
# MSQL Files:
#	None
# Inputs:
#     Required:
#       None
#   Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "ensure I am at the Undirected Menu"
	If I see "Undirected Menu" in element "className:appbar-title" in web browser within $screen_wait seconds
	Else I execute scenario "Mobile Navigate Quickly to Undirected Menu"
	EndIf

Then I "navigate to the Product Pickup Menu"
   	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Picking Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Picking Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Pick Product') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Product Pickup" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Work Assignment Menu
#############################################################
# Description: This scenario navigates to the Work Assignment screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

When I "navigates to mobile work assignment menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Picking Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Picking Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Work Asgnmt') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Work Assignment" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Carton Pick Menu
#############################################################
# Description: This scenario navigates to the Carton Pick screen from the Undirected Menu.
#		None
#   Optional:
#		None
# Outputs:
#	None
#############################################################

When I "navigate to the Carton Picking Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Picking Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Picking Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Carton Pick') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Build Batch" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Open Pallet Building Menu Option
#############################################################
# Description: From the Mobile App's undirected menu screen, open the pallet building menu.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "open the Picking Menu and Pallet Building Screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Picking Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Picking Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Pallet Building') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Pallet Build" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Unpick Menu
#############################################################
# Description: Navigates to the Unpick screen from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	None
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "navigate to the Unpick Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Picking Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Picking Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Unpick') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Unpick" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Shipping Manual Outbound Audit Menu
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
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Man Out Audit') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "RF Outbound Audit" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Load Equipment Menu
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

Given I "navigate to the Shipment Menu and Load Equip screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Load Equip') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Load Equip" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to LTL Load Menu
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

Given I "navigate to the Shipment Menu and the LTL Loading screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'LTL Loading') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "LTL Loading" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Close Equipment Menu
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

Given I "navigate to the Shipment Close Equip Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Close Equip') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Close Equip" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Dispatch Equipment Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Dispatch Equipment Menu
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

Given I "navigate to the Shipment Dispatch Equip Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Dispatch Equip') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Dispatch Equip" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Reopen Equipment Menu
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

Given I "navigate to the Shipment Reopen Equip Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Reopen Equip') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Reopen Equip" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Unload Equipment Menu
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

Given I "navigate to the Shipment Unload Equip Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Unload Equip') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Unload Equip" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Manual Count Menu
#############################################################
# Description: Navigate to the Mobile Manual Count Menu
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

Given I "navigate to Mobile Manual Count Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Cycle Count Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Cycle Count Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Manual Count') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Manual Count" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Shipment Pickup Equipment Menu
#############################################################
# Description: Navigate to the Mobile Shipment Pickup Equipment Screen
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

Given I "navigate to the Shipment / Pickup Euipment screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Shipment Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Shipment Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Pickup Equip') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Equip Pickup" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Select Yard Menu
#############################################################
# Description: Navigate to the Mobile Select Yard Screen
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

Given I "navigate to the Yard / Select Yard screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Yard Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Yard Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Select Yard Work') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Work Selection" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Partial Inventory Move Menu
#############################################################
# Description: Navigate to the Mobile Partial Inventory Move Menu
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

Given I "navigate to Inventory Display Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Inventory Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Part Inv Move') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Partial Inventory Move" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Audit Count Menu
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
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Cycle Count Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Cycle Count Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Count Audit') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Count Audit" in element "className:appbar-title" in web browser


@wip @public
Scenario: Mobile Receiving Unload Shipment Menu 
#############################################################
# Description: Traverse to the Receiving Upload Ship Screen
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

Given I "navigate to the Receiving Unload Shipment Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Receiving Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receiving Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receiving Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Unload Ship') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Unload Ship" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Receiving Without Order Menu 
########################################################################
# Description: This scenario navigates to the Receive Without Order Menu from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		None
# Outputs:
#     None
########################################################################

Given I "Navigate to the Receiving without Order Screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Receiving Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receiving Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receiving Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Rcv w/o Order') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receive Without Order" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile LPN Reverse Receipt Menu
#############################################################
# Description: This scenario navigates to the Reverse Order Menu
# from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "Navigate to the LPN Reverse Receipt Screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Receiving Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receiving Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Reverse Order') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Reverse Receipt" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Putaway Menu
#############################################################
# Description: This scenario will navigate to the Undirected
# Putaway Screen (from the top-level undirected menu)
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

Given I "Navigate to the Putaway Screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Inventory Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Putaway') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Putaway" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Complete Receiving Menu 
#############################################################
# Description: Traverse to the Receiving Complete Rcv Screen
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

Given I "navigate to the Receiving Complete Rcv Screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Receiving Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receiving Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Complete Rcv') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Complete Receiving" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile LPN Receiving Menu
#############################################################
# Description: This scenario navigates to the LPN Receiving Menu
# from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "navigate the LPN receiving screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Receiving Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receiving Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'LPN Receive') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Receive Product" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Putaway Menu
#############################################################
# Description: This scenario will navigate to the Undirected
# Putaway Screen (from the top-level undirected menu)
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

Given I "Navigate to the Putaway Screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Inventory Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Putaway') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Putaway" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Exit Directed Work Mode
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

Given I "handle exit from directed work screen"
	Given I assign 100 to variable "max_exit_loops"
	And I assign 0 to variable "exit_current_loops"
	While I do not see "Undirected Menu" in element "className:appbar-title" in web browser
	And I verify number $exit_current_loops is less than $max_exit_loops
		Then I wait $wait_short seconds
		If I see "Directed Mode" in element "className:appbar-title" in web browser
			Then I press keys "F1" in web browser
			And I wait $wait_short seconds
		Elsif I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
			Then I press keys "F1" in web browser
			And I wait $wait_short seconds
		EndIf
    	Then I increase variable "exit_current_loops" by 1
	EndWhile

	If I verify number $exit_current_loops is equal to $max_exit_loops
    	Then I fail step with error message "ERROR: Number of attempts to exit directed work has been exceeded"
	EndIf

	And I wait $screen_wait seconds
	And I unassign variables "max_exit_loops,exit_current_loops"

@wip @public
Scenario: Mobile Navigate to Directed Work Menu
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
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(),'Directed Work') and contains(@class,'label')]" in web browser within $max_response seconds
    
Given I "wait for directed work to appear"
	Then I "wait some time for directed work" which can take between $wait_med seconds and $wait_long seconds

@wip @public
Scenario: Mobile Navigate to Cycle Count Menu
#############################################################
# Description: From the Undirected Menu, navigate to the Cycle Count Screen
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

Given I "navigate to the Cycle Count Screen"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(), 'Cycle Count Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Cycle Count Menu" in element "className:appbar-title" in web browser
	And I click element "xPath://span[contains(text(), 'Cycle Count') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Cycle Count Entry" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate to Inventory Transfer Menu
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
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Inventory Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Full Inv Move') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Full Inventory Move" in element "className:appbar-title" in web browser
    
@wip @public
Scenario: Mobile Inventory Status Change Menu
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

Given I "navigate to Mobile Inventory Status Change Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	Given I press keys "F7" in web browser
	Then I click element "xPath://span[contains(text(),'Maint Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Maint Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Status Change') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Status Change" in element "className:appbar-title" in web browser
    
@wip @public
Scenario: Mobile Inventory Display Menu
#############################################################
# Description: Traverse to the Mobile Inventory Display Menu
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

Given I "navigate to Mobile Inventory Display Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Inventory Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Inventory Dsp') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Dsp" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Inventory Location Display Menu
#############################################################
# Description: Traverse to the Mobile Inventory Location Display Menu
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

Given I "navigate to Mobile Inventory Location Display Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Inventory Menu') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Next') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Inventory Menu" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Location Display') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Location Display" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Navigate Quickly to Undirected Menu
#############################################################
# Description: Traverse to the top-level Undirected Menu
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

Given I "navigate Quickly to the Undirected Menu"
    Then I assign "0" to variable "loop_cnt_str"
	And I convert string variable "loop_cnt_str" to integer variable "loop_cnt"

	While I do not see "Undirected Menu" in element "className:appbar-title" in web browser
	And I verify number $loop_cnt is not equal to 25
		Then I press keys "F1" in web browser
		And I wait $screen_wait seconds
		And I increase variable "loop_cnt" by 1
	EndWhile

And I unassign variables "loop_cnt_str,loop_cnt"

#############################################################
# Private Scenarios:
#   None
#############################################################