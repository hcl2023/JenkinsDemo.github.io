/*
Groovy File: assign_value_to_first_xml_tag.groovy
Description:  This script will assign a value to a tag within an XML string.   
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
stringXML.depthFirst().find{it -> it.name() == tag}.value = new_value
def stringWriter = new StringWriter()
new XmlNodePrinter(new PrintWriter(stringWriter), "").print(stringXML)
  
def tempXml = stringWriter.toString().readLines().join()
new_xml = tempXml