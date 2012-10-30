<cfset table_prefix = lcase(left(consoleRequest.tablename, 1))>
<cfset fTables = dbService.getfkTables(consoleRequest.tableName)>



<cfsavecontent variable="cfcCode">
<cfoutput>
#chr(60)#!--- generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified --->
#chr(60)#cfcomponent  displayname="#consoleRequest.name#" extends="baseModel" output="false">


<cfdump var="#columns#" format="text" >

<!--- get a list of all primary table columns and filter out any matching colums from foriegn tables --->
<cfset primaryTableColumnList = valueList(qColumns.name, ",")>

<!--- create two lists to keep track of what table aliases we've used' --->
<cfset usedPrefixList = left(consoleRequest.tableName, 1)>
<cfset usedPrefixListForJoins = left(consoleRequest.tableName, 1)>

#chr(60)#cffunction name="getTableName" access="private" output="false" returntype="string">
	#chr(60)#cfreturn "#consoleRequest.tableName#">
#chr(60)#/cffunction>	
	

#chr(60)#!--- LIST METHOD FOR CFC --->
#chr(60)#!--- --------------------------------- --->
	

#chr(60)#cffunction name="list" access="public" output="false" returntype="query">
	
	#chr(60)#cfargument name="id" type="numeric" required="false" hint="send id to return single item">
	
	<cfloop from="1" to="#arrayLen(fTables)#" index="i">
		<!--- error: returning black --->
		<cfif len(scaffoldService.findComponent(fTables[i][1]))>
		#chr(60)#cfargument name="#scaffoldService.findComponent(fTables[i][1])#ID" type="numeric" required="false" hint="send to filter results on fkey">
		</cfif>
	</cfloop>
	
	#chr(60)#cfset var #lcase(consoleRequest.tableName)#Q = false>

	#chr(60)#cfquery name="#lcase(consoleRequest.tableName)#Q" datasource="##getDSN()##">
		SELECT		

</cfoutput>
<cfoutput>
	#lcase(table_prefix)#.id as id,
	#lcase(table_prefix)#.added_by as addedBy,
	#lcase(table_prefix)#.updated_by as updatedBy,
	#lcase(table_prefix)#.added_on as addedOn,
	#lcase(table_prefix)#.updated_on as updateOn,
	#lcase(table_prefix)#.is_deleted as isDeleted,
	#lcase(table_prefix)#.sort_order as sortOrder,

	<cfset index = 1>
	<cfloop array="#columns#" index="col">
		#chr(13)##chr(9)##chr(9)# #lcase("#table_prefix#.#col.column#")# as 	#col.name# <cfif index neq columns.size()>,</cfif> 
		<cfset index++>
	</cfloop>

</cfoutput>			

	<cfoutput>
    		<!--- loop through fk tables and list cols remivng dates and user ids  --->	 
			FROM ##getDbo()##.<cfoutput>#lcase(consoleRequest.tableName)# #lcase(table_prefix)#</cfoutput>  

			WHERE (<cfoutput>#lcase(table_prefix)#.is_deleted = 0 OR #lcase(table_prefix)#</cfoutput>.is_deleted IS NULL)
			
		#chr(60)#cfif isDefined("arguments.id")>		
			AND #table_prefix#.id = #chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.id##">
		#chr(60)#/cfif>


			<cfloop from="1" to="#arrayLen(fTables)#" index="i">
				#chr(60)#cfif isDefined("arguments.#scaffoldService.findComponent(fTables[i][1])#ID")>
			AND #lcase(table_prefix)#.#scaffoldService.singularize(fTables[i][1])#_id = #chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.#scaffoldService.findComponent(fTables[i][1])#ID##">
			#chr(60)#/cfif>
			</cfloop>

	
	ORDER BY #lcase(table_prefix)#.sort_order
	
	#chr(60)#/cfquery>	
	
	#chr(60)#cfreturn #lcase(consoleRequest.tableName)#Q/>
	
	
	
#chr(60)#/cffunction>




#chr(60)#!--- GET METHOD FOR CFC --->
#chr(60)#!--- --------------------------------- --->
	

#chr(60)#cffunction name="get" access="public" output="false" returntype="query">
	#chr(60)#cfargument name="id" type="numeric" required="true" hint="send id to return single item">

	#chr(60)# cfset result = list(id=id)>
	#chr(60)#cfreturn result/>
	
#chr(60)#/cffunction>

</cfoutput>





<cfset listI = 0>
<!--- changed so all attributes are not required --->
<cfsavecontent variable="argumentOut">
<cfloop query="qColumns"><cfsilent>
		<cfset listI++>
		<cfset type = qColumns.type>
		<cfset name = qColumns.name>
		<!--- search the inputs and find the value if the field is passed in --->
		<cfset req = "no">
		<cfif req eq "no">
			<cfset req = false>
		<cfelse>
			<cfset req = false>
		</cfif>
		
			<cfif qColumns.currentrow eq qColumns.recordcount>
				<cfset isLast= 1>
			<cfelse>
				<cfset isLast = 0>
			</cfif>

	</cfsilent><cfif NOT listFindNoCase("id,updated_by,updated_date,added_by,added_date,sort_order", name, ",")><cfoutput>#cfcObjectService.writeArgument(type=type,name=name,required=req)#</cfoutput></cfif></cfloop>
</cfsavecontent>




<cfoutput>
	
	#chr(60)#!--- ADD METHOD FOR CFC --->
	#chr(60)#!--- --------------------------------- --->
	


#chr(60)#cffunction name="add" access="public" output="false" returntype="numeric">
	
	#chr(60)#cfargument name="data" type="struct" required="true">
			
	<cfset listI = 0>
</cfoutput>
	
	<cfsavecontent variable="sqlCode">
	<cfoutput>
	#chr(60)#cfquery datasource="##getDSN()##">
	INSERT INTO ##getDbo()##.#lcase(consoleRequest.tableName)# 
	(<cfloop query="qColumns">
		<cfif not listFindNoCase("id,sort_order,added_on,updated_on,added_by,updated_by", qColumns.name, ",")>#lcase(qColumns.name)#, </cfif></cfloop>sort_order, added_by, updated_by,added_on,updated_on)
	
	VALUES (
	
	<cfloop array="#columns#" index="col">
		<cfif not listFindNoCase("id,added_on,updated_on,added_by,updated_by,sort_order", col.column, ",")>
			#chr(60)#cfif isDefined("arguments.data.#col.Name#")>
			#sqlWriterService.wrapAsParam(type=col.field,name=col.Name)# #chr(60)#cfelse><cfif col.field eq "boolean">0<cfelse>NULL</cfif>#chr(60)#/cfif>,
		</cfif>
	</cfloop>
		
		#chr(60)#cfif isDefined("arguments.data.sortOrder")>
		#chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.sortOrder##"> #chr(60)#cfelse>50#chr(60)#/cfif>,
		
		
		#chr(60)#cfif isDefined("arguments.data.addedBy")>
		#chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.addedBy##"> #chr(60)#cfelse>0#chr(60)#/cfif>,
		
		#chr(60)#cfif isDefined("arguments.data.addedBy")>
		#chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.addedBy##"> #chr(60)#cfelse>0#chr(60)#/cfif>,
		
	
	getDate(),
	getDate()
	)
	#chr(60)#/cfquery>
	
	#chr(60)#cfset var newID = getLastID()>
	#chr(60)#cfreturn newid>
	
	</cfoutput>
	</cfsavecontent>
				
<cfoutput>
	#sqlCode#

	#chr(60)#cfreturn ##newId##>
	
#chr(60)#/cffunction>

</cfoutput>

<cfoutput >


#chr(60)#!--- UPDATE METHOD FOR CFC --->
#chr(60)#!--- --------------------------------- --->




#chr(60)#cffunction name="update" access="public" output="false" returntype="void">


	#chr(60)#cfargument name="id" type="numeric" required="true">
	#chr(60)#cfargument name="data" type="struct" required="true">

	<cfset listI = 0>

</cfoutput>
				
	<cfsavecontent variable="sqlCode">
	<cfoutput>

	#chr(60)#cfquery datasource="##getDSN()##">
	UPDATE ##getDbo()##.#lcase(consoleRequest.tableName)# 
	SET
	<cfloop array="#columns#" index="col">
	#sqlWriterService.writeUpdatePair(type=col.field,name=col.name,column=col.column )##chr(10)#
	</cfloop>
	
	
	
	#chr(60)#cfif isDefined("arguments.data.sortOrder")>
	sort_order = #chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.sortOrder##"> , #chr(60)#/cfif>
	
	#chr(60)#cfif isDefined("arguments.data.updatedBy")>
	updated_by = #chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##arguments.data.updatedBy##"> , #chr(60)#/cfif>
	updated_on = getDate()
	
		#chr(60)#cfif isDefined("variables.ID")>
			WHERE #table_prefix#.id = #chr(60)#cfqueryparam cfsqltype="cf_sql_numeric" value="##variables.ID##">
		#chr(60)#cfelse>
			#sqlWriterService.writeWhereClause()#		
		#chr(60)#/cfif>
		
	#chr(60)#/cfquery>
	</cfoutput>
	</cfsavecontent>

	<cfoutput>
	#sqlCode#

#chr(60)#/cffunction>	

</cfoutput>




<cfset listI = 0>
<!--- changed so all attributes are not required --->
<cfsavecontent variable="cfcArgumentOut">
<cfloop query="qColumns"><cfsilent>
		<cfset listI++>
		<cfset type = qColumns.type>
		<cfset name = qColumns.name>
		<!--- search the inputs and find the value if the field is passed in --->
		<cfset req = "no">
		<cfif req eq "no">
			<cfset req = false>
		<cfelse>
			<cfset req = false>
		</cfif>
		
			<cfif qColumns.currentrow eq qColumns.recordcount>
				<cfset isLast= 1>
			<cfelse>
				<cfset isLast = 0>
			</cfif>

	</cfsilent><cfif NOT listFindNoCase("id,updated_by,updated_date,added_by,added_date", name, ",")><cfoutput>		#cfcObjectService.writeArgument(isForValidation=true,type=type,name=name,required=req)#</cfoutput></cfif></cfloop>
</cfsavecontent>

	

<cfoutput>


#chr(60)#!--- validation METHOD FOR CFC --->
#chr(60)#!--- --------------------------------- --->

#chr(60)#cffunction name="validate" access="public" output="false" returntype="struct">
	#chr(60)#cfargument name="data" type="struct" required="true">	

#validatorService.setupCFCValidation()#

<!--- check for the existence of ID, if not, then add otherwise edit record with ID --->
#chr(60)#cfif not isDefined("arguments.data.id") or not isNumeric(arguments.data.id)>

	#chr(60)#cfif not isDefined("arguments.data.Addedby")  OR  len(arguments.data.Addedby) gt 10 OR len(arguments.data.Addedby) eq 0 OR not isNumeric(arguments.data.Addedby) >
		#chr(60)#cfset exec = arrayAppend(errorMessages,   "Added by is required and must be 10 characters or less")>  
	#chr(60)#/cfif>
		#chr(60)#cfset response.type="add"> 

#chr(60)#cfelse>

	#chr(60)#cfif not isDefined("arguments.data.Id")  OR  len(arguments.data.Id) gt 10 OR len(arguments.data.Id) eq 0 OR not isNumeric(arguments.data.Id) >
		#chr(60)#cfset exec = arrayAppend(errorMessages,   "id is required and must be 10 characters or less")>  
	#chr(60)#/cfif>
	
	#chr(60)#cfset response.type="edit"> 

	
#chr(60)#/cfif>

<cfloop query="qColumns"><cfsilent>
<!--- todo: make this a function --->
		<cfset p = {}>
		<cfset p.type = qColumns.type>
		<cfset p.name = qColumns.name>
		<cfset p.length = qColumns.length>
		<cfset p.precision = qColumns.precision>	
		
		
		<cfset fieldParams = scaffoldService.getFieldElements(p)>
		
		<cfset fieldParams.required = isRequired(qColumns.name, consoleRequest.params)>


	</cfsilent>	

	<cfif not listFindNoCase("updated_by,updated_on,updated_by,added_by", fieldParams.name, ",")>
		#validatorService.validateProperty(type=fieldParams.type,name=fieldParams.name,max=fieldParams.max,label=fieldParams.label,required=fieldParams.required)#
	</cfif>

</cfloop>


#validatorService.cfcErrorHandling(section=consoleRequest.tableName)#

#chr(60)#/cffunction>


#chr(60)#/cfcomponent>
</cfoutput>

	
	</cfsavecontent>