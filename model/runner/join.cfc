<cfcomponent>

<cfproperty name="scaffoldService" inject="id:scaffoldService" >
<cfproperty name="consoleConfig" inject="coldbox:setting:consolation" >


<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">

	<cfset var result = {}>
	
	<cfset result.messages = []>	
	<cfset result.response = {}>


	<cfset changeKey = createUUID()>
	<cfset formatedTableName = #scaffoldService.deCamelCase(consoleRequest.table)#>
	<cfset formatedParentModel = #scaffoldService.deCamelCase(consoleRequest.parentModel)#>

	<cfsavecontent variable="alterTableSQL">	
	<cfoutput>
	<!---todo: move to db service --->	
	alter table #consoleConfig.dbo#.#formatedTableName# add  #formatedParentModel#_id numeric 
	</cfoutput>
	</cfsaveContent>
	
	
	<cftry>
	
	<!--- execute the sql --->
	<cfquery  datasource="#consoleConfig.dsn#">
		#preserveSingleQuotes(alterTableSQL)#
	</cfquery>
	
		<cfset arrayAppend(result.messages, "table altered")>
	
		<cfcatch >
			<cfset arrayAppend(result.messages, "table could not be altered: #cfcatch.Detail#")>
		</cfcatch>
		
	</cftry>	
	
	
	
		
		

	
	<cfreturn result.messages>
</cffunction>

</cfcomponent>