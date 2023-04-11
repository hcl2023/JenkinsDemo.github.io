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
# Utility: Web Yard Utilities.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Web
#
# Description:
# This Utility contains common utility scenarios for Web Yard functionality in the Web
#
# Public Scenarios:
#	- Web Validate Audit Missing Equipment - Will Validate Missing equipment in Yard location
#	- Web Create Audit Work for Yard Location - This scenario will create Audit work for Yard locations
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Web Yard Utilities
	
@wip @public
Scenario: Web Validate Audit Missing Equipment
#############################################################
# Description: This scenario will validate Missing equipment in Yard location
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "verify missing Eequipment in a Yard location"
	If I see element "xPath://span[text()='Missing Equipment']" in web browser within $max_response seconds
		Then I echo "Missing Equipment message was there, proceeding to next steps"
	Else I fail step with error message "ERROR: Validation of missing equipment message in Web failed"
	EndIf
	
@wip @public
Scenario: Web Create Audit Work for Yard Location
#############################################################
# Description: This scenario will create Audit work for Yard locations
# MSQL Files:
#	None
# Inputs:
#	Required:
#		audit_start_loc - Starting location where the yard audit work is to create
#		audit_end_loc - Ending location where the yard audit work is to create
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "select 'Audit' hyperlink in door activity section"  
	When I maximize web browser
	Then I click element "xPath://div[contains(@id,'wm-doorandyardactivity-yardsgrid')]/descendant::a[text()='Audit >']" in web browser within $max_response seconds
    
When I "select start location and end location where Audit work is to create"    
	Then I click element "xPath://input[@name='startLocation']" in web browser within $max_response seconds
	And I type $audit_start_loc in web browser
	And I click element "xPath://input[@name='endLocation']" in web browser within $max_response seconds
	And I type $audit_end_loc in web browser
	And I assign variable "elt" by combining $xPath "//span[text()='OK']/.."
	And I click element $elt in web browser within $max_response seconds
    
And I "confirm Audit work was created for locations by clicking Ok button"   
	Once I see element "xPath://div[contains(text(),'Audit work was created for locations')]" in web browser
	And I click element $elt in web browser within $max_response seconds

#############################################################
# Private Scenarios:
# None
#############################################################