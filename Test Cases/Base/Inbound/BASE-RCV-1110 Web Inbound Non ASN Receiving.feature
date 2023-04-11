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
# Test Case: BASE-RCV-1110 Web Inbound Non ASN Receiving.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description:
# This Test Case generates an Non-ASN receipt via MSQL and receives it in Web. Capabilitites include serialization.
#
# Input Source: Test Case Inputs/BASE-RCV-1110.csv
# Required Inputs:
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
#	invnum - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
#	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in. Must be a valid and open dock door.
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	prtnum - This needs to be a valid part number that is assigned in your system. Will use the default client_id.
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The number expected
#	rcvqty - The number being received
# 	supnum - A valid supplier
#	rec_loc - A valid receiving location
#	workstation - the workstation to perform the operation on, must be valid
#	asn_flag - TRUE|FALSE to denote ASN receiving - FALSE
# Optional Inputs:
#	lotnum - Lot Number
#	revlvl - Revision Level
#
# Assumptions:
# - Serialized parts supporting CRDL_TO_GRAVE and OUTCAP_ONLY are available to test with
# - This test case is testing receiving where rcvqty and expqty are the same. Not intended
#   to be tested with OSD conditions
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: Non-Serialization Receive, Putaway, and Dispatch - Non ASN, Lot enabled prtnum
#	Example Row: Non-Serialization Receive, Putaway, and Dispatch - Non ASN, Lot and Revision Level enabled prtnum
# 	Example Row: Non-Serialization Receive, Putaway, and Dispatch - Non ASN, Case level
# 	Example Row: Non-Serialization Receive, Putaway, and Dispatch - Non ASN, Each level
#	Example Row: CRDL_TO_GRAVE serialization prtnum being received and requiring serial number captured - Non ASN
#	Example Row: OUTCAP_ONLY serialization prtnum being received (should not require serial numbers to be captured) - Non ASN
#
############################################################
Feature: BASE-RCV-1110 Web Inbound Non ASN Receiving

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Web Receiving Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-RCV-1110" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Receiving" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign $trlr_num to variable "trknum"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Receiving" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1110
Scenario Outline: BASE-RCV-1110 Web Inbound Non ASN Receiving
CSV Examples: Test Case Inputs/BASE-RCV-1110.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Web and navigate to the Inbound Shipments Screen"
	Then I execute scenario "Web Login"
	And I execute scenario "Web Open Inbound Shipments Screen"
    
And I "select a workstation to use"
	Then I execute scenario "Web Select Workstation"

When I "perform receiving"
	Then I execute scenario "Web Perform Receiving"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"