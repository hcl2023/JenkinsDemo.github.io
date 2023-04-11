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
# Utility: Terminal Yard Utilities.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal
#
# Description:
# This Utility contains common scenarios for Terminal Yard Features
#
# Public Scenarios:
#	- Terminal Yard Audit - This Scenario will perform yard audit relative to yard audit type requested
#	
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Terminal Yard Utilities

@wip @public
Scenario: Terminal Yard Audit
#############################################################
# Description: This Scenario will perform yard audit relative
# to yard audit type requested
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		yard_audit_type - type of yard audit scenario to run
#	Optional:
#		None
# Outputs:
#     None
#############################################################

If I verify text $yard_audit_type is equal to "with_trailer" ignoring case
	Then I execute scenario "Terminal Yard Audit With Trailer"
ElsIf I verify text $yard_audit_type is equal to "without_trailer" ignoring case
	Then I execute scenario "Terminal Yard Audit WithOut Trailer"
Else I fail step with error message "ERROR: Invalid option for yard_audit_type"
EndIf

#############################################################
# Private Scenarios:
#	Terminal Yard Audit With Trailer - This Scenario will Perform Audit by passing Trailer
#	Terminal Accept And Exit Yard Audit - This will Accept the Audit and Exit the Audit
#	Terminal Yard Audit WithOut Trailer - This Scenario will Perform Audit without providing any fields
#	Terminal Yard Audit With Missing Trailer - This Scenario will Perform Yard Audit To Location missing Equipment
#############################################################

@wip @private
Scenario: Terminal Yard Audit With Trailer
#############################################################
# Description: This Scenario will Perform Audit by passing Trailer
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		trlr_id - Trailer Number
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "acknowledge directed work"
	Once I see "Audit Equip At" in terminal
	Once I see "Press Enter To Ack" in terminal
	Then I press keys "ENTER" in terminal

Then I "enter the required fields"
	Once I see "Audit Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 7 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 12 in terminal 
	EndIf 
	And I enter $trlr_id in terminal

And I execute scenario "Terminal Accept And Exit Yard Audit"

@wip @private
Scenario: Terminal Accept And Exit Yard Audit
#############################################################
# Description: This will Accept the Audit and Exit the Audit
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "accept the audit"
	Once I see "Accept?" in terminal 
	And I press keys "Y" in terminal
    
Then I "complete the audit"    
	Once I see "Audit Equip" in terminal
	Then I press keys "F6" in terminal
    
And I "exit the audit" 
	Once I see "Exit Audit?" in terminal
	Once I see "(Y|N)" on last line in terminal
	And I press keys "Y" in terminal
	Once I see "Done Auditing" in terminal
	Then I press keys "Y" in terminal

@wip @private
Scenario: Terminal Yard Audit WithOut Trailer
#############################################################
# Description: This Scenario will Perform Audit without providing any fields
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		yard_loc - Yard Location
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "acknowledge directed work"
	Once I see "Audit Equip At" in terminal
	Once I see $yard_loc in terminal
	Once I see "Press Enter To Ack" in terminal
	Then I press keys "ENTER" in terminal

And I "enter the required fields"
	Once I see "Audit Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 7 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 12 in terminal 
	EndIf
	Then I press keys "ENTER" in terminal
	And I press keys "ENTER" in terminal

And I execute scenario "Terminal Accept And Exit Yard Audit"

@wip @private
Scenario: Terminal Yard Audit With Missing Trailer
#############################################################
# Description: This Scenario will Perform Yard Audit To Location missing Equipment
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		trlr_id - Trailer Number
#		carcod - Carrier Code
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "acknowledge directed work"
	Once I see "Audit Equip At" in terminal
	Once I see $audit_end_loc in terminal
	Once I see "Press Enter To Ack" in terminal
	Then I press keys "ENTER" in terminal

And I "enter the trailer Number"
	Once I see "Audit Equip" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 7 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 12 in terminal 
	EndIf 
	Then I enter $trlr_id in terminal
	And I enter $carcod in terminal

And I execute scenario "Terminal Accept And Exit Yard Audit"