<cfcomponent  displayname="scaffolder" output="false" extends="scaffoldUtility">
	
<cffunction name="writeUpdatePair" access="public" output="false" returntype="string">
			<cfargument name="name" type="string" required="true">
			<cfargument name="column" type="string" required="true">
			<cfargument name="type" type="string" required="true">
			<cfargument name="required" type="boolean" required="false" default="false">
			<cfset var output = "">


	<cfset userInput = camelCase(arguments.name)>


<cfset output = '<cfif isDefined("arguments.data.#name#")>#chr(10)#'>
			<cfset output = '#output##column# = #wrapAsParam(name,type)##chr(10)#'>
		


<cfset output = '#output#,</cfif>#chr(10)#'>

			<cfreturn output>
			
	</cffunction> 


<cffunction name="wrapAsParam" access="public" output="false" returntype="string">
			<cfargument name="name" type="string" required="true">
			<cfargument name="type" type="string" required="true">
			<cfset var output = "">
		
		<cfset arguments.name = camelCase(arguments.name)>
		
	<cfswitch expression="#arguments.type#">

		<cfcase value="text,textarea" delimiters=",">
			<cfset output = '<cfqueryparam cfsqltype="cf_sql_varchar" value="##superHtmlEditFormat(arguments.data.#arguments.name#)##">'>
		</cfcase>
		
		<cfcase value="number">
			<cfset output = '<cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.#arguments.name###">'>
		</cfcase>	
			
		<cfcase value="date">
			<cfset output = '<cfqueryparam cfsqltype="cf_sql_date" value="##arguments.data.#arguments.name###">'>
		</cfcase>				

		<cfcase value="boolean">
			<cfset output = '<cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.#arguments.name###">'>
		</cfcase>	

		<cfdefaultcase>
			<cfset output = '<cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.#arguments.name###">'>
		</cfdefaultcase>
	</cfswitch>
			
			<cfreturn output>
			
</cffunction> 

<cffunction name="writeWhereClause" access="public" output="false" returntype="string">
			<cfset var output = "">
			<cfset output = 'WHERE id = <cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.id##">'>
			<cfreturn output>
			
	</cffunction> 


<cffunction name="init" returntype="sqlWriter">	


		<cfreturn this>
		
	</cffunction>
	
</cfcomponent>