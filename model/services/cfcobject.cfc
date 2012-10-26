<cfcomponent output="false" extends="scaffoldUtility">

<cffunction name="writeArgument" access="public" output="false" returntype="string">
	<cfargument name="name" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfargument name="required" type="string" required="false" default="false">
	<cfargument name="isForValidation" type="Boolean" required="false" default="false">
	<cfset var output = "">
	
	<cfset arguments.name = camelCase(arguments.name)>
	
	<cfif arguments.isForValidation>
		<cfset output = '<cfargument name="#arguments.name#" type ="any" required="false" default="">
'>
	<cfelse>
		<cfset output = '<cfargument name="#arguments.name#" type ="#transType(arguments.type)#" required="#arguments.required#">
'>
	</cfif>
			
	<cfreturn output>
			
</cffunction> 


<cffunction name="transType" access="public" output="false" returntype="string">
			<cfargument name="type" type="string" required="true">
			<cfset var retType = "">
			
	<cfswitch expression="#arguments.type#">

		<cfcase value="varchar2">
			<cfset retType = "string">
		</cfcase>
		
		<cfcase value="number">
			<cfset retType = "numeric">
		</cfcase>	
			
		<cfcase value="date">
			<cfset retType = "date">
		</cfcase>				
		
		<cfdefaultcase>
			<cfset retType = "any">
		</cfdefaultcase>

	</cfswitch>
			
			<cfreturn retType>
			
</cffunction> 




<cffunction  name="writeCode" access="public" returntype="string" output="false">
	<cfargument name="argumentList"  type="string"  required="true">	
	<cfargument name="methodCall"  type="string" required="true">
	<cfargument name="cfcName"  type="string" required="true">

	<cfset var cfcCode = "">
	
	<cfif arguments.methodCall eq "update">
		<cfset retVarName = "exec">
	<cfelse>
		<cfset retVarName = "newID">
	</cfif>
	
<cfset listI = 0>

<cfset cfcCode = '
		<cfset #retVarName# = application.com.#arguments.cfcName#.#arguments.methodCall#(
'>

<cfloop from="1" to="#listLen(arguments.argumentList)#" index="i">
	<cfset listI++>
	
	<cfset name = listGetAt(arguments.argumentList, i)>
	
	<cfif not listFindNoCase("updated_date,added_date,updated_by,added_by,id", name, ",")>
	<cfset cfcCode = '#cfcCode# 
			#camelCase(name)# = form.#camelCase(name)#,'>
	</cfif>
</cfloop>

	<cfif arguments.methodCall eq "update">
		<cfset cfcCode = '#cfcCode#
			updatedBy = session.visit.userid,
			id = url.id
			)>'>
	<cfelse>
		<cfset cfcCode = '#cfcCode#
			updatedBy = session.visit.userid,
			addedBy = session.visit.userid
			)>'>
	</cfif>

	<cfreturn cfcCode>


</cffunction>


<cffunction name="init" returntype="cfcobject">	
	<cfreturn this>		
</cffunction>




</cfcomponent>