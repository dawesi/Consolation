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
	alter table #consoleConfig.dbo#.#formatedTableName# add ( #formatedParentModel#_id number(9) )
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
	
	
	
	<!--- capature sql to database --->
	<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=alterTableSQL, addedBy=1000)>
	
	
	<cfset fkSQL = schemaChangeService.generateFKSql(table=formatedTableName, fkTable=consoleRequest.parentTable, column="#formatedParentModel#_id", dbo=consoleConfig.dbo)>
				
					<cftry>
					<cfquery  datasource="#consoleConfig.dsn#">
					#fkSQL.up#
					</cfquery>
					
					<cfset exec = schemaChangeService.add(migrationID=1000, object=formatedTableName, sqlStatement=fkSQL.up, addedBy=1000)>
					<cfset exec = schemaChangeService.add(migrationId=1000, object=formatedTableName, sqlStatement=fkSQL.down, direction="D", addedBy=1000)>
					
					<cfset arrayAppend(result.messages, "Created Foriegn Key Constraint fk_#formatedTableName#_to_#formatedParentModel#")>
		
					<cfcatch>
												
						<cfset arrayAppend(result.messages, "Could not created Foriegn Key: #cfcatch.detail#")>
						<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=fkSQL.up, direction="C", addedBy=1000)>
	
					</cfcatch>		
					</cftry>
	
	
				<cfset indexSQL = schemaChangeService.generateIndexSql(table=formatedTableName, columns="#formatedParentModel#_id", dbo=consoleConfig.dbo)>
				
					<cftry>
					<cfquery  datasource="#consoleConfig.dsn#">
					#indexSQL#
					</cfquery>
					
					<cfset exec = schemaChangeService.add(migrationID=1000, object=formatedTableName, sqlStatement=indexSQL, addedBy=1000)>
					
					<cfset arrayAppend(result.messages, "Created Index on Foriegn Key Constraint i_#formatedTableName#_#formatedParentModel#")>
		
					<cfcatch>
												
						<cfset arrayAppend(result.messages, "Could not created index: #cfcatch.detail# // #cfcatch.sql#")>
						<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=indexSQL, direction="C", addedBy=1000)>
	
					</cfcatch>		
					</cftry>
	
		
		

	
	<cfreturn result.messages>
</cffunction>

</cfcomponent>