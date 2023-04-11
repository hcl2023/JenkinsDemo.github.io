/*
Groovy File: build_complex_json_object.groovy
Description:
	This script will build a complex JSON object using the structure provided by
	the "structure" variable. Variables are prefixed with the @ symbol and will
	be dynamically replaced with their declaration and value. E.g. @inventoryId
	will be replaced with "inventoryId":"<value of inventory ID>". String
	variables will be properly escaped.
Input:
	Required:
		structure  - a variable containing the structure and variable names
			to include in the final JSON string
	Optional:
		None
Output:
	json_string - A properly-escaped JSON string

Detailed Example:
-----------------
STEP 1: Sample JSON string (for Inventory Adjustment POST):
{
	"inventoryAdjustments": [
		{
			"footprintCode": "DEFFTP",
			"inventoryReference": {
				"inventoryId": "RJFLPN001"
			},
			"inventoryStatus": "A",
			"itemClientId": "----",
			"itemNumber": "SC6152E",
			"locationNumber": "PERM-XDK-LOC",
			"reason": {
				"reasonCode": "ADJ-ACCEPT"
			},
			"unitQuantity": 120
		}
	],
	"operationCode": "INVADJ",
	"warehouseId": "WMD1"
}

STEP 2: Mapping to Cycle variables:
{
	"inventoryAdjustments": [
		{
			@footprintCode,
			"inventoryReference": {
				@inventoryId
			},
			@inventoryStatus,
			@itemClientId,
			@itemNumber,
			@locationNumber,
			"reason": {
				@reasonCode
			},
			@unitQuantity
		}
	],
	@operationCode,
	@warehouseId
}

STEP 3: Remove whitespace
{"inventoryAdjustments":[{@footprintCode,"inventoryReference":{@inventoryId},@inventoryStatus,@itemClientId,@itemNumber,@locationNumber,"reason":{@reasonCode},@unitQuantity}],@operationCode,@warehouseId}
*/

import groovy.json.StringEscapeUtils
import java.util.regex.*

/*
// Uncomment this block of code to run Groovy standalone
def structure = '{"@type":"test","inventoryAdjustments":[{@footprintCode,"inventoryReference":{@inventoryId},@inventoryStatus,@itemClientId,@itemNumber,@locationNumber,"reason":{@reasonCode},@unitQuantity}],@operationCode,@warehouseId}'
warehouseId = 'WMD1'
itemNumber = 'SC6152E'
itemClientId = '----'
locationNumber = 'PERM-XDK-LOC'
footprintCode = 'DEFFTP'
unitQuantity = 120
inventoryId = 'RJFLPN001'
inventoryStatus = 'A'
reasonCode = 'ADJ-ACCEPT'
operationCode = 'INVADJ'
*/

StringBuffer sb = new StringBuffer()
Pattern p = Pattern.compile('"?@([A-Za-z0-9_]+)"?')
Matcher m = p.matcher(structure)
while (m.find())
{
	String match = m.group(0)
	if (match.startsWith('"') && match.endsWith('"'))
	{
		// If the variable notation is enclosed in quotes, we want to skip it (could be "@type":"string")
		continue
	}

	String varName = m.group(1)
	def varValue = this."$varName"

	// Determine data type of variable
	if (varValue instanceof Integer || varValue instanceof Long || varValue instanceof Float || varValue instanceof Double || varValue instanceof Boolean || varValue instanceof BigInteger || varValue instanceof BigDecimal)
	{
		m.appendReplacement(sb, "\"$varName\":" + varValue)
	}
	else if (varValue instanceof String)
	{
		m.appendReplacement(sb, "\"$varName\":\"" + StringEscapeUtils.escapeJavaScript(varValue.toString()) + "\"")
	}
	else
	{
		throw new RuntimeException('Invalid data type in variable ' + varName + ' (' + typeof(varValue) + ')')
	}
}
m.appendTail(sb)
json_string = sb.toString()
println(json_string)