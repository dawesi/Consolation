
<cfcomponent  displayname="editro" output="false">
		
<!--- INIT METHOD FOR CFC --->	
	
<cffunction name="init" access="public" output="false" returntype="editor">
	<cfreturn this/>
</cffunction>	
	


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




<!---    Date: 9/10/2009 Usage: create an invitiatoin code for the register function --->
<cffunction name="createRefCode" output="false" access="public" returntype="string" hint="create an invitiatoin code for the register function">
	<cfargument name="codeLength" type="numeric" default="7" hint="a number less than 30 to determine the length of the invite code. Default is 7">
	<cfset var productCode = CreateUUID()>




<!---
	We have to start out be defining what the sets of valid
	character data are. While this might not look elegant,
	notice that it gives a LOT of power over what the sets
	are without writing a whole lot of code or "condition"
	statements.
--->
 
<!--- Set up available lower case values. --->
<cfset var strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz" />
 
<!---
	Set up available upper case values. In this instance, we
	want the upper case to correspond to the lower case, so
	we are leveraging that character set.
--->
<cfset var strUpperCaseAlpha = UCase( strLowerCaseAlpha ) />
 
<!--- Set up available numbers. --->
<cfset var strNumbers = "0123456789" />
 
<!--- Set up additional valid password chars. --->
<cfset var strOtherChars = "" />
 
<!---
	When selecting random value, we want to be able to easily
	choose from the entire set. To this effect, we are going
	to concatenate all the previous valid character sets.
--->
<cfset var strAllValidChars = (
	strLowerCaseAlpha &
	strUpperCaseAlpha &
	strNumbers &
	strOtherChars
	) />
 
 
<!---
	Create an array to contain the password ( think of a
	string as an array of character).
--->
<cfset var arrPassword = ArrayNew( 1 ) />
 
 
<!---
	When creating a password, there are certain rules that we
	need to follow (as deemed by the business logic). That is,
	the password must:
 
	- must be exactly 8 characters in length
	- must have at least 1 number
	- must have at least 1 uppercase letter
	- must have at least 1 lower case letter
--->
 
 
<!--- Select the random number from our number set. --->
<cfset arrPassword[ 1 ] = Mid(
	strNumbers,
	RandRange( 1, Len( strNumbers ) ),
	1
	) />
 
<!--- Select the random letter from our lower case set. --->
<cfset arrPassword[ 2 ] = Mid(
	strLowerCaseAlpha,
	RandRange( 1, Len( strLowerCaseAlpha ) ),
	1
	) />
 
<!--- Select the random letter from our upper case set. --->
<cfset arrPassword[ 3 ] = Mid(
	strUpperCaseAlpha,
	RandRange( 1, Len( strUpperCaseAlpha ) ),
	1
	) />
 
 
<!---
	ASSERT: At this time, we have satisfied the character
	requirements of the password, but NOT the length
	requirement. In order to do that, we must add more
	random characters to make up a proper length.
--->
 
 
<!--- Create rest of the password. --->
<cfloop
	index="intChar"
	from="#(ArrayLen( arrPassword ) + 1)#"
	to="8"
	step="1">
 
	<!---
		Pick random value. For this character, we can choose
		from the entire set of valid characters.
	--->
	<cfset arrPassword[ intChar ] = Mid(
		strAllValidChars,
		RandRange( 1, Len( strAllValidChars ) ),
		1
		) />
 
</cfloop>
 
 
<!---
	Now, we have an array that has the proper number of
	characters and fits the business rules. But, we don't
	always want the first three characters to be of the
	same order (by type). Therefore, let's use the Java
	Collections utility class to shuffle this array into
	a "random" order.
 
	If you are not comfortable using the Java class, you
	can create your own shuffle algorithm.
--->
<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(
	arrPassword
	) />
 
 
<!---
	We now have a randomly shuffled array. Now, we just need
	to join all the characters into a single string. We can
	do this by converting the array to a list and then just
	providing no delimiters (empty string delimiter).
--->
<cfset strPassword = ArrayToList(
	arrPassword,
	""
	) />

	 <cfreturn strPassword>
</cffunction>



</cfcomponent>
