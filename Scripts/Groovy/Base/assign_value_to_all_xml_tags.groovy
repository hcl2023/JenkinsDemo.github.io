/*
Groovy File: assign_value_to_all_xml_tags.groovy
Description:  This script will assign a value to all the matching tags within an XML string.   
Input:
	Required:
		xml  - an XML String
		tag  - a XML Tag 
		new_value - Value to assign to the XML tag
	Optional:
		None
Output:
	new_xml - String containing xml with the tag altered.
*/
import java.util.*
import groovy.xml.*

def stringXML = new XmlParser().parseText(xml)
stringXML.depthFirst().findAll{it -> it.name() == tag}.each{it -> it.value = new_value}
def stringWriter = new StringWriter()
new XmlNodePrinter(new PrintWriter(stringWriter), "").print(stringXML)
  
def tempXml = stringWriter.toString().readLines().join()
new_xml = tempXml