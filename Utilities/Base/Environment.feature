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
# Utility: Environment.feature
#
# Functional Area: Environment Setup
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: MOCA, Integrator
# 
# Description:
# Utilities for setting up cycle environment and moca environment variable
# needed to run tests. Includes logic to support Test specific overrides
# and environment specific overrides.
# 
# Public Scenarios:  
#	- Set Up Environment - Setup environment variables for test
#	- Perform File Import - Import feature files supporting code customizations
#	- Perform MSQL Execution - Execute a MSQL script supporting code customizations
#	- Perform SQL Execution - Execute a SQL script supporting code customizations
#	- Perform Groovy Execution - Execute a groovy script supporting code customizations
#	- Perform MOCA Cleanup Script - Execute a MOCA cleanup supporting code customizations
#	- Perform MOCA Dataset -  Execute a MOCA dataset supporting code customizations
#	- Perform SQL Cleanup Script - Execute a SQL cleanup supporting code customizations
#	- Perform SQL Dataset -  Execute a SQL dataset supporting code customizations
#	- Locate File on Path - Find a file in the directory supporting code customizations
#	- Test Completion - Cleanup interface connections and hook for general test cleanup
#	- Test Completion Triggers - Hook for any future test completion activities
#	- Perform Integration Load and Process Transaction File - Load and process integrator file
#	- Perform Load of Native App Locator CSV - Load Native App Locator CSV file contents to variables
#	- Perform Load of API Field Mappings - Determine the path to the CSV file used for DB-to-API field mappings, load mappings into memory
#	- Get WMS Version - Get the version of the instance the bundle is interacting with
#
# Assumptions:
# 	None
#
# Notes:
# 	None
#
############################################################ 

Feature: Environment

@wip @public
Scenario: Set Up Environment
#############################################################
# Description: 
# Utility for setting up cycle environment and moca environment variable
# needed to run tests. Includes logic to support Test specific overrides
# and environment specific overrides. Values are only assigned if the variable 
# is unassigned
#
# Call this scenario in test case Background: 
# 
# Values can be overwritten by individual tests by assigning variables
# as test inputs
# 
# Basic Logic
#  1-Determine Environment by either receiving $environment as test input, from Windows OS Environment variable,
#    or reading value from Environments/Environment.csv
#  2-Load any variable/value pairs from the environment override files
#     This is intended for each tester to be able to set their own device 
#     and users or other tester or test specific override settings
#     -> Values override any previous value set!
#     2.a - Load variable/values pairs from Environments/<ENV>/<ENV>_Environment_Override_<WH_ID>.csv
#     2.b - Load variable/values pairs from Environments/<ENV>/<ENV>_Environment_Override.csv
#     2.c - Load variable/values pairs from Environments/Environment_Override_<WH_ID>.csv
#     2.d - Load variable/values pairs from Environments/Environment_Override.csv
#     2.e - Load variable/values pairs from Environments/<ENV>/<ENV>_Environment_Override_CI.csv
#  3-Load the variable/values pairs from the csv file located at
#    Environments/<ENV>/<ENV>_Environment_<WH_ID>.csv and create cycle variables
#    Environments/<ENV>/<ENV>_Environment.csv and create cycle variables
#    -> Values are only assigned if the variable is unassigned
#  4 - Load "Timing" variables
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
# 	Optional:
#		environment - If set, this value is used as the environment setting
# Outputs:
#	All environment variables
#	All directory locations (raw, with designations to abstract BASE and Custom locations):
#       utilities_directory_location - location of the Utility directory
# 		msql_directory_location - location of MSQL files directory
# 		sql_directory_location - location of SQL files directory
#		groovy_directory_location - location of Groovy files directory
#		dataset_directory_location - location of Datasets directory
#		playlists_directory_location - location of Playlists directory
#		test_cases_directory_location - location of Test Cases directory
#		native_app_locators_directory_location - location of native app locators
#		api_data_directory_location - location of API data
#		serial_numbers_directory_location - location of serial numbers for serialization
#		interfaces_directory_location - location of Interfaces for integration testing
#		test_case_inputs_directory_location - location of Test Case Inputs
#		environments_directory_location - Location of Environments directory
#############################################################

Given I "read BUNDLE_CI_ENVIRONMENT from Windows OS Environment variable and set to environment if found"
	Then I assign "" to variable "bundle_ci_environment" 
	And I assign OS environment variable "BUNDLE_CI_ENVIRONMENT" to variable "bundle_ci_environment"
	If I verify variable "bundle_ci_environment" is assigned
	And I verify text $bundle_ci_environment is not equal to ""
		Then I assign $bundle_ci_environment to variable "environment"
	EndIf

Then I "resolve the environment to be used by the test case or Environment variable"
	If I verify variable "environment" is assigned
	And I verify text $environment is not equal to ""
		Then I echo "The environment is set by the test case input or environment variable. Value is " $environment
	ElsIf I assign values in row 1 from "Environments/Environment.csv" to variables
		Then I echo "The environment is set by the environment CSV file.  Value is " $environment
	Else I assign variable "error_message" by combining "ERROR: Environment not specified in Test Input or Configuration "
		Then I fail step with error message $error_message
	Endif
    And I assign variable "environment_directory" by combining "Environments/" $environment
    
And I "load any CI/Pipleine specific environment override variables"
	If I verify variable "bundle_ci_environment" is assigned
	And I verify text $bundle_ci_environment is not equal to ""
		When I assign variable "environment_file" by combining $environment_directory "/" $environment "_Environment_Override_CI" ".csv"
		If I verify file $environment_file exists
			Then I execute scenario "Load Environment File"
		EndIf
EndIf
    
Then I "load any warehouse and environment specific override variable"
	If I verify variable "wh_id" is assigned
    And I verify text $wh_id is not equal to ""
        When I assign variable "environment_file" by combining $environment_directory "/" $environment "_Environment_Override_" $wh_id ".csv"
        If I verify file $environment_file exists
            Then I execute scenario "Load Environment File"
        EndIf	
    EndIf
    
Then I "load any environment specific override variable"
	When I assign variable "environment_file" by combining $environment_directory "/" $environment "_Environment_Override.csv"
	If I verify file $environment_file exists
		Then I execute scenario "Load Environment File"
	EndIf
    
And I "load any environment independent but warehouse specific override variables"
	If I verify variable "wh_id" is assigned
    And I verify text $wh_id is not equal to ""
        When I assign variable "environment_file" by combining "Environments/Environment_Override_" $wh_id ".csv"
        If I verify file $environment_file exists
            Then I execute scenario "Load Environment File"
        EndIf  	
    EndIf
    
And I "load any environment independent override variables"
	When I assign "Environments/Environment_Override.csv" to variable "environment_file" 
	If I verify file $environment_file exists
		Then I execute scenario "Load Environment File"
	EndIf    

And I "load all the variables for the environment from the warehouse specific environment CSV file"
	If I verify variable "wh_id" is assigned
    And I verify text $wh_id is not equal to ""
        When I assign variable "environment_file" by combining $environment_directory "/" $environment "_Environment_" $wh_id ".csv"
        If I verify file $environment_file exists
            Then I execute scenario "Load Environment File"
        EndIf
	Endif

And I "load all the variables for the environment from the environment CSV file"
	When I assign variable "environment_file" by combining $environment_directory "/" $environment "_Environment.csv"
	If I verify file $environment_file exists
		Then I execute scenario "Load Environment File"
	Else I assign variable "error_message" by combining "ERROR: Environment CSV file does not exist for environment " $environment
		Then I fail step with error message $error_message
	EndIf

And I "setup directory locations to MSQL, SQL, Groovy, Datasets, Imports, and other locations"
	Then I assign value "Utilities/-/" to unassigned variable "utilities_directory_location"
	And I assign value "Scripts/MSQL_Files/-/" to unassigned variable "msql_directory_location"
    And I assign value "Scripts/SQL_Files/-/" to unassigned variable "sql_directory_location"
	And I assign value "Scripts/Groovy/-/" to unassigned variable "groovy_directory_location"
	And I assign value "Datasets/-/" to unassigned variable "dataset_directory_location"
	And I assign value "Playlists/-/" to unassigned variable "playlists_directory_location"
	And I assign value "Test Cases/-/" to unassigned variable "test_cases_directory_location"
	And I assign value "Test Case Inputs/" to unassigned variable "test_case_inputs_directory_location"
    And I assign value "Test Case Validations/-/" to unassigned variable "test_case_validations_directory_location"
	And I assign value "Environments/" to unassigned variable "environments_directory_location"
	And I assign value "Data/Locators/Native App Locators/-/" to unassigned variable "native_app_locators_directory_location"
	And I assign value "Data/Serial Numbers/" to unassigned variable "serial_numbers_directory_location"
	And I assign value "Data/Interfaces/-/" to unassigned variable "interfaces_directory_location"
    And I assign value "Data/Dynamic Data/-/" to unassigned variable "dynamic_data_directory_location"
	And I assign value "Data/API/-/" to unassigned variable "api_data_directory_location"
    And I copy project directory path to variable "project_directory_location"

And I "setup the directory_load_path and import the Import Utilities feature"
	Then I assign value "Custom,Base" to unassigned variable "directory_load_path"
	And I assign "Import Utilities.feature" to variable "import_file"
	When I execute scenario "Perform File Import"

Given I "establish the MOCA connection here before any queries or MOCA steps start"
	If I verify variable "moca_server_connection" is assigned
	And I verify text $moca_server_connection is not equal to ""
		#Then I connect to MOCA at $moca_server_connection logged in as $moca_credentials with password $moca_credentials 
       Then I connect to MOCA $moca_server_connection logged in as $moca_credentials
	EndIf
    
Given I "establish the database connection here before any queries or SQL steps start"
	If I verify variable "db_server_connection" is assigned
	And I verify text $db_server_connection is not equal to ""
		Then I connect to database $db_server_connection logged in as $db_server_credentials
	EndIf

And I "set prt_client_id if not set already"
	If I verify variable "prt_client_id" is assigned
	Else I assign $client_id to variable "prt_client_id"
	EndIf

And I "default the create and cleanup dataset settings"
	Given I assign value "TRUE" to unassigned variable "create_data"
	And I assign value "TRUE" to unassigned variable "cleanup_data"

And I "load the data management utilities"
	When I assign "Data Management Utilities.feature" to variable "import_file"
    Then I execute scenario "Perform File Import"
    
And I "default the Pre and Post validations settings and load utility"
	Given I assign value "TRUE" to unassigned variable "pre_validations"
 	And I assign value "TRUE" to unassigned variable "post_validations"
	If I verify text $pre_validations is equal to "FALSE"
	And I verify text $post_validations is equal to "FALSE"
	Else I "import the validation utility files"
		Then I execute scenario "Validation Imports"     
	EndIf
    
And I "default the dynamic data settings and load utility"
	Given I assign value "FALSE" to unassigned variable "dynamic_data"
	If I verify text $dynamic_data is equal to "TRUE" ignoring case
		Then I execute scenario "Dynamic Data Imports"
	EndIf

And I "setup all the wait time variables"
	Then I execute scenario "Setup Wait Times"

And I "setup all the HTTP status code variables"
	Then I execute scenario "Setup HTTP Status Codes"

And I "initialize the API framework"
	Then I execute scenario "Perform Load of API Field Mappings"

And I "gather the WMS version and record in logs"
	Then I execute scenario "Get WMS Version"

@wip @public
Scenario: Perform File Import
###################################################################
# Description:  Import a feature file following the directory load path.   
#				Matching files are loaded from all the directories 
#				in reverse directory_load_path sequence so that 
#               the versions earlier in the load path overwrite 
#               the versions listed later in the load path
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		import_file - The relative path of the file being imported with /-/ denoting the directory substitution position	
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#	Optional:
#		None
# Outputs:
#	None
#
# Notes:
# - The first time this scenario runs a variable "feature_load_path" 
# - is created which holds the directory_load_path in reverse order
###################################################################

Given I "adjust import_file to location relative to utilities location"
	Then I assign variable "full_path_import_file" by combining $utilities_directory_location $import_file
	And I unassign variable "import_file"
	And I assign $full_path_import_file to variable "import_file"
   
And I "create feature_load_path, in reverse order of directory_load_path, if it does not exists yet"
	If I verify variable "feature_load_path" is assigned
	Else I "create a feature_load_path in reverse order"
		Given I assign 1 to variable "import_loop"
		While I assign $import_loop th item from "," delimited list $directory_load_path to variable "directory"
		   If I verify variable "feature_load_path" is assigned
			  Then I assign variable "feature_load_path" by combining $directory "," $feature_load_path  
		   Else I assign $directory to variable "feature_load_path"
		   EndIf
		   And I increase variable "import_loop"
		Endwhile   
	EndIf

When I "import files"
	Given I assign 1 to variable "import_loop"
    And I assign "FALSE" to variable "file_imported"
	While I assign $import_loop th item from "," delimited list $feature_load_path to variable "directory"
	   Given I assign variable "directory_token" by combining "/" $directory "/"
	   Given I execute Groovy "new_import_file = import_file.replaceAll('/-/', directory_token).replaceAll('\\\\-\\\\', directory_token)"
	   If I verify file $new_import_file exists
		   Then I import scenarios from $new_import_file
           And I assign "TRUE" to variable "file_imported"
	   EndIf
	   And I increase variable "import_loop"
	Endwhile

Then I "confirm a file was found and imported"
	If I verify text $file_imported is equal to "FALSE"
    	Then I assign variable "error_message" by combining "ERROR: Failed to find and import file " $import_file
        And I fail step with error message $error_message
    EndIf

And I "cleanup the working variables"
	Then I unassign variable "new_import_file"
	And I unassign variable "directory"
	And I unassign variable "directory_token"
	And I unassign variable "import_file"
	And I unassign variable "full_path_import_file"

@wip @public
Scenario: Perform MSQL Execution
###################################################################
# Description:  Execute a MSQL Script supporting code overriding.
# MSQL Files:
#	None
# Inputs:
#	Required:
# 		msql_file - The name of the MSQL file to be executed	
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#	Optional:
#		None
# Outputs:
#  	MOCA resultset and MOCA status are available
###################################################################

Given I "find the right directory and execute"
	Then I assign variable "file" by combining $msql_directory_location $msql_file
	And I execute scenario "Locate File on Path"
	If I verify variable "new_file" is assigned
	Else I assign variable "error_message" by combining "ERROR: Could not determine path to MSQL Execution file: " $file
		And I fail step with error message $error_message
	EndIf
	When I execute MOCA script $new_file

Then I "cleanup the working variables"
	Given I unassign variable "new_file"
	And I unassign variable "msql_file"

@wip @public
Scenario: Perform SQL Execution
###################################################################
# Description:  Execute a SQL Script supporting code overriding.
# MSQL Files:
#	None
# Inputs:
#	Required:
# 		sql_file - The name of the SQL file to be executed	
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#	Optional:
#		None
# Outputs:
#  	SQL resultset and SQL status are available
###################################################################

Given I "find the right directory and execute"
	Then I assign variable "file" by combining $sql_directory_location $sql_file
	And I execute scenario "Locate File on Path"
	If I verify variable "new_file" is assigned
	Else I assign variable "error_message" by combining "ERROR: Could not determine path to SQL Execution file: " $file
		And I fail step with error message $error_message
	EndIf
	When I execute SQL script $new_file

Then I "cleanup the working variables"
	Given I unassign variable "new_file"
	And I unassign variable "sql_file"

@wip @public
Scenario: Perform Groovy Execution
###################################################################
# Description:  Execute a Groovy Script supporting code overriding.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		groovy_file - The name of the groovy file to be executed	
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#	Optional:
#		None
# Outputs:
# 	Variable created by groovy script are available.
###################################################################

Given I "find the right directory and execute"
	Then I assign variable "file" by combining $groovy_directory_location $groovy_file
	And I execute scenario "Locate File on Path"
	If I verify variable "new_file" is assigned
	Else I assign variable "error_message" by combining "ERROR: Could not determine path to Groovy Execution file: " $file
		And I fail step with error message $error_message
	EndIf
	When I execute groovy script $new_file  

Then I "cleanup the working variables"
	Given I unassign variable "new_file"
	And I unassign variable "groovy_file"

@wip @public
Scenario: Perform MOCA Cleanup Script
###################################################################
# Description:  Execute a MOCA Cleanup Script supporting code overriding.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		cleanup_directory -	The dataset directory to use for cleanup
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#		cleanup_data - environment variable controlling if data cleanup logic should be run by test (TRUE/FALSE)
#	Optional:
#		None
# Outputs:
#	None
###################################################################

Given I "find the right directory and execute"
	If I verify text $cleanup_data is equal to "TRUE" ignoring case
		Then I assign variable "file" by combining $dataset_directory_location $cleanup_directory
		And I execute scenario "Locate File on Path"
		If I verify variable "new_file" is assigned
		Else I assign variable "error_message" by combining "ERROR: Could not determine path to MOCA Cleanup Script file: " $file
			And I fail step with error message $error_message
		EndIf
		When I execute cleanup script for MOCA dataset $new_file
		And I unassign variable "new_file"
	EndIf
	And I unassign variable "cleanup_directory"

@wip @public
Scenario: Perform MOCA Dataset
###################################################################
# Description:  Execute a MOCA Dataset supporting code overriding.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		dataset_directory -	The dataset directory to use for loading	
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#		create_data - environment variable controlling if data creation logic should be run by test (TRUE/FALSE)
#	Optional:
#		None
# Outputs:
#  	None
###################################################################

Given I "find the right directory and execute"
	If I verify text $create_data is equal to "TRUE" ignoring case
		Then I assign variable "file" by combining $dataset_directory_location $dataset_directory
		And I execute scenario "Locate File on Path"
		If I verify variable "new_file" is assigned
		Else I assign variable "error_message" by combining "ERROR: Could not determine path to MOCA Dataset file: " $file
			And I fail step with error message $error_message
		EndIf
		When I execute MOCA dataset $new_file
		And I unassign variable "new_file"
	EndIf
	And I unassign variable "dataset_directory"

@wip @public
Scenario: Perform SQL Cleanup Script
###################################################################
# Description:  Execute a SQL Cleanup Script supporting code overriding.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		cleanup_directory -	The dataset directory to use for cleanup
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#		cleanup_data - environment variable controlling if data cleanup logic should be run by test (TRUE/FALSE)
#	Optional:
#		None
# Outputs:
#	None
###################################################################

Given I "find the right directory and execute"
	If I verify text $cleanup_data is equal to "TRUE" ignoring case
		Then I assign variable "file" by combining $dataset_directory_location $cleanup_directory
		And I execute scenario "Locate File on Path"
		If I verify variable "new_file" is assigned
		Else I assign variable "error_message" by combining "ERROR: Could not determine path to SQL Cleanup Script file: " $file
			And I fail step with error message $error_message
		EndIf
		When I execute cleanup script for SQL dataset $new_file
		And I unassign variable "new_file"
	EndIf
	And I unassign variable "cleanup_directory"

@wip @public
Scenario: Perform SQL Dataset
###################################################################
# Description:  Execute a SQL Dataset supporting code overriding.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		dataset_directory -	The dataset directory to use for loading	
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#		create_data - environment variable controlling if data creation logic should be run by test (TRUE/FALSE)
#	Optional:
#		None
# Outputs:
#  	None
###################################################################

Given I "find the right directory and execute"
	If I verify text $create_data is equal to "TRUE" ignoring case
		Then I assign variable "file" by combining $dataset_directory_location $dataset_directory
		And I execute scenario "Locate File on Path"
		If I verify variable "new_file" is assigned
		Else I assign variable "error_message" by combining "ERROR: Could not determine path to SQL Dataset file: " $file
			And I fail step with error message $error_message
		EndIf
		When I execute SQL dataset $new_file
		And I unassign variable "new_file"
	EndIf
	And I unassign variable "dataset_directory"
    
@wip @public
Scenario: Perform Load of Native App Locator CSV
###################################################################
# Description:  For Native App Locators, load CSV into variables.
# MSQL Files:
#	None
# Inputs:
#	 Required:
# 		locator_csv -	The CSV file to use for variable load of Native App Locators
#	Optional:
#		None
# Outputs:
#  	None
###################################################################
 
Given I "load Native App Locator CSV variables"
	If I verify variable "native_app_locators_directory_location" is assigned
	And I verify text $native_app_locators_directory_location is not equal to ""
		Then I assign variable "file" by combining $native_app_locators_directory_location $locator_csv
		And I execute scenario "Locate File on Path"
		If I verify variable "new_file" is assigned
		Else I assign variable "error_message" by combining "ERROR: Could not determine path to Native App Locators file: " $file
			And I fail step with error message $error_message
		EndIf
		While I assign values in next row from $new_file to variables
			Then I assign value $value to unassigned variable $variable
		EndWhile
		And I unassign variable "locator_csv"
	EndIf

@wip @public
Scenario: Perform Load of API Field Mappings
###################################################################
# Description: Determine the path to the CSV file used for DB-to-API field mappings
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		api_data_directory_location
# 	Optional:
# 		None
# Outputs:
# 	api_field_mapping_file
###################################################################
 
Given I "load API field mappings from CSV file"
	If I verify variable "api_data_directory_location" is assigned
	And I verify text $api_data_directory_location is not equal to ""
		Given I assign variable "file" by combining $api_data_directory_location "API Field Names.csv"
		When I execute scenario "Locate File on Path"
		If I verify variable "new_file" is assigned
		Else I assign variable "error_message" by combining "ERROR: Could not determine path to API Field Mappings file: " $file
			And I fail step with error message $error_message
		EndIf
		Then I assign $new_file to variable "api_field_mapping_file"

		While I assign values in next row from $api_field_mapping_file to variables
			Then I assign variable "api_var_map_name" by combining "api_var_map_" $db_field
			And I assign $api_field to variable $api_var_map_name
		EndWhile
	Else I fail step with error message "ERROR: Missing api_data_directory_location"
	EndIf

@wip @public
Scenario: Locate File on Path
###################################################################
# Description: Find the first file matching file when the file system is searched
# in directory_load_path sequence.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		file -	The relative path of the file being imported with /-/ denoting the directory substitution position	
#		directory_load_path - path sequence that controls code precedence. This value is created in the environment setup.
#	Optional:
#		None
# Outputs:
#	new_file - The relative path to the first matching file (unassigned of locator fails)
###################################################################

Given I "search for the file in directory_load_path sequence"
	Given I assign 1 to variable "path_loop"
	And I assign "FALSE" to variable "path_done"
	While I assign $path_loop th item from "," delimited list $directory_load_path to variable "directory"
	And I verify text $path_done is equal to "FALSE"
		Given I assign variable "directory_token" by combining "/" $directory "/"
		Given I execute Groovy "new_file = file.replaceAll('/-/', directory_token).replaceAll('\\\\-\\\\', directory_token)"
		If I verify file $new_file exists
			Then I assign "TRUE" to variable "path_done"            
		Else I increase variable "path_loop"
		EndIf
	Endwhile 
		
Then I "confirm a file was located"
	If I verify text $path_done is equal to "FALSE"
		Then I assign variable "error_message" by combining "ERROR: File " $file " not found"
		And I echo $error_message
		And I unassign variable "new_file"
	EndIf
		
And I "clear the working variables"
	Given I unassign variable "file"
	And I unassign variable "directory"
	And I unassign variable "directory_token"
	And I unassign variable "path_loop"
	And I unassign variable "path_done"
	
@wip @public
Scenario: Test Data Triggers
###################################################################
# Description: Execution of Dynamic Data call and future expansion of 
# test data related tasks
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
###################################################################

Given I "perform additional test data activities"
	If I verify text $dynamic_data is equal to "TRUE" ignoring case
		Then I execute scenario "Process Dynamic Data Variables"
    EndIf
    
@wip @public
Scenario: Test Completion
###################################################################
# Description:  Execute a common utility that will be called by
# every test case and handle terminal, Mobile, and WEB logout and in the
# future other activities we want to perform.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
###################################################################

Given I "perform a Terminal logout"
	If I verify terminal is OPENED
    	Then  I "navigate to undirected menu to end test"
			And I execute scenario "Terminal Navigate Quickly to Undirected Menu"
            
        And I "logout of the terminal"
			Then I execute scenario "Terminal Logout"
	EndIf

And I "perform a Mobile App Logout"
	If I verify variable "mobile_logged_off" is assigned
	And I verify text $mobile_logged_off is equal to "FALSE"
		If I execute scenario "Mobile Logout"
		Endif
	EndIf
	
Then I "perform a WEB logout and termination of WEB driver tasks (unless asked not to)"
	If I verify variable "web_logged_off" is assigned
	And I verify text $web_logged_off is equal to "FALSE"
		If I execute scenario "Web Logout"
			If I verify variable "parallel_testing" is assigned
			And I verify text $parallel_testing is equal to "FALSE" ignoring case
				If I execute scenario "Web End Driver Tasks"
				EndIf
			EndIf 
		Endif
	EndIf

And I "perform custom test triggers"
	Then I execute scenario "Test Completion Triggers"
	
@wip @public
Scenario: Test Completion Triggers
###################################################################
# Description:  Execute a last hook for test completion activities that 
# are not terminal or Web focused. Empty for now, future capabilities.
# Example could be (but not implemented) a trigger to do post test case reporting
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
################################################################### 

Given I "perform additional test completion activities (empty currently)"

@wip @public
Scenario: Begin Pre-Test Activities
###################################################################
# Description:  Execute pre test activities.  These occur at
# the begin of the actual test.  This will be after the Backgrond
# so the pre-cleanup and data load will have already been run.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		test_case - Short code of the test case
#		pre_validations - determines if pre validation logic should be executed
#	Optional:
#		None
# Outputs:
#	None
###################################################################

Given I execute scenario "Process Test Case Pre Validations"

@wip @public
Scenario: End Post-Test Activities
###################################################################
# Description:  Execute post test activities.  These occur within
# the actual test and not the after scenarios.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		test_case - Short code of the test case
#		post_validations - determines if post validation logic should be executed
#	Optional:
#		None
# Outputs:
#	None
###################################################################

Given I execute scenario "Process Test Case Post Validations"

@wip @public
Scenario: Get WMS Version
###################################################################
# Description:  Extract the version of the WMS
# MSQL Files:
#	get_wms_version.msql
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	wms_version - version number of the WMS
###################################################################

Given I "extract and record the version of the WMS"
	Then I assign "get_wms_version.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "wms_version" to variable "wms_version"
		And I echo "WMS Version is: " $wms_version
	Else I fail step with error message "ERROR: get_wms_version.msql failed"
	Endif

#############################################################
# Private Scenarios:
#	Setup Wait Times - Load wait time variables
#	Setup HTTP Status Codes - Load HTTP status code variables
#	Load Environment File - Loads a CSV file containing Variable / Value pairs
#############################################################

@wip @private
Scenario: Setup Wait Times
###################################################################
# Description: Load wait time variables
# MSQL Files:
#	None
# Inputs:
#	Required:
#		File 'Environments/Wait Times.csv'
#	Optional:
#		None
# Outputs:
# 	All wait time environment variables
#   To override a wait time, include it in the Environment.csv or Environment_Overrride.csv files
###################################################################

Given I "load a CSV file containing variable / value pairs for wait times and assigns each to a cycle variable"
	Given I assign variable "wait_times_file" by combining $environments_directory_location "Wait Times.csv"
	If I verify file $wait_times_file exists
		While I assign values in next row from $wait_times_file to variables
			Then I assign value $value to unassigned variable $variable
		EndWhile
	Else I assign variable "error_message" by combining "ERROR: Failed - 404 - file " $wait_times_file " not found."
		Then I fail step with error message $error_message
	EndIf
	
@wip @private
Scenario: Setup HTTP Status Codes
###################################################################
# Description: Load HTTP status code variables
# MSQL Files:
#	None
# Inputs:
#	Required:
# 		api_data_directory_location
#		File 'Data/API/-/HTTP Status Codes.csv'
#	Optional:
#		None
# Outputs:
# 	All HTTP status code environment variables
#   To override a status code, create a new "HTTP Status Codes.csv" file in the Data/API/Custom directory
###################################################################

Given I "load a CSV file containing variable / value pairs for HTTP status codes and assigns each to a cycle variable"
	If I verify variable "api_data_directory_location" is assigned
	And I verify text $api_data_directory_location is not equal to ""
		Given I assign variable "file" by combining $api_data_directory_location "HTTP Status Codes.csv"
		When I execute scenario "Locate File on Path"
		If I verify variable "new_file" is assigned
		Else I assign variable "error_message" by combining "ERROR: Could not determine path to HTTP Status Codes file: " $file
			And I fail step with error message $error_message
		EndIf
	Else I fail step with error message "ERROR: Missing api_data_directory_location"
	EndIf

	While I assign values in next row from $new_file to variables
		Then I assign value $value to unassigned variable $variable
	EndWhile

@wip @private
Scenario: Load Environment File
##############################################################################
#  Description:  Loads a CSV file containing Variable / Value pairs and 
#                assigns each value to an unassigned cycle variable
# MSQL Files:
#	None
# Inputs: 	
#	Required:
#		environment_file - full path and filename containing data
#	Optional:	
#		None
# Outputs:
#	None
###############################################################################

Given I "load a CSV file containing variable / value pairs and assigns each to a cycle variable"
	While I assign values in next row from $environment_file to variables
		Then I assign value $value to unassigned variable $variable
	EndWhile