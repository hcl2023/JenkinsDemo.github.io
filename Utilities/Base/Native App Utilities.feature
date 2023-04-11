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
# Utility: Native App Utilities.feature
# 
# Functional Area: Native App
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: MOCA, Native
#
# Description:
# This Utility contains scenarios for interaction with the WMS Native App client
#
# Public Scenarios:
#	- Native App Login - Logs in to the WMS Native App client
#	- Native App Logout - Logs out of the WMS Native App client
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Native App Utilities

@wip @public
Scenario: Native App Login
#############################################################
# Description: This scenario logs in to the WMS native app client
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		ui_path - Path to native app executable. Set in environment file.
#		server - WMS instance URL. Set in environment file.
#		moca_credentials - Name of Cycle credentials for login. Set in environment file.		
#	Optional:
#		None
# Outputs:
#	None                   
#############################################################

Given I "open native app"
	When I open app "WMS Solutions" at $ui_path within $wait_med seconds 
	Then I connect to app "WMS Solutions" with locator $wms_login_dialog_window 
	Once I see object $wms_login_service_url_field in app
	
Given I "enter instance url"
	When I type $server in object $wms_login_service_url_field in app
	And I click object $wms_login_go_button in app
	
When I "switch to Login Dialog"
	When I connect to app "WMS Solutions" with locator $wms_login_dialog_window within $max_response seconds
	Once I see value "Connected..." is contained in object $wms_login_status_label in app
	Then I type USERNAME from credentials $moca_credentials in object $wms_login_username_field in app
	And I type PASSWORD from credentials $moca_credentials in object $wms_login_password_field in app
	And I execute scenario "Native App Login Warehouse"
	And I click object "name:Sign in" in app within $wait_long seconds 

Then I "connect to the WMS WMS Window"
	If I connect to app "WMS Solutions" with locator $wms_dlx_window within $max_response seconds 
		Then I echo "At the main WMS Screen" 
	Else I echo "Main screen did not appear - Asking about device?"
		If I verify number $temp is equal to 0
		And I see object $wms_post_login_prompt in app within $wait_med seconds 
			Then I click object $wms_no_button in app
			And I assign 1 to variable "temp"
			And I connect to app "WMS Solutions" with locator $wms_dlx_window within $wait_med seconds 
		EndIf
	EndIf
	Once I see object $wms_post_login_verification_object in app
 
@wip @public
Scenario: Native App Logout
#############################################################
# Description: This scenario logs out of the WMS native app client
# MSQL Files:
#	None
# Inputs:
#	Required:
# 		None
# 	Optional:
# 		None
# Outputs:
# 	None                   
#############################################################
   
Given I "initiate app close"
	Then I press keys "ALT+F4" in app
	
Then I "handle close dialogues"    
	If I see object $wms_logout_regen_wh_msg in app within $wait_med seconds 
	   Then I press keys "ENTER" in app
	Elsif I see object $wms_logout_done_for_day_msg in app within $wait_med seconds 
	   Then I click object $wms_yes_button in app
	Endif
	
############################################################
# Private Scenarios:
#	Native App Maximize App - maximizes the app
#	Native App Minimize App - minimizes the app
#	Native App Login Warehouse - switches to the correct warehouse
#	Native App Set Up Environment - sets up Native App locators
#############################################################

@wip @private
Scenario: Native App Maximize App
#############################################################
# Description: This scenario maximizes the WMS native app client
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
If I click object $wms_maximize_button in app within $wait_med seconds
EndIf

@wip @private
Scenario: Native App Minimize App
#############################################################
# Description: This scenario minimizes the WMS native app client
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
# 	Optional:
#		None
# Outputs:
#	None                
#############################################################
If I click object $wms_minimize_button in app within $wait_med seconds
EndIf

@wip @private
Scenario: Native App Login Warehouse
#############################################################
# Description: This scenario logs in to the appropriate wh if multi-wh
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		multi-warehouse - Flag indicating instance is multi warehouse for input
# 	Optional:
# 		None
# Outputs:
#	None             
#############################################################

Given I "check for multi warehouse"
	If I verify variable "multi_warehouse" is assigned
	And I verify number $multi_warehouse is equal to 1
	  	Given I click object $wms_login_wh_combo_box in app within $wait_med seconds 
	  	And I press keys "Alt+Down" in app
	  	And I assign variable "wms_wh_login_selection_object" by combining "name:" $wh_id " Warehouse"
	  	When I double click object $wms_wh_login_selection_object in app within $wait_med seconds 
	  	And I press keys Tab in app
	Endif
	
@wip @private
Scenario: Native App Set Up Environment
#############################################################
# Description: This scenario loads a CSV file containing common screen locators
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
# 	Optional:
#		None
# Outputs:
#	None
#############################################################    

Given I "load a CSV file containing variable / value pairs and assigns each to a cycle variable"
	Then I assign "Native App Screen Locators.csv" to variable "locator_csv"
	And I execute scenario "Perform Load of Native App Locator CSV"