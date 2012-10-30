<cfcomponent displayname="parser" output="false" extends="scaffoldUtility">

<cffunction name="inti" access="public" output="false" returnType="any">
	<cfreturn this>
</cffunction>

<cffunction name="prepareRequest" access="public" output="false" returnType="string">
	<cfargument name="str" type="string" required="true" hint="">
	<cfset var request = str>
	<cfset var request = trim(request)>
	<cfset var request = urlDecode(request)>
	<cfset var request = replaceNoCase(request, "("," (", "all")>
	<cfreturn request>
</cffunction>





<cffunction name="parseCommand" access="public" output="false" returnType="struct">
	<cfargument name="command" type="string" required="true" hint="">

	<cfset var completedRequest = structNew()>

	<cfset formatedRequestString = prepareRequest(command)>
	
	<cfset var local = structNew()>
	<!--- these three fields determine the process --->
	<cfset local.requestString = formatedRequestString>
	<cfset local.command = ListFirst(formatedRequestString, " ")>


	<cfswitch expression="#local.command#">
	
	<cfcase value=  "create"> 	
		<cfset finalCompletedRequest = parseModel(local)>
	</cfcase>
	
	<cfcase value=  "drop"> 	
		<cfset finalCompletedRequest = parseDropModel(local)>
	</cfcase>	
	
	<cfcase value=  "add">
		<cfset finalCompletedRequest = parseAdd(local)>
	</cfcase>	
	
	<cfcase value=  "scaffold">
		<cfset finalCompletedRequest = parseScaffold(local)>
	</cfcase>
	
	<cfcase value=  "join">
		<cfset finalCompletedRequest = parseJoin(local)>
	</cfcase>
	
	<cfcase value=  "bind">
		<cfset finalCompletedRequest = parseBind(local)>
		</cfcase>
	
	<cfcase value=  "desc">
		<cfset finalCompletedRequest = parseDescribe(local)>
	</cfcase>
	
	<cfcase value=  "getXL"> 	
		<cfset finalCompletedRequest = parseXL(local)>
	</cfcase>


	</cfswitch>	


	<cfreturn finalCompletedRequest>

</cffunction>




<cffunction name="parseDescribe" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<!---<cfset var local = arguments.request>--->
	<cfset var workingData = arguments.request>

	<cftry>
	<cfset workingData.name = listGetAt(workingData.requestString, 2, " ")>
	<cfset workingData.table = decamelcase(pluralize(workingData.name))>
		
		<cfcatch>
			<cfabort showerror="#workingData.requestString# cannot be parsed!" >
		</cfcatch>
	</cftry>
	
	<cfreturn workingData>

</cffunction>


<cffunction name="parseAdd" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<cfset var workingData = arguments.request>
	
	<cfset workingData.name = listGetAt(workingData.requestString, 3, " ")>
	<cfset workingData.table = decamelCase(pluralize(workingData.name))>


	<cfset workingData.indexStart = find("(",workingData.requestString)  + 1>
	<cfset workingData.indexEnd = find( ")",workingData.requestString)>
	<cfset workingData.indexCount = workingData.indexEnd - workingData.indexStart>
	
	<cfset workingData.paramString = mid(workingData.requestString, workingData.indexStart, workingData.indexCount)>
	<cfset workingData.params = listtoArray(workingData.paramString, ",")>

	<cfreturn workingData>

</cffunction>



<cffunction name="parseModel" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<cfset var workingData = arguments.request>
	
	<cfset workingData.name = listGetAt(workingData.requestString, 2, " ")>
	<cfset workingData.table = pluralize(listGetAt(workingData.requestString, 2, " "))>


	<cfset workingData.indexStart = find("(",workingData.requestString)  + 1>
	<cfset workingData.indexEnd = find( ")",workingData.requestString)>
	<cfset workingData.indexCount = workingData.indexEnd - workingData.indexStart>
	
	<cfset workingData.paramString = mid(workingData.requestString, workingData.indexStart, workingData.indexCount)>
	<cfset workingData.params = listtoArray(workingData.paramString, ",")>
	

	<cfreturn workingData>

</cffunction>




<cffunction name="parseDropModel" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<cfset var workingData = arguments.request>
	<cfset workingData.model = listGetAt(workingData.requestString, 2, " ")>
	<cfset workingData.table = deCamelCase(pluralize(listGetAt(workingData.requestString, 2, " ")))>

	<cfreturn workingData>

</cffunction>


<cffunction name="parseXL" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<cfset var workingData = arguments.request>
	
	<cfset workingData.object = listGetAt(workingData.requestString, 1, " ")>
	<cfset workingData.name = listGetAt(workingData.requestString, 2, " ")>
	<cfset workingData.table = pluralize(listGetAt(workingData.requestString, 2, " "))>


	<cfset workingData.indexStart = find("(",workingData.requestString)  + 1>
	<cfset workingData.indexEnd = find( ")",workingData.requestString)>
	<cfset workingData.indexCount = workingData.indexEnd - workingData.indexStart>
	
	<cfset workingData.paramString = mid(workingData.requestString, workingData.indexStart, workingData.indexCount)>
	<cfset workingData.params = listtoArray(workingData.paramString, ",")>
	

	<cfreturn workingData>

</cffunction>

<cffunction name="parseScaffold" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<cfset var workingData = arguments.request>
	
	<cfset workingData.file = listGetAt(workingData.requestString, 2, " ")>
	<cfset workingData.name = listGetAt(workingData.requestString, 3, " ")>
	<cfset workingData.table = deCamelCase(pluralize(listGetAt(workingData.requestString, 3, " ")))>
	
	<cfset workingData.indexStart = find("(",workingData.requestString)  + 1>
	<cfset workingData.indexEnd = find( ")",workingData.requestString)>
	<cfset workingData.indexCount = workingData.indexEnd - workingData.indexStart>
	
	<cfset workingData.paramString = mid(workingData.requestString, workingData.indexStart, workingData.indexCount)>
	<cfset workingData.params = listtoArray(workingData.paramString, ",")>
	
	<cfset workingData.tableName = #deCamelCase(pluralize(workingData.name))#>
	<cfset workingData.modelName = #capitalize(workingData.name)#>
	<cfset workingData.collectionName = #pluralize(workingData.modelName)#>

	<cfreturn workingData>

</cffunction>



<cffunction name="parseJoin" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<cfset var workingData = arguments.request>
	<cfset workingData.name = listGetAt(workingData.requestString, 2, " ")>
	<cfset workingData.table = deCamelCase(pluralize(workingData.name))>
	<cfset workingData.parentModel = listGetAt(workingData.requestString, 4, " ")>
	<cfset workingData.parentTable = #deCamelCase(pluralize(workingData.parentModel))#>

	<cfreturn workingData>

</cffunction>

<cffunction name="parseBind" access="public" output="false" returnType="struct">
	<cfargument name="request" type="struct" required="true" hint="this is the current structure as being processed">

	<cfset var workingData = arguments.request>
	<cfset workingData.firstModel = listGetAt(workingData.requestString, 2, " ")>
	<cfset workingData.firstTable = deCamelCase(pluralize(listGetAt(workingData.requestString, 2, " ")))>
	<cfset workingData.firstTableFK = deCamelCase(listGetAt(workingData.requestString, 2, " "))>
	
	<cfset workingData.secondModel = listGetAt(workingData.requestString, 4, " ")>
	<cfset workingData.secondTable = deCamelCase(pluralize(listGetAt(workingData.requestString, 4, " ")))>
	<cfset workingData.secondTableFK = deCamelCase(listGetAt(workingData.requestString, 4, " "))>

	<cfset workingData.name = listGetAt(workingData.requestString, 6, " ")>
	<cfset workingData.table = deCamelCase(pluralize(listGetAt(workingData.requestString, 6, " ")))>


	<cfset workingData.indexStart = find("(",workingData.requestString)  + 1>
	<cfset workingData.indexEnd = find( ")",workingData.requestString)>
	<cfset workingData.indexCount = workingData.indexEnd - workingData.indexStart>
	
	<cfset workingData.paramString = mid(workingData.requestString, workingData.indexStart, workingData.indexCount)>
	<cfset workingData.params = listtoArray(workingData.paramString, ",")>


	<cfreturn workingData>

</cffunction>





<cffunction name="translateDataType" access="public" output="false" returnType="struct">
	<cfargument name="type" type="string" required="true" hint="">
	
	<cfset var ret = structNew()>
	
	<cfswitch expression="#arguments.type#">
	
	<cfcase value="string">
		<cfset ret.type = "varchar2">
		<cfset ret.length = "50">
	</cfcase>


	<cfcase value="text">
		<cfset ret.type = "varchar2">
		<cfset ret.length = "500">
	</cfcase>
	
	<cfcase value="number">
		<cfset ret.type = "number">
		<cfset ret.length = "6">
	</cfcase>	
	
	<cfcase value="int">
		<cfset ret.type = "number">
		<cfset ret.length = "6">
	</cfcase>
	
	<cfcase value="date">
		<cfset ret.type = "date">
		<cfset ret.length = "">
	</cfcase>
	

	<cfcase value="boolean">
		<cfset ret.type = "number">
		<cfset ret.length = "1">
	</cfcase>
	
					
	</cfswitch>
	
	<cfreturn ret>
	
</cffunction>


</cfcomponent>