<cfcomponent>
	<cfproperty name="dbService" inject="id:dbService" >
	<cfproperty name="scaffoldService" inject="id:scaffoldService" >

	<cfproperty name="consoleConfig" inject="coldbox:setting:consolation" >	


<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">
		
	<!--- services --->
	<cfset var result = {}>
	
	<cfset result.messages = []>	
	<cfset result.response = {}>
	
	<cfset var tableSQL = "">	

<cfsavecontent variable="tableSQL">	
<cfoutput>
	create table #dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#
	(
	 #scaffoldService.writeID()#
	 
		<cfloop array="#consoleRequest.params#" index="p">
			#scaffoldService.getStatement(p)#,
		</cfloop>
		#scaffoldService.writeBoilerPlate()#
	)
	
</cfoutput>
</cfsavecontent>


	<cfset tableDropSQL = 'drop table #dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#'>



	<cftry>
			<cfquery  datasource="#consoleconfig.dsn#">
			drop table #dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#
			</cfquery>
			<cfset arrayAppend(result.messages, "table was dropped")>
		<cfcatch>
		</cfcatch>
	</cftry>




	<cftry>
		<cfquery  datasource="#consoleconfig.dsn#">
		#preserveSingleQuotes(tableSQL)#
		</cfquery>
		
		<cfset arrayAppend(result.messages, "table created")>
		<cfcatch>		
			<cfset arrayAppend(result.messages, "Model failed to be created: #cfcatch.Detail#  // #cfcatch.message# // #cfcatch.sql#")>
				
			<cfdump var="#cfcatch#">	
		</cfcatch>
		
		</cftry>
		

	
	<cfreturn result.messages>
	
	
	
	
	
</cffunction>

</cfcomponent>