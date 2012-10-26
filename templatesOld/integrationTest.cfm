<cffunction name="getStringOfLength" access="public" output="false" returnType="string">
	<cfargument name="length" type="numeric" required="true" hint="">
	
	<cfset var testString = "">
	<cfset var spaceIndex = 1>
	
	
	<cfloop from='1' to="#arguments.length#" index="i">
	
	<cfif spaceIndex eq 7>
		<cfset testString = testString & " ">
		<cfset spaceIndex=1>
	<cfelse>	
		<cfset testString = testString & chr(randRange(65,90))>
		<cfset spaceIndex++>
	</cfif>
	
	
	</cfloop>
		<cfreturn trim(testString)>
	
</cffunction>

<cffunction name="getTestData" returntype="string" output="false">
	<cfargument name="type" type="string" required="true" hint="">
	<cfargument name="integrity" type="string" required="false" default="valid" hint="valid or invalid">
	<cfargument name="length" type="any" required="false" default="50" hint="">
	
	<cfif arguments.integrity eq 'invalid'>
	
		<cfset arguments.length = evaluate(arguments.length + 25)>
	
		<cfif arguments.type eq 'date' or arguments.type eq 'number'>
			<cfset arguments.type = 'varchar2'>
		</cfif>
		
	</cfif>
	

	<cfswitch expression="#arguments.type#">
	
		<cfcase value="varchar2">
			<cfset testData=trim(getStringOfLength(arguments.length))>
		</cfcase>
		
		<cfcase value="number">
			<cfif isNumeric(arguments.length) and arguments.length eq 1>
				<cfset testData="1">
			<cfelse>
				<cfset testData="1000">
			</cfif>
			
		</cfcase>
				
		<cfcase value="date">
			<cfset testData=now()>
		</cfcase>
		
		<cfdefaultcase>
			<cfset testData="#arguments.type# is not valid">
		</cfdefaultcase>
	
	</cfswitch>
	
	<cfreturn trim(testData)>
	
</cffunction>


<cfsavecontent variable="integrationTestCode">	
<cfoutput>

#chr(60)#!--- Unit test for #consoleRequest.name# --->

#chr(60)#cfcomponent component extends="coldbox.system.testing.BaseTestCase" appMapping="/coldbox/ApplicationTemplates/Advanced">



#chr(60)#cffunction name="getUseCaseData" access="private" output="false" returnType="struct">
#chr(60)#cfscript>
useCaseData = structNew();
	useCaseData.valid = structNew();
	useCaseData.invalid = structNew();


<cfloop query="qColumns">

	<cfif qColumns.type eq 'number'>
		useCaseData.valid.#scaffoldService.camelCase(qColumns.name)# = #getTestData(qColumns.type, 'valid', qColumns.precision)#;	

	<cfelseif qColumns.type eq 'date'>
		useCaseData.valid.#scaffoldService.camelCase(qColumns.name)# = now();	

	<cfelse>
	 useCaseData.valid.#scaffoldService.camelCase(qColumns.name)# = "#trim(getTestData(qColumns.type, 'valid', qColumns.length))#";
	</cfif>
	
</cfloop>
	
	useCaseData.valid.addedBy = "1";
	
<cfloop query="qColumns">
	useCaseData.invalid.#scaffoldService.camelCase(qColumns.name)# = "<cfif qColumns.type eq 'number'>#getTestData(qColumns.type, 'invalid', qColumns.precision)#<cfelse>#getTestData(qColumns.type, 'invalid', qColumns.length)#</cfif>";
</cfloop>

return useCaseData;
#chr(60)#/cfscript>

#chr(60)#cfreturn useCaseData>

#chr(60)#/cffunction>




 #chr(60)#!--- this will run before every single test in this test case --->
 #chr(60)#cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
     #chr(60)#cfset obj = createObject("component","#consoleConfig.appRoot#.model.#consoleRequest.name#").init()>
 #chr(60)#/cffunction>

#chr(60)#cffunction name="atestList">
    #chr(60)#cfset injectMethod(obj, this, "getStaticID", "getNewID")>
	#chr(60)#cfset injectMethod(obj, this, "getStaticDBO", "getDBO")>
	#chr(60)#cfset injectMethod(obj, this, "getStaticDSN", "getDSN")>
		#chr(60)#cfset result = obj.list()>
		#chr(60)#cfset debug(result)>

#chr(60)#/cffunction>




#chr(60)#cffunction name="btestValidationSuccess">
    #chr(60)#!--- pass in our returnMultipleListElements function into the object and name it functionB --->
  #chr(60)#cfscript>
	var data = getUseCaseData().valid;
	debug(data);

	result = obj.validate(data=data);
	assertTrue(result.isValid);
	debug(result);	

#chr(60)#/cfscript>
#chr(60)#/cffunction>

#chr(60)#cffunction name="btestValidationFail">
    #chr(60)#!--- pass in our returnMultipleListElements function into the object and name it functionB --->
  #chr(60)#cfscript>
	var data = getUseCaseData().invalid;
	debug(data);

	result = obj.validate(data=data);
	assertFalse(result.isValid);
	debug(result);	

#chr(60)#/cfscript>
#chr(60)#/cffunction>


#chr(60)#cffunction name="btestAdd">
    #chr(60)#!--- pass in our returnMultipleListElements function into the object and name it functionB --->
  #chr(60)#cfscript>
	injectMethod(obj, this, "getStaticID", "getNewID");
	injectMethod(obj, this, "getStaticDBO", "getDBO");
	injectMethod(obj, this, "getStaticDSN", "getDSN");
	counts = structNew();
	counts.current = obj.list().recordcount;
	counts.expected = counts.current + 1;
	
	var data = getUseCaseData().valid;
	debug(data);
		
	obj.add(data=data);
	
	counts.new = obj.list().recordcount;
	
	debug(counts);
	assertEquals(counts.expected,counts.new);
	

#chr(60)#/cfscript>

#chr(60)#/cffunction>



#chr(60)#cffunction name="ctestGet">
    #chr(60)#cfset injectMethod(obj, this, "getStaticID", "getNewID")>
	#chr(60)#cfset injectMethod(obj, this, "getStaticDBO", "getDBO")>
	#chr(60)#cfset injectMethod(obj, this, "getStaticDSN", "getDSN")>
		#chr(60)#cfset result = obj.get(42)>
		#chr(60)#cfset debug(result)>
		#chr(60)#cfreturn result.recordcount>
		
#chr(60)#/cffunction>




#chr(60)#cffunction name="dtestUpdate">
	
    #chr(60)#cfset injectMethod(obj, this, "getStaticID", "getNewID")>
	#chr(60)#cfset injectMethod(obj, this, "getStaticDBO", "getDBO")>
	#chr(60)#cfset injectMethod(obj, this, "getStaticDSN", "getDSN")>
		#chr(60)#cfset var data = getUseCaseData().valid>
		#chr(60)#cfset var result = obj.update(id=42,data=data)>

#chr(60)#/cffunction>

#chr(60)#cffunction name="etestDelete">
 	#chr(60)#cfscript>
    injectMethod(obj, this, "getStaticID", "getNewID");
	injectMethod(obj, this, "getStaticDBO", "getDBO");
	injectMethod(obj, this, "getStaticDSN", "getDSN");
	
	counts = structNew();
	counts.current = obj.list().recordcount;
	counts.expected = counts.current - 1;
	
		obj.delete(id=42);
		counts.new = obj.list().recordcount;
		assertEquals(counts.expected,counts.new);
		
		obj.delete(id=42,isHardDelete=true);
		
#chr(60)#/cfscript>	
#chr(60)#/cffunction>


#chr(60)#cffunction name="getStaticID" access="private">
	#chr(60)#cfreturn 42>
#chr(60)#/cffunction>


#chr(60)#cffunction name="getStaticDSN" access="Private" output="false" returnType="string">
	#chr(60)#cfreturn "#consoleConfig.dsn#">
#chr(60)#/cffunction>	

#chr(60)#cffunction name="getStaticDBO" access="Private" output="false" returnType="string">
	#chr(60)#cfreturn "#consoleConfig.dbo#">
#chr(60)#/cffunction>	

#chr(60)#/cfcomponent>

</cfoutput>
</cfsavecontent>