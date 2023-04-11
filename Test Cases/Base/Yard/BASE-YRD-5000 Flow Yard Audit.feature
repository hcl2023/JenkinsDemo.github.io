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
# Test Case: BASE-YRD-5000 Flow Yard Audit.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: Terminal, Web, MOCA
#
# Description:
# Test case for Yard Audit scenarios starting in the Web and completing in the terminal 
#
# Input Source: Test Case Inputs/BASE-YRD-5000.csv
# Required Inputs:
#	trlr_id - This will be used as the trailer ID for the trailer
#	carcod - This will be used as the carrier for the shipment
#	yard_loc - Yard Location
#	trlr_cod - Transport Equipment Code
#	audit_start_loc - Starting location from the Yard Audit
#	audit_end_loc - End location of Yard Audit Audit
#	vehtyp - Vehicle Type
#	yard_audit_type - Type of Yard Audit, either with_trailer Or without_trailer
# Optional Inputs:
# None
#
# Assumptions:
# None
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: Successful Yard Audit of a single yard location
#	Example Row: Yard Audit of first location fails, trailer then found in Audit of second location
#
############################################################
Feature: BASE-YRD-5000 Flow Yard Audit
 
Background:
#############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"
	
	Given I execute scenario "Trailer Move Imports"
	Then I execute scenario "Terminal Yard Audit Imports"
	And I execute scenario "Web Receiving Imports"
	And I execute scenario "Web Yard Audit Imports"
	And I execute scenario "Web Environment Setup" 

	Then I assign "BASE-YRD-5000" to variable "test_case"
	And I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Create_Trailer" to variable "dataset_directory"    
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the inteface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
	
And I "cleanup the dataset"
	Then I assign "Create_Trailer" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-YRD-5000
Scenario Outline: BASE-YRD-5000 Flow Yard Audit
CSV Examples: Test Case Inputs/BASE-YRD-5000.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to web and open receiving Door Activity Screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Receiving Door Activity Screen" 
      
And I "create audit work for yard location"    
	Then I execute scenario "Web Create Audit Work for Yard Location"
       
And I "open Receiving work queue screen, assign user to work queue and logout of the web"    
	Then I execute scenario "Web Open Receiving Work Queue Screen"
	If I verify text $yard_audit_type is equal to "without_trailer" ignoring case
    	Then I "assign work for starting and ending location audits to user"
			And I assign $audit_end_loc to variable "yard_loc"
			And I execute scenario "Web Assign User to Work Queue"
			And I wait $wait_med seconds
			And I assign $audit_start_loc to variable "yard_loc"
			And I execute scenario "Web Assign User to Work Queue"
	Else I execute scenario "Web Assign User to Work Queue"
	EndIf
	And I execute scenario "Web Logout"
    
And I "open terminal and navigate to the directed work screen"
	Then I execute scenario "Terminal Login"
	And I execute scenario "Terminal Navigate to Directed Work Menu"
    
And I "check for directed work and process Yard Audit"
	Then I execute scenario "Terminal Yard Audit"

And I "verify Audit missing equipment is present in Web and perform Audit with missing trailer"
	If I verify text $yard_audit_type is equal to "without_trailer" ignoring case
		Then I execute scenario "Web Login"
		And I execute scenario "Web Open Receiving Door Activity Screen" 
		And I execute scenario "Web Validate Audit Missing Equipment"
		And I execute scenario "Web Logout"
		And I execute scenario "Terminal Yard Audit With Missing Trailer"
	EndIf

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"