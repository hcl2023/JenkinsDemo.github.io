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
# Test Case: BASE-SHP-1060 Web Outbound Create Order.feature
#
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This test case will create a order and single order line in the Web
#
# Input Source: Test Case Inputs/BASE-SHP-1060.csv
# Required Inputs:
#	ordnum - order number you want to use during creation of order
#	ordlin - order line you want to use during creation of an order line
#	prtnum - part number in the order line
#	untqty - quantity of prtnum in the order line
#	alloc_profile - allocation profile UI field input
#	carcod - carrier code field input
#	project_number - project number field input
#	dstloc - destination location field input
#	res_pri - reservation priority field input
#	ftp_dtl - part foot print detail field input
#	cert_origin - certificate of origin field input
#	ui_ordtyp - the Web representation of the order type
#	cstnum - csutomer ID field value
#	cust_po - customer PO field value
#	create_ship_by - create shipment by field value
#	deliver_num - devlivery number field value
#	ord_note - text for creating note for order
# Optional Inputs:
#	None
#
# Assumptions:
# None
#
# Notes:
# None
# 
############################################################ 
Feature: BASE-SHP-1060 Web Outbound Create Order
 
Background: 
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Outbound Planner Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-SHP-1060" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "cleanup the dataset, since there was no initial dataset to load"
	Then I assign "Web_Outbound_Trailer_Common" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
    
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Outbound_Trailer_Common" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-SHP-1060
Scenario Outline: BASE-SHP-1060 Web Outbound Create Order
CSV Examples: Test Case Inputs/BASE-SHP-1060.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web and navigate to Outbound Screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Navigate to Outbound Planner Outbound Screen"
    
When I "create the oder and order line"
	Then I execute scenario "Web Create Order"
    
And I "validate order has been created"
	Then I execute scenario "Validate Order Created"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"