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
# Utility: XML Utilities.feature
# 
# Functional Area: Data Management
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Integrator
#
# Description:
# This utility contains scenarios for working with XML
#
# Public Scenarios:  
# 	- Replace All XML Tag Values - Finds all the occurances of a TAG within an XML string and replaces the tag's value with a passed in value  
#	- Replace XML Tag Value - Finds the first occurance of a TAG within an XML string and replaces the tag's value with a passed in value
#	- Get XML Tag Value - Finds the first occurance of a TAG within an XML string and returns the tag's value
#	- Verify XML Values Are Equal - Verifies that the tag values in two XML strings match based on a set of xml_tags
#	- Verify List of XML Tags and Values - Verify a comma seperated list of values match the a list of XML tags.
#	- Replace List of XML Tags - Alter an XML string by replacing a set of tag values with passed in values. First tag found is changed.
#	- Replace List of All XML Tags - Alter an XML string by replacing a set of tag values with passed in values. All tags found are changed.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: XML Utilities

@wip @public
Scenario: Replace All XML Tag Values
#############################################################
# Description: 
#  Finds all the occurances of a TAG within an XML string and
#  replaces the tag's value with a passed in value
# MSQL Files:
#	None
# Groovy Files: 
#	assign_value_to_all_xml_tags.groovy
# Inputs:
#	Required:
# 		xml	- XML String
# 		tag	- Tag to be searched
# 		new_value - New value for Tag
# 	Optional:
#		None
# Outputs:
# 	new_xml - xml with values replaced
#############################################################

Given I assign "assign_value_to_all_xml_tags.groovy" to variable "groovy_file"
Then I execute scenario "Perform Groovy Execution"

@wip @public
Scenario: Replace XML Tag Value
#############################################################
# Description: 
#  Finds the first occurance of a TAG within an XML string and
#  replaces the tag's value with a passed in value
# MSQL Files:
#	None
# Groovy File: get_value_for_first_xml_tag.groovy
# Inputs:
# 	Required:
# 		xml			- XML String
# 		tag			- Tag to be searched
# 		new_value 	- New value for Tag
#	Optional:
#		None
# Outputs:
#	new_xml - xml with values replaced
##############################################################

Given I assign "assign_value_to_first_xml_tag.groovy" to variable "groovy_file"
Then I execute scenario "Perform Groovy Execution"

@wip @public
Scenario: Get XML Tag Value
#############################################################
# Description: 
#  Finds the first occurance of a TAG within an XML string and returns the tag's value'
# MSQL Files:
#	None
# Groovy Files: 
#	get_value_for_first_xml_tag.groovy
# Inputs:
#	Required:
#		xml	- XML String
#		tag	- Tag to be searched
#	Optional:
#		None
# Outputs:
#	tag_value - Value from xml tag
#############################################################

Given I assign "get_value_for_first_xml_tag.groovy" to variable "groovy_file"
Then I execute scenario "Perform Groovy Execution"

@wip @public
Scenario: Verify XML Values Are Equal
#############################################################
# Description: 
# Verifies that the tag values in two XML strings match based on a set of xml_tags
# MSQL Files:
#	None
# Inputs:
#	Required:
# 		xml_01 - First XML string being compared
# 		xml_02 - Second XML string being compared
# 		xml_tags - comma separated string of xml tags to be compared
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I assign 0 to variable "i"
While I assign $i th item from "," delimited list $xml_tags to variable "tag" 
	And I execute scenario "Get First XML Value"
    And I execute scenario "Get Second XML Value"
    Then I verify text $tag_value_01 is equal to $tag_value_02
    And I increase variable "i"
Endwhile
Then I unassign variable "i"

@wip @public
Scenario: Verify List of XML Tags and Values
##############################################################
# Description: 
# 	Verify a comma seperated list of values match the a list of XML tags.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		xml - XML string
# 		xml_tag_list - Comma seperated list of tags to be replaced
# 		xml_value_list - Comma seperate list of values for tags
# 	Optional:
#		None
# Outputs:
#	None
##############################################################

Given I assign variable "xml_value_list" by combining $xml_value_list ",TERMINATOR"
Given I assign 0 to variable "i"
While I assign $i th item from "," delimited list $xml_tags_list to variable "tag" 
   Given I assign $i th item from "," delimited list $xml_value_list to variable "value" 
   Then I echo $tag $value   
   When I execute scenario "Get XML Tag Value"
   If I verify text $tag_value is equal to $value
   Else I assign variable "error_message" by combining "ERROR: XML Tag " $tag " was not equal to expected value of (" $value ").  Instead it had a value of (" $tag_value ")"
        And I fail step with error message $error_message
   Endif
   And I increase variable "i"
Endwhile
Then I unassign variables "xml_tag_list,xml_value_list,tag,value,tag_value,i"
 
@wip @public
Scenario: Replace List of XML Tags
##############################################################
# Description: Alter an XML string by replacing a set of tag values with passed in values. First tag found is changed.
# MSQL Files:
#	None
# Groovy Files: 
#	assign_value_to_first_xml_tag.groovy
# Inputs:
#	Required:
#		xml - Original XML (warning - this value is altered)
#		xml_tag_list - Comma seperated list of tags to be replaced
#		xml_value_list - Comma seperate list of values for tags
#	Optional:
#		None
# Outputs:
# 	xml - XML with tag values updated
#
#  Working variables that are altered
#    tag, new_value, new_xml
##############################################################

Given I assign variable "xml_value_list" by combining $xml_value_list ",TERMINATOR"
Given I assign 0 to variable "i"
While I assign $i th item from "," delimited list $xml_tags_list to variable "tag"  
   Given I assign $i th item from "," delimited list $xml_value_list to variable "value" 
   Then I echo $tag $new_value
   When I assign "assign_value_to_first_xml_tag.groovy" to variable "groovy_file"
   Then I execute scenario "Perform Groovy Execution"
   Then I assign $new_xml to variable "xml"
   Then I increase variable "i"
Endwhile
Then I unassign variables "xml_tag_list,xml_value_list,new_xml,tag,new_value,i"


@wip @public
Scenario: Replace List of All XML Tags
#############################################################
# Description: Alter an XML string by replacing a set of tag values with passed in values. All tags are changed.
# MSQL Files:
#	None
# Groovy Files: 
#	assign_value_to_all_xml_tags.groovy
# Inputs:
#	Required:
# 		xml - Original XML (warning - this value is altered)
#		xml_tag_list - Comma seperated list of tags to be replaced
# 		xml_value_list - Comma seperate list of values for tags
# 	Optional:
#		None
# Outputs:
#	xml - XML with tag values updated
##############################################################

Given I assign variable "xml_value_list" by combining $xml_value_list ",TERMINATOR"
Given I assign 0 to variable "i"
While I assign $i th item from "," delimited list $xml_tags_list to variable "tag"  
    Given I assign $i th item from "," delimited list $xml_value_list to variable "new_value" 
    Then I echo $tag $new_value
    When I assign "assign_value_to_all_xml_tags.groovy" to variable "groovy_file"
    Then I execute scenario "Perform Groovy Execution"
    Then I assign $new_xml to variable "xml"
    Then I increase variable "i"
Endwhile
Then I unassign variables "xml_tag_list,xml_value_list,new_xml,tag,new_value,i"

#############################################################
# Private Scenarios:
#	Get First XML Value
#	Get Second XML Value
#############################################################

@wip @private
Scenario: Get First XML Value
#############################################################
# Description: 
#   Get the value from an XML tag from an XML string xml_01
# Groovy Files: 
#	get_value_for_first_xml_tag.groovy
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		xml_01 - XML String  
# 	Optional:
#		None
# Outputs:
#	tag_value_01 - Value of tag from xml_01
##############################################################

Given I "assign xml string to xml, get value and return value"
    Given I assign $xml_01 to variable "xml"
    And I assign "get_value_for_first_xml_tag.groovy" to variable "groovy_file"
    When I execute scenario "Perform Groovy Execution"
    Then I assign $tag_value to variable "tag_value_01"

@wip @private
Scenario: Get Second XML Value
#############################################################
# Description: 
#   Get the value from an XML tag from an XML string xml_01
# MSQL Files:
#	None
# Groovy Files: 
#	get_value_for_first_xml_tag.groovy
# Inputs:
# 	Required:
# 		xml_01 - XML String  
#	Optional:
#		None
# Outputs:
#	tag_value_02 - Value of tag from xml_01
##############################################################

Given I "assign xml string to xml, get value and return value"
    Given I assign $xml_02 to variable "xml"
    And I assign "get_value_for_first_xml_tag.groovy" to variable "groovy_file"
    When I execute scenario "Perform Groovy Execution"
    Then I assign $tag_value to variable "tag_value_02"

#############################################################
# Private Scenarios:
#	None
#############################################################