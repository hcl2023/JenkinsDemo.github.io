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
# Utility: Verify Environment.feature
# 
# Functional Area: Connections
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal, WEB, MOCA, Native, Mobile
#
# Description:
# This Utility/Test Case verifies connections to all WMS interfaces for an instance. These scenarios are executed within this file.
#
# Public Scenarios:
#	- Verify MOCA Connection - Verifies MOCA connection
#	- Verify Terminal Connection - Verifies Terminal login/logout
#	- Verify Web Connection - Verifies Web login/logout
#	- Verify WMS Native Connection - Verifies WMS Native app login/logout
#	- Verify Mobile Connection - Verifies Mobile login/logout
#	- Verify API Connection - Verifies API login
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Verify Environment

Background:
#############################################################
# Description: Imports dependencies, sets up environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"
	
	Given I execute scenario "Verify Environment Imports"
	And I execute scenario "Native App Set Up Environment"

After Scenario:
#############################################################
# Description: Logs out of terminal and purges data.
#############################################################

If I close app
EndIf
If I close web browser
EndIf
If I close MOCA connection
EndIf
If I close terminal
EndIf

@verify-MOCA @public
Scenario: Verify MOCA Connection
#############################################################
# Description: This scenario makes a MOCA connection and verifies a command can be executed with return status
# MSQL Files:
#	None
# Inputs:
#	Required:
#		moca_server_connection - MOCA instance URL set in environment settings
#		moca_credentials - Reference to Cycle credentials for MOCA instance
#	Optional:
#		None
# Outputs:
#	None                        
#############################################################

Given I "connect to MOCA and verify command execution"
	#When I connect to MOCA at $moca_server_connection logged in as $moca_credentials  with password $moca_credentials 
    When I connect to MOCA $moca_server_connection logged in as $moca_credentials
	And I execute MOCA command "list warehouses"
	Then I verify MOCA status is 0

@verify-terminal @public
Scenario: Verify Terminal Connection
#############################################################
# Description: This scenario verifies WMS Terminal log in and log out
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

Given I "verify terminal login/logout"
	When I execute scenario "Terminal Login"
	And I wait $wait_med seconds 
	And I size terminal to 16 lines and 80 columns
	And I execute scenario "Terminal Logout"

@verify-web-ui @public
Scenario: Verify Web Connection
#############################################################
# Description: This scenario verifies WMS Web log in and log out
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

Given I "verify web login/logout"
	When I execute scenario "Web Login"
	And I wait $wait_med seconds 
	And I execute scenario "Web Logout"

@verify-wms-native-app @public
Scenario: Verify WMS Native Connection
#############################################################
# Description: This scenario verifies WMS native app log in and log out
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

Given I "verify WMS native app login/logout"
	When I execute scenario "Native App Login"
	And I wait $wait_med seconds 
	And I execute scenario "Native App Logout"

@verify-mobile @public
Scenario: Verify Mobile Connection
#############################################################
# Description: This scenario verifies WMS Mobile App log in and log out
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

Given I "verify Mobile App login/logout"
	When I execute scenario "Mobile Login"
	And I wait $wait_med seconds 
	And I execute scenario "Mobile Logout"

@verify-api @public
Scenario: Verify API Connection
#############################################################
# Description: This scenario verifies API log in (log out not supported)
#	and also ensures that the user has access to the warehouse
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

Given I "verify API login/logout"
	When I execute scenario "API Verify User Is Authorized for Warehouse"