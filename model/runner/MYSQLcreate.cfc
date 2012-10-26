<cfcomponent>

	<cfproperty name="scaffoldService" inject="id:scaffoldService" >
	<cfproperty name="schemaChangeService" inject="id:schemaChangeService" >



<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">
	<cfargument name="consoleConfig" type="struct" required="true" hint="">
		
	<!--- services --->
	<cfset var result = {}>
	
	<cfset result.messages = []>	
	<cfset result.response = {}>
	
	<cfset var tableSQL = "">	
	<cfset consoleRequest = arguments.consoleRequest>
	

<cfsavecontent variable="tableSQL">	
<cfoutput>
	create table #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#
	(
	id number,
	<cfloop array="#consoleRequest.params#" index="p">
	
	
		
		<cfif listLen(p, " ") gt 1>
			<cfset paramDetail = scaffoldService.translateType( listGetAt(p, 2, " ") )>	
			
		<cfelse>
			<cfset paramDetail = scaffoldService.translateType( "string" )>	
		</cfif>

		<cfset paramDetail.thirdAttr = "">
		<cfset paramDetail.fourthAttr = "">
		
		<cfif listLen(p, " ") gte 3>
			<cfset paramDetail.thirdAttr = listGetAt(p, 3, " ")>	
		</cfif>
		
		<cfif listLen(p, " ") gte 4>
			<cfset paramDetail.fourthAttr = listGetAt(p, 4, " ")>			
		</cfif>
		
		#scaffoldService.deCamelCase(listGetAt(p, 1, " "))# #paramDetail.type#<cfif len(paramDetail.thirdAttr) and isNumeric(paramDetail.thirdAttr)>(#paramDetail.thirdAttr#)<cfelseif len(paramDetail.length)>(#paramDetail.length#)</cfif>

		<!--- todo: make function --->
			<cfif paramDetail.default eq "sysdate"> DEFAULT sysdate
			<cfelseif paramDetail.type eq "Number" and len(paramDetail.default)> DEFAULT #paramDetail.default#
			<cfelseif len(paramDetail.default)> DEFAULT "#paramDetail.default#"
			</cfif>
		, 
	
	</cfloop>
	sort_order number(2) default 50,
	is_deleted number(1) default 0,
	updated_by number(6) default 0,
	updated_date date default sysdate,
	added_by number(6) default 0,
	added_date date default sysdate,
	primary key(id)
	)
	
</cfoutput>
</cfsavecontent>


	<cfset tableDropSQL = 'drop table #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#'>

		<cfsavecontent variable="grantQ">
			<cfoutput>GRANT DELETE, INSERT, SELECT, UPDATE ON #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)# TO #ucase(replaceNoCase(consoleConfig.dbo, "_admin", ""))#_U_ROLE</cfoutput>
		</cfsavecontent>
	
		<cfsavecontent variable="grantU">
			<cfoutput>GRANT SELECT ON #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)# TO #ucase(replaceNoCase(consoleConfig.dbo, "_admin", ""))#_Q_ROLE</cfoutput>
		</cfsavecontent>
		
		<!--- sequenes --->
		
		<cfset sequenceSQL  = "create sequence #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#_seq start with 1000 increment by 1">
		<cfset sequenceGrantSQL = 'GRANT SELECT ON #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#_seq TO #ucase(replaceNoCase(consoleConfig.dbo, "_admin", ""))#_Q_ROLE'>
		<cfset sequenceDropSQL  = "drop sequence #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#_seq">
	



	<cftry>
			<cfquery  datasource="#consoleConfig.dsn#">
			drop table #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#
			</cfquery>
			
			<!--- capture this drop statement if the table existed --->
			<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.Name, sqlStatement="drop table #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#",  direction="N", addedBy=1000)>
			<cfset arrayAppend(result.messages, "table was dropped")>

		<cfcatch>
		</cfcatch>
	</cftry>



	<cftry>		
		<cfquery  datasource="#consoleConfig.dsn#">
		drop sequence #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#_seq
		</cfquery>
		
		<!--- capture this drop statement if the sequence existed --->
			<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.name, sqlStatement="drop sequence #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#_seq", direction="N", addedBy=1000)>
			<cfset arrayAppend(result.messages, "sequence was dropped")>
	
		<cfcatch>
		</cfcatch>		
	</cftry>

	<cftry>
		<cfquery  datasource="#consoleConfig.dsn#">
		#preserveSingleQuotes(tableSQL)#
		</cfquery>
		
		<cfquery  datasource="#consoleConfig.dsn#">
		#preserveSingleQuotes(sequenceSQL)#
		</cfquery>

		<cfset arrayAppend(result.messages, "table and sequences were created")>
		<cfcatch>		
			<cfset arrayAppend(result.messages, "Model failed to be created: #cfcatch.Detail# ")>	
			<cfdump var="#cfcatch#">	
		</cfcatch>
		
		</cftry>
		
		
		<cftry>
		
		<cfquery  datasource="#consoleConfig.dsn#">
		#preserveSingleQuotes(grantQ)#
		</cfquery>
		
		
		<cfquery  datasource="#consoleConfig.dsn#">
		#preserveSingleQuotes(grantU)#
		</cfquery>
		
		
		<cfquery  datasource="#consoleConfig.dsn#">
		#preserveSingleQuotes(sequenceGrantSQL)#
		</cfquery>	
		
		<cfset arrayAppend(result.messages, "Grants has been created")>		
		
		<cfcatch>
			<cfset arrayAppend(result.messages, "Grants failed to be created: #cfcatch.Detail# #cfcatch.SQL#")>		
		</cfcatch>
		
		</cftry>
		
		
	<cftry>	
		<cfset exec = schemaChangeService.add(migrationID=1000, object=consoleRequest.name, sqlStatement=tableSQL, addedBy=1000)>
		<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.name, sqlStatement=sequenceSQL, addedBy=1000)>
		<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.name, sqlStatement=grantQ, addedBy=1000)>
		<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.name, sqlStatement=grantU, addedBy=1000)>
		<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.name, sqlStatement=sequenceGrantSQL, addedBy=1000)>
		
		<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.name, sqlStatement=tableDropSQL, direction="D", addedBy=1000)>
		<cfset exec = schemaChangeService.add(migrationId=1000, object=consoleRequest.name, sqlStatement=sequenceDropSQL, direction="D", addedBy=1000)>
	
	<cfcatch>
		<cfset arrayAppend(result.messages, "sql could not be captured: #cfcatch.Detail#")>	
	</cfcatch>
	
	</cftry>	

	
	<cfreturn result.messages>
	
	
	
	
	
</cffunction>

</cfcomponent>