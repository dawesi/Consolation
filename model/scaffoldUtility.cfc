
<cfcomponent  displayname="scaffoldUtility" output="false">
		
<!--- INIT METHOD FOR CFC --->	
		
<cffunction name="init" access="public" output="false" returntype="scaffoldUtility">
	<cfreturn this/>
</cffunction>	
	

<cfscript>
function deCamelCase(str) {
  var rtnStr=lcase(reReplace(arguments.str,"([A-Z])([a-z])","_\1\2","ALL"));
	if (arrayLen(arguments) GT 1 AND arguments[2] EQ "capsPlease") {
		rtnStr=uCase(rtnStr);
	}
return trim(rtnStr);
}
</cfscript>


<cffunction name="$singularizeOrPluralize" returntype="string" access="public" output="false" hint="Called by singularize and pluralize to perform the conversion.">
	<cfargument name="text" type="string" required="true">
	<cfargument name="which" type="string" required="true">
	<cfargument name="count" type="numeric" required="false" default="-1">
	<cfargument name="returnCount" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		
		// by default we pluralize/singularize the entire string
		loc.text = arguments.text;
		
		if (REFind("[A-Z]", loc.text))
		{
			// only pluralize/singularize the last part of a camelCased variable (e.g. in "websiteStatusUpdate" we only change the "update" part)
			// also set a variable with the unchanged part of the string (to be prepended before returning final result)
			loc.upperCasePos = REFind("[A-Z]", Reverse(loc.text));
			loc.prepend = Mid(loc.text, 1, Len(loc.text)-loc.upperCasePos);
			loc.text = Reverse(Mid(Reverse(loc.text), 1, loc.upperCasePos));
		}
		
		// when count is 1 we don't need to pluralize at all so just set the return value to the input string
		loc.returnValue = loc.text;
		
		if (arguments.count != 1)
		{
			loc.uncountables = "advice,air,blood,deer,equipment,fish,food,furniture,garbage,graffiti,grass,homework,housework,information,knowledge,luggage,mathematics,meat,milk,money,music,pollution,research,rice,sand,series,sheep,soap,software,species,sugar,traffic,transportation,travel,trash,water";
			loc.irregulars = "child,children,foot,feet,man,men,move,moves,person,people,sex,sexes,tooth,teeth,woman,women";
			if (ListFindNoCase(loc.uncountables, loc.text))
				loc.returnValue = loc.text;
			else if (ListFindNoCase(loc.irregulars, loc.text))
			{
				loc.pos = ListFindNoCase(loc.irregulars, loc.text);
				if (arguments.which == "singularize" && loc.pos MOD 2 == 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos-1);
				else if (arguments.which == "pluralize" && loc.pos MOD 2 != 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos+1);
				else
					loc.returnValue = loc.text;
			}
			else
			{
				if (arguments.which == "pluralize")
					loc.ruleList = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat|potat|volcan|her)o$,\1oes,(bu)s$,\1ses,(alias|status),\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
				else if (arguments.which == "singularize")
					loc.ruleList = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,s$,#Chr(7)#";
				loc.rules = ArrayNew(2);
				loc.count = 1;
				loc.iEnd = ListLen(loc.ruleList);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i=loc.i+2)
				{
					loc.rules[loc.count][1] = ListGetAt(loc.ruleList, loc.i);
					loc.rules[loc.count][2] = ListGetAt(loc.ruleList, loc.i+1);
					loc.count = loc.count + 1;
				}
				loc.iEnd = ArrayLen(loc.rules);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					if(REFindNoCase(loc.rules[loc.i][1], loc.text))
					{
						loc.returnValue = REReplaceNoCase(loc.text, loc.rules[loc.i][1], loc.rules[loc.i][2]);
						break;
					}
				}
				loc.returnValue = Replace(loc.returnValue, Chr(7), "", "all");
			}
		}

		// this was a camelCased string and we need to prepend the unchanged part to the result
		if (StructKeyExists(loc, "prepend"))
			loc.returnValue = loc.prepend & loc.returnValue;

		// return the count number in the string (e.g. "5 sites" instead of just "sites")
		if (arguments.returnCount && arguments.count != -1)
			loc.returnValue = arguments.count & " " & loc.returnValue;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>



<cffunction name="humanize" returntype="string" access="public" output="false"
	hint="Returns readable text by capitalizing, converting camel casing to multiple words."
	examples=
	'
		##humanize("wheelsIsAFramework")##
		-> Wheels Is A Framework
	'
	categories="global-helper" chapters="global-functions" functions="capitalize,pluralize,singularize">
	<cfargument name="text" type="string" required="true" hint="Text to humanize">
	<cfscript>
		var loc = {};
		loc.returnValue = REReplace(arguments.text, "([[:upper:]])", " \1", "all"); // adds a space before every capitalized word
		loc.returnValue = REReplace(loc.returnValue, "([[:upper:]]) ([[:upper:]]) ", "\1\2", "all"); // fixes abbreviations so they form a word again (example: aURLVariable)
		loc.returnValue = Trim(capitalize(loc.returnValue)); // capitalize the first letter and trim final result (which removes the leading space that happens if the string starts with an upper case character)
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="tableFormat" access="public" output="false" returnType="string">	
	<cfargument name="theVictim" type="string" required="true" hint="">
	<cfreturn pluralize(decamelCase(arguments.theVictim))>
</cffunction>

<cffunction name="singularize" returntype="string" access="public" output="false"
	hint="Returns the singular form of the passed in word."
	examples=
	'
		##singularize("languages")##
		-> language
	'
	categories="global-helper" chapters="global-functions" functions="capitalize,humanize,pluralize">
	<cfargument name="word" type="string" required="true" hint="String to singularize">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="singularize")>
</cffunction>

<cffunction name="pluralize" returntype="string" access="public" output="false"
	hint="Returns the plural form of the passed in word."
	examples=
	'
		##pluralize("person")##
		-> people

		Your search returned ##pluralize(word="person", count=users.recordCount)##.
	'
	categories="global-helper" chapters="global-functions" functions="capitalize,humanize,singularize">
	<cfargument name="word" type="string" required="true" hint="The word to pluralize">
	<cfargument name="count" type="numeric" required="false" default="-1" hint="Pluralization will occur when this value is not 1">
	<cfargument name="returnCount" type="boolean" required="false" default="true" hint="Will return the count prepended to the pluralization when true and count is not -1">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
</cffunction>


<cffunction name="capitalize" returntype="string" access="public" output="false"
	hint="Returns the text with the first character converted to uppercase."
	examples=
	'
		##capitalize("wheels is a framework")##
		-> Wheels is a framework
	'
	categories="global-helper" chapters="global-functions" functions="humanize,pluralize,singularize">
	<cfargument name="text" type="string" required="true" hint="Text to capitalize">
	<cfreturn UCase(Left(arguments.text, 1)) & Mid(arguments.text, 2, Len(arguments.text)-1)>
</cffunction>




<!---    Date: 9/8/2009 Usage: format the default table_name to tableName --->
<cffunction name="camelCase" output="false" access="public" returntype="string" hint="format the default table_name to tableName">
	<cfargument name="string"  type="string" required="true"/>   
	
	<cfset newString = replace(arguments.string, "_", " ", "all")>
	<cfset newString = titleCase(newString)>
	<cfset newString = replace(newString, " ", "", "all")>
	<cfset firstChar = left(newString, 1)>
	<cfset newString = replaceNoCase(newString, firstChar, lcase(firstChar), "once")>
	
	<cfreturn newString>	
	 
</cffunction>

<cffunction name="objectify" output="false" access="public" returntype="string" hint="format the default table_name to tableName">
	<cfargument name="string"  type="string" required="true"/>   
	
	<cfset var newString = singularize(arguments.string)>
	<cfset newString = camelCase(newString)>	
	
	<cfreturn newString>	
	 
</cffunction>


<cffunction name="camelCase2" output="false" access="public" returntype="string" hint="format the default table_name to tableName">
	<cfargument name="string"  type="string" required="true"/>   
	
	<cfset newString = replace(arguments.string, "_", " ", "all")>
	<cfset newString = titleCase(newString)>
	<cfset newString = replace(newString, " ", "", "all")>

	<cfreturn newString>	
	 
</cffunction>




<cffunction name="superHTMLEditFormat" returntype="string">
	<cfargument name="string" type="string" required="true">
    <cfset var returnString = "#htmlEditFormat(arguments.string)#">
	<cfset var Tags = arrayNew(2)>
    
    	<cfscript>
			tags[1][1] = '&amp;';
			tags[1][2] = '&';	
			
		
			tags[2][1] = '&lt;br&gt;';
			tags[2][2] = '<br/>';
			
			tags[3][1] = '&lt;li&gt;';
			tags[3][2] = '<li>';
			
			tags[4][1] = '&lt;/li&gt;';
			tags[4][2] = '</li>';	
	
			tags[5][1] = '&lt;p&gt;';
			tags[5][2] = '<p>';
			
			tags[6][1] = '&lt;/p&gt;';
			tags[6][2] = '</p>';

			tags[7][1] = '&lt;b&gt;';
			tags[7][2] = '<b>';
	
			tags[8][1] = '&lt;/b&gt;';
			tags[8][2] = '</b>';
			
			tags[9][1] = '&lt;i&gt;';
			tags[9][2] = '<i>';
			
			tags[10][1] = '&lt;/i&gt;';
			tags[10][2] = '</i>';

			tags[11][1] = '&lt;br/&gt;';
			tags[11][2] = '<br/>';		
			

			tags[12][1] = '&quot;';
			tags[12][2] = '"';
			
			tags[13][1] = '&bull;';
			tags[13][2] = '<br/><li>';
			
			tags[14][1] = '&lt;br /&gt;';
			tags[14][2] = '<br/>';
			
			tags[15][1] = '&ldquo;';
			tags[15][2] = "'";
	
	
			tags[16][1] = '&rdquo;';
			tags[16][2] = "'";
		
			tags[17][1] = '&lt;ul&gt;';
			tags[17][2] = "<ul>";
	
	
			tags[18][1] = '&lt;/ul&gt;';
			tags[18][2] = "</ul>";		

			tags[19][1] = '&lt;ol&gt;';
			tags[19][2] = "<ol>";
	
	
			tags[20][1] = '&lt;/0l&gt;';
			tags[20][2] = "</ol>";		
			
										
		</cfscript>
	
    
    	<cfloop from="1" to="#arrayLen(tags)#" index="i">
        	<cfset returnString = replaceNoCase( returnString, tags[i][1], tags[i][2], "all")>
        </cfloop>
    
    
    	<cfreturn returnString>
    
</cffunction>




<cfscript>
/**
 * Returns a string with words capitalized for a title.
 * Modified by Ray Camden to include var statements.
 * 
 * @param initText 	 String to be modified. 
 * @return Returns a string. 
 * @author Ed Hodder (ed.hodder@bowne.com) 
 * @version 2, July 27, 2001 
 */
function titleCase(initText){
	
	var Words = "";
	var j = 1; var m = 1;
	var doCap = "";
	var thisWord = "";
	var excludeWords = ArrayNew(1);
	var outputString = "";
	
	initText = LCASE(initText);
	
	//Words to never capitalize
	excludeWords[1] = "an";
/*	excludeWords[2] = "the";
	excludeWords[3] = "at";
	excludeWords[4] = "by";
	excludeWords[5] = "for";
	excludeWords[6] = "of";
	excludeWords[7] = "in";
	excludeWords[8] = "up";
	excludeWords[9] = "on";
	excludeWords[10] = "to";
	excludeWords[11] = "and";
	excludeWords[12] = "as";
	excludeWords[13] = "but";
	excludeWords[14] = "if";
	excludeWords[15] = "or";
	excludeWords[16] = "nor";
	excludeWords[17] = "a";
	*/
	//Make each word in text an array variable
		
	Words = ListToArray(initText, " ");
	
	//Check words against exclude list
	for(j=1; j LTE (ArrayLen(Words)); j = j+1){
		doCap = true;
		
		//Word must be less that four characters to be in the list of excluded words
		if(LEN(Words[j]) LT 4 ){
			if(ListFind(ArrayToList(excludeWords,","),Words[j])){
				doCap = false;
			}
		}

		//Capitalize hyphenated words		
		if(ListLen(Words[j],"-") GT 1){
			for(m=2; m LTE ListLen(Words[j], "-"); m=m+1){
				thisWord = ListGetAt(Words[j], m, "-");
				thisWord = UCase(Mid(thisWord,1, 1)) & Mid(thisWord,2, LEN(thisWord)-1);
				Words[j] = ListSetAt(Words[j], m, thisWord, "-");
			}
		}
		
		//Automatically capitalize first and last words
		if(j eq 1 or j eq ArrayLen(Words)){
			doCap = true;
		}
		
		//Capitalize qualifying words
		if(doCap){
			Words[j] = UCase(Mid(Words[j],1, 1)) & Mid(Words[j],2, LEN(Words[j])-1);
		}
	}
	
	outputString = ArrayToList(Words, " ");
	
	return outputString;

}
</cfscript>



</cfcomponent>
