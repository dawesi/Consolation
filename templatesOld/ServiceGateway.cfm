<!--- for each table we will create a prefix for sql. start with primary table  --->
<cfset table_prefix = lcase(left(consoleRequest.tablename, 1))>
<!--- get an array  of all the tables with f-keys --->
<cfset fTables = scaffoldService.getfkTables(consoleRequest.tableName)>

<cfsavecontent variable="gatewayCode">

<cfoutput>
#chr(60)#cfcomponent  displayname="#consoleRequest.name#Service" extends="#consoleRequest.name#" output="false">
	

<!--- get a list of all primary table columns and filter out any matching colums from foriegn tables --->
<cfset primaryTableColumnList = valueList(qColumns.name, ",")>

<!--- create two lists to keep track of what table aliases we've used' --->
<cfset usedPrefixList = left(consoleRequest.tableName, 1)>
<cfset usedPrefixListForJoins = left(consoleRequest.tableName, 1)>





#chr(60)#!--- LIST METHOD FOR CFC --->
#chr(60)#!--- --------------------------------- --->
	

#chr(60)#cffunction name="list" access="public" output="false" returntype="query">

	<cfloop from="1" to="#arrayLen(fTables)#" index="i">
		#chr(60)#cfargument name="#scaffoldService.findComponent(fTables[i][1])#ID" type="numeric" required="false" hint="send to filter results on fkey">
	</cfloop>
	

	


	#chr(60)#cfset var #lcase(consoleRequest.tableName)#Result = super.list(

			<cfloop from="1" to="#arrayLen(fTables)#" index="i">
				#scaffoldService.singularize(fTables[i][1])#ID = ##arguments.#scaffoldService.findComponent(fTables[i][1])#ID##,
			</cfloop>

	)>
	

#chr(60)#/cffunction>
#chr(60)#/cfcomponent>
	
</cfoutput>
	</cfsavecontent>