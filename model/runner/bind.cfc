<cfcomponent>

<cfproperty name="scaffoldService" inject="id:scaffoldService" >
<cfproperty name="schemaChangeService" inject="id:schemaChangeService" >
<cfproperty name="consoleConfig" inject="coldbox:setting:consolation" >

<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">


	<cfset var result = {}>
	
	<cfset result.messages = []>	
	<cfset result.response = {}>




<cfset changeKey = createUUID()>
		
<cfsavecontent variable="alterTableSQL">	
	<cfoutput>alter table #consoleConfig.dbo#.#consoleRequest.table# add ( #consoleRequest.firstModel#_id number(9), #consoleRequest.secondModel#_id number(9) )</cfoutput>
</cfsaveContent>

<cfsavecontent variable="alterTableFK1SQLDown">	
	<cfoutput>alter table #consoleConfig.dbo#.#consoleRequest.table# drop column #consoleRequest.firstModel#_id;</cfoutput>
</cfsaveContent>
<cfsavecontent variable="alterTableFK2SQLDown">	
	<cfoutput>alter table #consoleConfig.dbo#.#consoleRequest.table# drop column #consoleRequest.secondModel#_id;</cfoutput>
</cfsaveContent>


<!--- execute the sql --->
<cfquery  datasource="#consoleConfig.dsn#">
#preserveSingleQuotes(alterTableSQL)#
</cfquery>


	
	<cfreturn result.messages>
</cffunction>

</cfcomponent>