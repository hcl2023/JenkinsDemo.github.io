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
# Utility: Web Element Utilities.feature
# 
# Functional Area: Web
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Web
# 
# Description:
# This Utiity implements Web element support scenarios used with Web
# 
#  Public Scenarios: 
#	- Web Set Up xPath - This scenario builds common xPath identifiers into Cycle variables
#	- Web xPath for Span Text - This scenario builds the base structure for using the span xPath
#	- Web xPath Add Sibling - This scenario adds the xPath sibling, [2]
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Web Element Utilities

@wip @public
Scenario: Web Set Up xPath
#############################################################
# Description: This scenario builds common xPath identifiers into Cycle variables
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	See variable list below                       
#############################################################

Given I "set 'global' xPath variable names"
	Then I assign "xPath:" to variable "elt"
	And I assign "TRUE" to variable "xpClose"
	
When I "need partial xPath statements to include in more complex xPaths"
	Then I assign variable "xp_span_OK" by combining "//span[text()='OK']"
	And I assign variable "xp_span_Actions" by combining "//span[text()='Actions']"
	And I assign variable "xp_span_Copy" by combining "//span[text()='Copy']"
	And I assign variable "xp_span_Delete" by combining "//span[text()='Delete']"
	And I assign variable "xp_span_Finish" by combining "//span[text()='Finish']"
	And I assign variable "xp_span_Next" by combining "//span[text()='Next']"
	And I assign variable "xp_span_Save" by combining "//span[text()='Save']"
	And I assign variable "xp_span_Search" by combining "//span[text()='Search']"
	And I assign variable "xp_span_Workstation" by combining "//span[text()='Workstation']"
	And I assign variable "xp_span_sibling" by combining "/..//span[2]"

Then I "want Full stand-alone xPath statements (built from partial statements)"
	And I assign variable "xPath_span_OK" by combining $xPath $xp_span_OK
	And I assign variable "xPath_span_OK_sibling" by combining $xPath_span_OK $xp_span_sibling
	And I assign variable "xPath_span_Actions" by combining $xPath $xp_span_Actions
	And I assign variable "xPath_span_Copy" by combining $xPath $xp_span_Copy
	And I assign variable "xPath_span_Delete" by combining $xPath $xp_span_Delete
	And I assign variable "xPath_span_Finish" by combining $xPath $xp_span_Finish
	And I assign variable "xPath_span_Next" by combining $xPath $xp_span_Next
	And I assign variable "xPath_span_Search" by combining $xPath $xp_span_Search
	And I assign variable "xPath_span_Search_sibling" by combining $xPath_span_Search $xp_span_sibling
	And I assign variable "xPath_span_Workstation" by combining $xPath $xp_span_Workstation
	And I assign variable "xPath_wms_workstation" by combining $xPath_span_Workstation "//..//span[@role='presentation']"
	And I assign variable "xPath_hyperlink_breadcrumb" by combining $xPath "//a[starts-with(@id,'rpHyperLinkBreadCrumb-')]"
	
@wip @public
Scenario: Web xPath for Span Text
#############################################################
# Description: This scenario builds the base structure for using the span xPath
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	element - Type of xPath structure ex. span,div                       
#############################################################

Given I assign "span" to variable "element"
Then I execute scenario "Web xPath for Element Text"

@wip @public 
Scenario: Web xPath Add Sibling
#############################################################
# Description: This scenario adds the xPath sibling, [2]
# MSQL Files:
#	None
# Inputs:
#	Required:
#		elt - xPath element string
#		element - Type of xPath structure ex. span,div
# 	Optional:
#		None
# Outputs:
#	elt - xPath element string                       
#############################################################

Given I "actually want the sibling of the last element"
	Then I assign variable "elt" by combining $elt "/..//" $element "[2]"
	
#############################################################
# Private Scenarios:
#	Web xPath for Div Text - This scenario builds the base structure for using the div xPath
#	Web xPath for Element Text - This scenario builds the base structure for using all elements xPath
#	Web xPath Initialize - This scenario builds the base structure for closing an xPath
#	Web xPath Initialize No Close - This scenario builds the base structure for not closing an xPath
#	Web xPath Add Element Kwd Value - This scenario builds the base structure for using a keyword and value
#	Web xPath Add Open Element - This scenario builds the base structure for a complex xPath
#	Web xPath Add And Clause - This scenario adds an And clause to complex xPath
#	Web xPath Add Kwd Starts With Clause - This scenario builds the base structure for using a keyword and starts with value
#	Web xPath Add Kwd Contains Clause - This scenario builds the base structure for using a keyword and contains value
#	Web xPath Close - This scenario adds the termination bracket to the xPath and sets xpClose = TRUE
#	Web xPath Close and Continue - This scenario adds the termination bracket to the xPath and leave xPath open
#############################################################

@wip @private 
Scenario: Web xPath for Div Text
#############################################################
# Description: This scenario builds the base structure for using the div xPath
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	element - Type of xPath structure ex. span,div                        
#############################################################

Given I assign "div" to variable "element"
Then I execute scenario "Web xPath for Element Text"

@wip @private 
Scenario: Web xPath for Element Text
#############################################################
# Description: This scenario builds the base structure for using all elements xPath
# MSQL Files:
#	None
# Inputs:
#	Required:
#		xPath - xPath string
#		element - Type of xPath structure ex. span,div
#		text - Value to match. Set in functionality Utility.
#		xpClose - TRUE = terminate string, FALSE = do not terminate string
#	Optional:
#		None
# Outputs:
#	elt - xPath element string                        
#############################################################

Given I "have $element and the $text to find"
	Then I assign variable "elt" by combining $xPath "//" $element "[text()='" $text "'"
	If I verify text $xpClose is equal to "TRUE" ignoring case
		Then I assign variable "elt" by combining $elt "]"
	EndIf

@wip @private
Scenario: Web xPath Initialize
#############################################################
# Description: This scenario builds the base structure for an xPath
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	elt - xPath element string
#	xpClose - TRUE = terminate string, FALSE = do not terminate string                       
#############################################################

Given I assign $xPath to variable "elt"
Then I assign "TRUE" to variable "xpClose"

@wip @private
Scenario: Web xPath Initialize No Close
#############################################################
# Description: This scenario builds the base structure for not closing an xPath
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	elt - xPath element string
#	xpClose - TRUE = terminate string, FALSE = do not terminate string                      
#############################################################

Given I assign $xPath to variable "elt"
Then I assign "FALSE" to variable "xpClose"

@wip @private 
Scenario: Web xPath Add Element Kwd Value
#############################################################
# Description: This scenario builds the base structure for using a keyword and value
# MSQL Files:
#	None
# Inputs:
#	Required:
#		elt - xPath element string
#		element - Type of xPath structure ex. span,div
#		kwd - Keyword for the type of identifier ex. text
#		value - Value for the identifier
#	Optional:
#		None
# Outputs:
#	elt - xPath element string             
#############################################################

Then I assign variable "elt" by combining $elt "//" $element "[@" $kwd "='" $value "'"
If I verify text $xpClose is equal to "TRUE" ignoring case
	Then I assign variable "elt" by combining $elt "]"
EndIf

@wip @private 
Scenario: Web xPath Add Open Element
#############################################################
# Description: This scenario builds the base structure for a complex xPath
# MSQL Files:
#	None
# Inputs:
#	Required:
#		elt - xPath element string
#		element - Type of xPath structure ex. span,div
#	Optional:
#		None
# Outputs:
#	elt - xPath element string                      
#############################################################

Given I "only want to start a complex xPath statement. Note: Requires $elt to be in a proper state to start a new element"
	Then I assign variable "elt" by combining $elt "//" $element "["

@wip @private 
Scenario: Web xPath Add And Clause
#############################################################
# Description: This scenario adds an And clause to complex xPath
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		elt - xPath element string
#		xpClose - TRUE = terminate string, FALSE = do not terminate string
#	Optional:
#		None
# Outputs:
#	elt - xPath element string                        
#############################################################

Given I "only want to continue a complex xPath statement. Note: Requires $elt to be in a proper state to start a new element"
	Then I assign variable "elt" by combining $elt " and "
	If I verify text $xpClose is equal to "TRUE" ignoring case
		Then I assign variable "elt" by combining $elt "]"
	EndIf

@wip @private 
Scenario: Web xPath Add Kwd Starts With Clause
#############################################################
# Description: This scenario builds the base structure for using a keyword and starts with value
# MSQL Files:
#	None
# Inputs:
#	Required:
#		elt - xPath element string
#		kwd - Keyword for the type of identifier ex. text
#		value - Value for the identifier
#		xpClose - TRUE = terminate string, FALSE = do not terminate string
#	Optional:
#		None
# Outputs:
#	elt - xPath element string                       
#############################################################

If I verify text $kwd is equal to "text" ignoring case
	Then I assign "text()" to variable "inkwd"
Else I assign variable "inkwd" by combining "@" $kwd
EndIf

When I assign variable "elt" by combining $elt "starts-with(" $inkwd ",'" $value "')"

If I verify text $xpClose is equal to "TRUE" ignoring case
	Then I assign variable "elt" by combining $elt "]"
EndIf

@wip @private 
Scenario: Web xPath Add Kwd Contains Clause
#############################################################
# Description: This scenario builds the base structure for using a keyword and contains value
# MSQL Files:
#	None
# Inputs:
#	Required:
#		elt - xPath element string
#		kwd - Keyword for the type of identifier ex. text
#		value - Value for the identifier
#		xpClose - TRUE = terminate string, FALSE = do not terminate string
#	Optional:
#		None
# Outputs:
#	elt - xPath element string                       
#############################################################

If I verify text $kwd is equal to "text" ignoring case
	Then I assign "text()" to variable "inkwd"
Else I assign variable "inkwd" by combining "@" $kwd
EndIf

When I assign variable "elt" by combining $elt "contains(" $inkwd ",'" $value "')"

If I verify text $xpClose is equal to "TRUE" ignoring case
	Then I assign variable "elt" by combining $elt "]"
EndIf

@wip @private 
Scenario: Web xPath Close
#############################################################
# Description: This scenario adds the termination bracket to the xPath and sets xpClose = TRUE
# MSQL Files:
#	None
# Inputs:
#	Required:
#		elt - xPath element string
#		xpClose - TRUE = terminate string, FALSE = do not terminate string
#	Optional:
#		None
# Outputs:
#	elt - xPath element string
#	xpClose - TRUE = terminate string, FALSE - do not terminate string                        
#############################################################

Given I "need to force the xPath closed"
	If I verify text $xpClose is equal to "FALSE" ignoring case
		Then I assign variable "elt" by combining $elt "]"
	EndIf 
	Then I assign "TRUE" to variable "xpClose"

@wip @private 
Scenario: Web xPath Close and Continue
#############################################################
# Description: This scenario adds the termination bracket to the xPath and leave xPath open
# MSQL Files:
#	None
# Inputs:
#	Required:
#		elt - xPath element string
#	Optional:
#		None
# Outputs:
#	elt - xPath element string                       
#############################################################

Given I "need to force the xPath closed but save the xpClose state for new element"
	Then I assign variable "elt" by combining $elt "]"