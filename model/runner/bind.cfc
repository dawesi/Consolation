<cfcomponent>

<cfproperty name="scaffoldService" inject="id:scaffoldService" >
<cfproperty name="schemaChangeService" inject="id:schemaChangeService" >

<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">
	<cfargument name="consoleConfig" type="struct" required="true" hint="">

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

<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=alterTableSQL, addedBy=1000)>
<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=alterTableFK1SQLDown, direction="D", addedBy=1000)>
<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=alterTableFK2SQLDown, direction="D", addedBy=1000)>


<cfset fkSQL = schemaChangeService.generateFKSql(table=consoleRequest.table, fkTable=consoleRequest.firstTable, column="#consoleRequest.firstModel#_id", dbo=consoleConfig.dbo)>
<cfset fkSQL2 = schemaChangeService.generateFKSql(table=consoleRequest.table, fkTable=consoleRequest.secondTable, column="#consoleRequest.secondModel#_id", dbo=consoleConfig.dbo)>
				
				<cftry>
						
				<cfquery  datasource="#consoleConfig.dsn#">
				#fkSQL.up#
				</cfquery>
				
				<cfquery  datasource="#consoleConfig.dsn#">
				#fkSQL2.up#
				</cfquery>
				
				<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.firstTable, sqlStatement=fkSQL.up, addedBy=1000)>
				<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.firstTable, sqlStatement=fkSQL.down, direction="D", addedBy=1000)>
		
				<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.secondTable, sqlStatement=fkSQL2.up, addedBy=1000)>
				<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.secondTable, sqlStatement=fkSQL2.down, direction="D", addedBy=1000)>
				
				
				<p>Created Foriegn Key Constraint</p>
				
				

				<cfcatch>
						
				<cfoutput>			

					<p>Could not create Foriegn Key Constraint</p>
					<p>#cfcatch.Message#</p>

					<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.firstTable, sqlStatement=fkSQL.up, direction="D", addedBy=1000)>
					<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.secondTable, sqlStatement=fkSQL2.up, direction="D", addedBy=1000)>


				</cfoutput>		
				
				</cfcatch>		
				</cftry>

	
					<cftry>

					<cfset indexSQL = schemaChangeService.generateIndexSql(table=consoleRequest.table, columns="#consoleRequest.firstModel#_id", dbo=consoleConfig.dbo)>
					<cfquery  datasource="#consoleConfig.dsn#">#indexSQL#</cfquery>
					<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=indexSQL, addedBy=1000)>
					
					<cfset indexSQL = schemaChangeService.generateIndexSql(table=consoleRequest.table, columns="#consoleRequest.secondModel#_id", dbo=consoleConfig.dbo)>
					<cfquery  datasource="#consoleConfig.dsn#">#indexSQL#</cfquery>
					<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=indexSQL, addedBy=1000)>
					
					<cfset indexSQL = schemaChangeService.generateIndexSql(table=consoleRequest.table, columns="#consoleRequest.firstModel#_id,#consoleRequest.secondModel#_id", dbo=consoleConfig.dbo)>
					<cfquery  datasource="#consoleConfig.dsn#">#indexSQL#</cfquery>
					<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=indexSQL, addedBy=1000)>
					
					
					<cfset arrayAppend(result.messages, "Created Indexes on Foriegn Keys")>
		
					<cfcatch>
												
						<cfset arrayAppend(result.messages, "Could not created indexes: #cfcatch.detail#")>
						
	
					</cfcatch>		
					</cftry>
	
		
	
	<cfreturn result.messages>
</cffunction>

</cfcomponent>