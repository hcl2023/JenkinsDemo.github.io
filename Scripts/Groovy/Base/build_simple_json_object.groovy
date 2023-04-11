/*
Groovy File: build_simple_json_object.groovy
Description:
	This script will build a simple JSON object using the
	variables specified in the "columns" parameter. It is not
	capable of producing arrays or nested JSON objects. Also,
	it treats all values as Strings
Input:
	Required:
		columns  - a comma-separated list of variable names
	Optional:
		None
Output:
	json_string - A properly-escaped JSON string
*/

import groovy.json.StringEscapeUtils

/*
// Uncomment this block of code to run Groovy standalone
def columns = 'warehouseId,itemNumber,itemClientId'
warehouseId = 'WMD1'
itemNumber = 'CYC_PRT1'
itemClientId = '----'
*/

StringBuilder sb = new StringBuilder('{')
columns.split(',').each({variableName ->
	if (sb.length() > 1)
	{
		sb.append(',')
	}
	sb.append("\"$variableName\":\"").append(StringEscapeUtils.escapeJavaScript(this."$variableName".toString())).append("\"")
})
sb.append('}')
json_string = sb.toString()
println('JSON String: ' + json_string)