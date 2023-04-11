/*  
Groovy File: lookup_dynamic_data_instructions.groovy
Description: 
This script follows the directory load path to read through the CSV files within the data/dynamic data directory
to find the first occurance of the Dynamic Data value.   It then returns the fields from the rows. 
The Dynamic Data CSV files should have a header row of:  
    value,instruction_type,instruction,where_clause,order_by_clause,extra_fields,retry_value,comment
 
values 				- The Dynamic Data value  (this is the code that will be in the test input CSV files)
instruction_type	- Defines the type of dynamic data.  (Scenario,MSQL,SQL,Prompt_String,Prompt_Integer)
intruction			- The instruction (scenario, script, or prompt) to be executed
where_clause		- Optional WHERE CLAUSE that can be added in SQL style instruction logic
order_by_clause		- Optional ORDER BY CLAUSE that can be added in SQL style instruction logic
extra_fields		- Comma seperated list of extra fields that can be setup the the instruction (specifically for MSQL these values are assigned to moca environment variable)
retry_value			- Run this Dynamic Data value if the first value fails - If the retry value does not start with ?, then it is assumed to be a default value
comment				- Used for documentation

-> Note the current logic assumes the exact ordering of the fields within the Dynamic Data CSV field

*/
instruction_type = "SKIP";
instruction = '';
where_clause = '';
order_by_clause = '';
return_fields = '';
retry_value = '';
dd_value = value.toString();
project_dir = project_directory_location.toString().replace('\\','/');
if (dd_value.substring(0,1) == "?"){  
	done = 0;
	String[] dirList =  directory_load_path.split(",");
	/* search the directories for the dynamic data CSV files */
	for (String token: dirList){ 
		path = "/" + token ;
 	    directory = project_dir + "/" + dynamic_data_directory_location.replace("/-/",path);  

		new File(directory).traverse(type: groovy.io.FileType.FILES, nameFilter:  ~/.*\.csv/ ) {  
			  File csvFile ->
			  /* Read each line from the CSV File */
			  csvFile.eachLine { 
				   String line ->
				   /* split on the comma only if that comma has zero, or an even number of quotes ahead of it */
				   String[] csvList = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*\$)", -1);
				   if (csvList[0] == dd_value && !done){ 
						 done = 1;
						 instruction_type = csvList[1].trim();
						 instruction = csvList[2].trim();
						 try{where_clause = csvList[3].replace('"','').trim()} catch(Exception e) {};
						 try{order_by_clause = csvList[4].replace('"','').trim()} catch(Exception e) {};
						 try{return_fields = csvList[5].replace('"','').trim()} catch(Exception e) {};
						 try{retry_value = csvList[6].trim()} catch(Exception e) {};
				   }                                                                             
			  }
		}
		if (done) break;
	}
} 
 