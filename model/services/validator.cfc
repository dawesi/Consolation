<cfcomponent  displayname="scaffolder" output="false" extends="scaffoldUtility">


<cffunction name="validateField" access="public" output="false" returntype="string">
		<cfargument name="label" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="required" type="string" required="true" default="true">
		<cfargument name="max" type="numeric" required="true">
		<cfargument name="precision" type="any" required="false" default="0">
		<cfargument name="source" type="string" required="false" default="">
		
		<cfset arguments.name = camelCase(arguments.name)>
		
					
<cfset output2 = '
<cfif not isDefined("form.#arguments.name#") '>

<cfif arguments.type neq "date">
	<cfset output2 = '#output2# OR  len(form.#arguments.name#) gt #arguments.max#'>'>
</cfif>	

<cfif arguments.required eq "yes">
	<cfset output2 = '#output2# OR len(form.#arguments.name#) eq 0'>
</cfif>
			
<cfif arguments.type eq "number" and arguments.required>
	<cfset output2 = '#output2# OR not isNumeric(form.#arguments.name#)'>
</cfif>

<cfif arguments.type eq "number" and not arguments.required>
	<cfset output2 = '#output2# OR( len(form.#arguments.name#) neq 0 AND not isNumeric(#arguments.name#) )'>
</cfif>
			
			
<cfif arguments.type eq "date"><cfset output2 = '#output2# OR not isDate(form.#arguments.name#) '></cfif>
<cfset output2 = '#output2# >
	<cfset exec = arrayAppend(errorMessages,   "#arguments.label# is required and must be #arguments.max# characters or less")> '>
	<cfset output2 = '#output2# 
</cfif>
'>		
		
		<cfreturn output2>
		
</cffunction> 




<cffunction name="validateProperty" access="public" output="false" returntype="string">

	<cfargument name="label" type="string" required="true">
	<cfargument name="name" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfargument name="required" type="string" required="true" default="true">
	<cfargument name="max" type="numeric" required="true">
	<cfargument name="precision" type="any" required="false" default="0">
	<cfargument name="source" type="string" required="false" default="">
	
	<cfset arguments.name = camelCase(arguments.name)>
					
<cfset output2 = '
<cfif not isDefined("arguments.data.#arguments.name#") '>

<cfif arguments.type neq "date">
	<cfset output2 = '#output2# OR  len(arguments.data.#arguments.name#) gt #arguments.max#'>'>
</cfif>	

<cfif arguments.required eq "yes">
	<cfset output2 = '#output2# OR len(arguments.data.#arguments.name#) eq 0'>
</cfif>
			
<cfif arguments.type eq "number" and arguments.required>
	<cfset output2 = '#output2# OR not isNumeric(arguments.data.#arguments.name#)'>
</cfif>

<cfif arguments.type eq "number" and not arguments.required>
	<cfset output2 = '#output2# OR( len(arguments.data.#arguments.name#) neq 0 AND not isNumeric(arguments.data.#arguments.name#) )'>
</cfif>
			
			
<cfif arguments.type eq "date"><cfset output2 = '#output2# OR not isDate(arguments.data.#arguments.name#) '></cfif>
	<cfset output2 = '#output2# >
	<cfset exec = arrayAppend(errorMessages,   "#arguments.label# is required and must be #arguments.max# characters or less")> '>
	<cfset output2 = '#output2# 
</cfif>

'>		
		
		<cfreturn output2>
</cffunction> 





<cffunction name="setupValidation" returntype="string">
	<cfset output = '
		<cfif isDefined("form.action") and form.action eq "submit">
	'>
	<cfreturn output>
</cffunction>




	
<cffunction name="completeValidation" returntype="string">
	<cfreturn'</cfif>'>
</cffunction>



<cffunction name="setupCFCValidation" returntype="string">
	<cfset output = '
		<cfset var errorMessages = arrayNew(1)>'>
	<cfreturn output>
</cffunction>

<cffunction name="completeCFCValidation" returntype="string">
	<cfreturn "">
</cffunction>





<cffunction name="cfcErrorHandling" returntype="string">
	<cfargument name="section" required="false" type="string" default="Home">
<cfset output ='
	<cfif arrayLen(errorMessages)>
		<cfset response.isValid=false>
		<cfset response.messages = errorMessages>
	<cfelse>
		<cfset response.isValid=true>
	</cfif>
	
	<cfreturn response>
'>
	
	<cfreturn output>
	
</cffunction>

	
</cfcomponent>