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
# Utility: Import Utilities.feature
# 
# Functional Area: Cycle Testing
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: None
#
# Description:
# This utility contains scenarios for importing sets of files by functional area
#
# Public Scenarios:  
# 	- Terminal Receiving Imports
#	- Mobile Receiving Imports
#	- Web Receiving Imports
#	- Terminal Picking Imports
#	- Mobile Picking Imports
#	- Integration Imports
#	- Work Order Imports
#	- Work Order Mobile Imports
#	- Inventory Inbound Putaway Imports
#	- Trailer Move Imports
#	- Mobile Trailer Move Imports
#	- Wave Imports
#	- Inventory Adjust Imports
#	- Inventory Count Imports
#   - Inventory Transfer Imports
#	- Replenishment Imports
#	- Mobile Replenishment Imports
#	- Web Inbound Trailer Imports
#	- Web Outbound Trailer Imports
#	- Web Outbound Audit Imports
#	- Terminal Count Near Zero Imports
#	- Mobile Count Near Zero Imports
#	- Mobile Inventory Imports
#	- Mobile Count Imports
#	- Terminal Yard Audit Imports
#	- Mobile Yard Audit Imports
#	- Web Yard Audit Imports
#	- Terminal Unloading Imports
#	- Mobile Unloading Imports
#	- Terminal Loading Imports
#	- Mobile Loading Imports
#	- Mobile Pallet Building Imports
#	- Terminal Pallet Building Imports
#	- API Imports
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Import Utilities

@wip @public
Scenario: Terminal Receiving Imports
#############################################################
# Description: Imports Utilities to perform terminal receiving operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Receiving Imports
#############################################################
# Description: Imports Utilities to perform Mobile receiving operations.
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

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Web Receiving Imports
#############################################################
# Description: Imports Utilities to perform web receiving operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Inbound Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Terminal Picking Imports
#############################################################
# Description: Imports Utilities to perform terminal picking operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Carton Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Unpick Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Pallet Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal List Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Picking Imports
#############################################################
# Description: Imports Utilities to perform Mobile picking operations.
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

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Carton Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Carton Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Unpick Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Unpick Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Pallet Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Pallet Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile List Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal List Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Integration Imports
#############################################################
# Description: Imports Utilities to perform integration operations.
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

Given I assign "Integration Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Work Order Imports
#############################################################
# Description: Imports Utilities to perform work order operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Work Order Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Work Order Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Work Order Mobile Imports
#############################################################
# Description: Imports Utilities to perform work order operations for Mobile
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Work Order Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Work Order Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Terminal/Terminal Work Order Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Inventory Adjust Imports
#############################################################
# Description: Imports Utilities to perform inventory adjustment operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Inventory Inbound Putaway Imports
#############################################################
# Description: Imports Utilities to perform an inbound putaway.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Inventory Count Imports
#############################################################
# Description: Imports Utilities to perform inventory count operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Counting Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Inventory Transfer Imports
#############################################################
# Description: Imports Utilities to perform inventory transfer operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Trailer Move Imports
#############################################################
# Description: Imports Utilities to perform trailer move operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Trailer Move Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Trailer Move Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Trailer Move Imports
#############################################################
# Description: Imports Utilities to perform Mobile trailer move operations.
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

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Trailer Move Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Trailer Move Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Wave Imports
#############################################################
# Description: Imports Utilities to perform waving operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Wave Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Outbound Planner Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Outbound Planner Imports
#############################################################
# Description: Imports Utilities to perform waving operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Wave Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Outbound Planner Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Terminal Pallet Building Imports
#############################################################
# Description: Imports Utilities to perform Pallet Building operations.
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

Given I assign "Terminal/Terminal Pallet Building Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Wave Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Pallet Building Imports
#############################################################
# Description: Imports Utilities to perform Mobile Pallet Building operations.
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

Given I assign "Mobile/Mobile Pallet Building Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Pallet Building Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Terminal Loading Imports
#############################################################
# Description: Imports Utilities to perform trailer loading operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Loading Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Loading Imports
#############################################################
# Description: Imports Utilities to perform Mobile trailer loading operations.
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

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Terminal/Terminal Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Loading Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Loading Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Terminal Unloading Imports
#############################################################
# Description: Imports Utilities to perform trailer unloading operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Loading Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Unpick Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Unloading Imports
#############################################################
# Description: Imports Utilities to perform trailer unloading operations for Mobile
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

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Terminal/Terminal Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Loading Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Loading Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Mobile/Mobile Unpick Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Unpick Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"


@wip @public
Scenario: Web Inbound Trailer Imports
#############################################################
# Description: Imports Utilities to perform web inbound trailer operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Inbound Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Replenishment Imports
#############################################################
# Description: Imports Utilities to perform outbound replenishment operations.
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

Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Replenishment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Replenishment Imports
#############################################################
# Description: Imports Utilities to perform Mobile outbound replenishment operations.
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

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Replenishment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Replenishment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Picking Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Web Outbound Trailer Imports
#############################################################
# Description: Imports Utilities to perform web inbound trailer operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Outbound Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Web Outbound Audit Imports
#############################################################
# Description: Imports Utilities to perform web outbound audit operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Outbound Trailer Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Outbound Audit Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Verify Environment Imports
#############################################################
# Description: Imports Utilities to perform a verify environment
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Native App Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "API/API Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "API/API User Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Dynamic Data Imports
#############################################################
# Description: Imports Utilities to perform a Dynamic Management
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

Given I assign "Dynamic Data Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
 
@wip @public
Scenario: Validation Imports
#############################################################
# Description: Imports Utilities to perform Pre and Post Validations
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

Given I assign "Pre Validation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import" 
Given I assign "Post Validation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import" 
Given I assign "Integrator Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import" 
Given I assign  "XML Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import" 

@wip @public
Scenario: Terminal Count Near Zero Imports
#############################################################
# Description: Imports Utilities to perform Terminal Pallet Picking and count near zero operation
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
 
Given I assign "Terminal/Terminal Counting Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Count Near Zero Imports
#############################################################
# Description: Imports Utilities to perform Mobile Pallet Picking and count near zero operation
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

Given I assign "Mobile/Mobile Counting Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Counting Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Terminal Yard Audit Imports
#############################################################
# Description: Imports Utilities to perform Terminal Yard Audit operations.
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

Given I assign "Terminal/Terminal Yard Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Yard Audit Imports
#############################################################
# Description: Imports Utilities to perform Mobile Yard Audit operations.
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

Given I assign "Mobile/Mobile Yard Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Yard Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"


@wip @public
Scenario: Web Yard Audit Imports
#############################################################
# Description: Imports Utilities to perform Web Yard Audit operations.
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

Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Workflow Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Yard Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Inventory Imports
#############################################################
# Description: Imports Utilities to perform Mobile Inventory operations.
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I assign "Terminal/Terminal Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Element Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Web/Web Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: Mobile Count Imports
#############################################################
# Description: Imports Utilities to perform Mobile Inventory operations.
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I assign "Mobile/Mobile Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Navigation Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Counting Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Counting Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Work Assignment Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Terminal/Terminal Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "Mobile/Mobile Serialization Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"

@wip @public
Scenario: API Imports
#############################################################
# Description: Imports Utilities to perform API operations.
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I assign "API/API Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "API/API Item Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "API/API Inventory Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "API/API Receiving Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "API/API User Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"
Given I assign "API/API Yard Utilities.feature" to variable "import_file"
Then I execute scenario "Perform File Import"


#############################################################
# Private Scenarios:
# None
#############################################################