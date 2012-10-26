<cfcomponent  displayname="schemachange" extends="editor" output="false">
		
		
<!--- INIT METHOD FOR CFC --->	
	
<cffunction name="init" access="public" output="false" returntype="schemachange">
	<cfargument name="id" type="numeric" required="false">
	<cfargument name="migrationID" type="numeric" required="false">
	
	<cfif isDefined("arguments.id")>
		<cfset variables.id = arguments.id>
	</cfif>

	<cfif isDefined("arguments.migrationID")>
		<cfset variables.migrationID = arguments.migrationID>
	</cfif>
	
	<cfreturn this/>
</cffunction>	
	
<!--- GET METHOD FOR CFC --->
<!--- --------------------------------- --->
	
<cffunction name="get" access="public" output="false" returntype="query">
	<cfargument name="id" type="numeric" required="false" hint="send id to return single item">
	<cfargument name="migrationId" type="numeric" required="false" hint="send id to return single item">
	<cfargument name="direction" type="string" required="false" default="U" hint="send id to return single item">
	<cfargument name="object" type="string" required="false" hint="send id to return single item">
	<cfset var q_schema_changes = false>
	
	<cfquery name="q_schema_changes" datasource="#application.dsn#">
		select		
		
		M.SORT_ORDER as sortOrderFromMigrations, M.ROUTE_DELIMITER as routeDelimiter, M.IS_BANNER as isBanner, M.TABLE_FILTER as tableFilter, M.DATASOURCE as datasource, M.DBO as dbo, 
		M.NETIDS as netids, M.DESCRIPTION as description, M.IS_DELETED as isDeletedFromMigrations, M.TARGET_VERSION as targetVersion, M.APPLICATION_ID as applicationId, 
		M.NAME as nameFromMigrations, 
		
		s.OBJECT, S.MIGRATION_ID as migrationId, S.DIRECTION as direction, S.MIGRATION_KEY as migrationKey, S.ADDED_DATE as addedDate, S.ADDED_BY as addedBy, S.UPDATED_DATE as updatedDate, S.UPDATED_BY as updatedBy, S.IS_DELETED as isDeleted, S.SQL_STATEMENT as sqlStatement, S.ID as id, S.SORT_ORDER as sortOrder 			
			 
		from #application.dbo#.SCHEMA_CHANGES S 
			inner join #application.dbo#.MIGRATIONS M ON M.id = S.MIGRATION_ID 

		WHERE (S.is_deleted = 0 or S.is_deleted is null)
		
		
		<cfif isDefined("arguments.id")>
			AND s.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
		</cfif>
		
		<cfif isDefined("variables.ID")>
			AND s.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.clientID#">
		</cfif>
	
		<cfif isDefined("variables.migrationId")>
			AND m.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.migrationId#">
		</cfif>
		
		<cfif isDefined("arguments.migrationId")>
			AND m.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.migrationId#">
		</cfif>
		
		<cfif isDefined("arguments.direction")>
			AND upper(s.direction) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.direction)#">
		</cfif>
		
		<cfif isDefined("arguments.object")>
			AND upper(s.object) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.object)#">
		</cfif>
		
		
	ORDER BY s.id <cfif arguments.direction eq "D">DESC</cfif>
	
	</cfquery>	
	
	<cfreturn q_schema_changes/>
	
	
	
</cffunction>




<!--- ADD METHOD FOR CFC --->
<!--- --------------------------------- --->
	
	

<cffunction name="add" access="public" output="false" returntype="numeric">
<cfargument name="migrationId" type ="numeric" required="false">
<cfargument name="direction" type ="string" required="false" default="U">
<cfargument name="object" type ="string" required="false">
<cfargument name="migrationKey" type ="string" required="false">
<cfargument name="isDeleted" type ="numeric" required="false">
<cfargument name="sqlStatement" type ="string" required="false">
<cfargument name="sortOrder" type ="numeric" required="false">
<cfargument name="addedBy" type="numeric" required="true">	
	<cfset var qGetID = false>
	<cfset var qCheck = false>
	
	<!---<cfquery datasource="#application.dsn#" Name="qGetId">
	select #application.dbo#.SCHEMA_CHANGES_seq.nextVal as newId from dual 
	</cfquery>			
			
	<cfquery datasource="#application.dsn#">
	INSERT INTO #application.dbo#.SCHEMA_CHANGES 
	(ID, MIGRATION_ID, OBJECT, DIRECTION, MIGRATION_KEY, IS_DELETED, SQL_STATEMENT, SORT_ORDER, added_by, updated_by,added_date,updated_date)
	
	VALUES (#qGetID.newID#,
	<cfif isDefined("arguments.migrationId")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.migrationId#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.object")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.object)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.direction")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.direction)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.migrationKey")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.migrationKey)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.isDeleted")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isDeleted#"> <cfelse>0</cfif>,
	<cfif isDefined("arguments.sqlStatement")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.sqlStatement)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.sortOrder")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.sortOrder#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.addedBy")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.addedBy#"> <cfelse>0</cfif>,
	
	<cfif isDefined("arguments.addedBy")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.addedBy#"> <cfelse>0</cfif>,
	
	
	sysdate,
	sysdate
	)
	</cfquery>
	<cfreturn #qGetId.newId#><br />--->
	<cfreturn 1>
</cffunction>





<!--- UPDATE METHOD FOR CFC --->
<!--- --------------------------------- --->




<cffunction name="update" access="public" output="false" returntype="void">
<cfargument name="id" type="numeric" required="true">
<cfargument name="migrationId" type ="numeric" required="false">
<cfargument name="object" type ="string" required="false">
<cfargument name="direction" type ="string" required="false">
<cfargument name="migrationKey" type ="string" required="false">
<cfargument name="isDeleted" type ="numeric" required="false">
<cfargument name="sqlStatement" type ="string" required="false">
<cfargument name="sortOrder" type ="numeric" required="false">
<cfargument name="updatedBy" type="numeric" required="true">					
	<cfquery datasource="#application.dsn#">
	UPDATE #application.dbo#.SCHEMA_CHANGES 
	SET
	<cfif isDefined("arguments.migrationId")>
	MIGRATION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.migrationId#">,</cfif>
	<cfif isDefined("arguments.object")>
	OBJECT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.object)#">,</cfif>
	<cfif isDefined("arguments.direction")>
	DIRECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.direction)#">,</cfif>
	<cfif isDefined("arguments.migrationKey")>
	MIGRATION_KEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.migrationKey)#">,</cfif>
	<cfif isDefined("arguments.isDeleted")>
	IS_DELETED = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isDeleted#">,</cfif>
	<cfif isDefined("arguments.sqlStatement")>
	SQL_STATEMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.sqlStatement)#">,</cfif>
	<cfif isDefined("arguments.sortOrder")>
	SORT_ORDER = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.sortOrder#">,</cfif>
	<cfif isDefined("arguments.updatedBy")>
	updated_by = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.updatedBy#"> , </cfif>
	updated_date = sysdate
	WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#"> </cfquery>
	</cffunction>	



<!--- DELETE METHOD FOR CFC --->
<!--- --------------------------------- --->



<cffunction name="deleteObject" access="public" output="false" returntype="void">
	<cfargument name="object" type="string" required="true">
	
	<cfquery datasource="#application.dsn#">
	UPDATE #application.dbo#.SCHEMA_CHANGES
	SET is_deleted = 1
	WHERE object = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object#">
	</cfquery>
	
</cffunction>



<cffunction name="delete" access="public" output="false" returntype="void">
	<cfargument name="id" type="numeric" required="true">
	
	<cfquery datasource="#application.dsn#">
	UPDATE #application.dbo#.SCHEMA_CHANGES
	SET is_deleted = 1
	WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
	</cfquery>
	
</cffunction>






<!--- validation METHOD FOR CFC --->
<!--- --------------------------------- --->


<!---
<cffunction name="isValidated" access="public" output="false" returntype="struct">
	
	<cfargument name="action" type="string" required="true">
	<cfargument name="id" type="any" required="false" default="">
	<cfargument name="migrationId" type ="any" required="false" default="">
	<cfargument name="direction" type ="any" required="false" default="">
	<cfargument name="migrationKey" type ="any" required="false" default="">
	<cfargument name="isDeleted" type ="any" required="false" default="">
	<cfargument name="sqlStatement" type ="any" required="false" default="">
	<cfargument name="sortOrder" type ="any" required="false" default="">
	<cfargument name="updatedBy" type="any" required="false" default="">	
	<cfargument name="addedBy" type="any" required="false" default="">	
	
	
		

	<cfset var errorMessages = arrayNew(1)> <cfif argument.action eq "Add">
	
	<cfif not isDefined("arguments.addedby")  OR  len(arguments.addedby) gt 10 OR len(arguments.addedby) eq 0 OR not isNumeric(arguments.addedby) >
		<cfset exec = arrayAppend(errorMessages,   "id is required and must be 10 characters or less")>  
	</cfif>
	
	<cfelse>
	
	<cfif not isDefined("arguments.id")  OR  len(arguments.id) gt 10 OR len(arguments.id) eq 0 OR not isNumeric(arguments.id) >
		<cfset exec = arrayAppend(errorMessages,   "id is required and must be 10 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.updatedby")  OR  len(arguments.updatedby) gt 10 OR len(arguments.updatedby) eq 0 OR not isNumeric(arguments.updatedby) >
		<cfset exec = arrayAppend(errorMessages,   "id is required and must be 10 characters or less")>  
	</cfif>
</cfif>



	<cfif not isDefined("arguments.migrationId")  OR  len(arguments.migrationId) gt 6 OR len(arguments.migrationId) eq 0 OR not isNumeric(arguments.migrationId) >
		<cfset exec = arrayAppend(errorMessages,   "Migration Id is required and must be 6 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.sqlStatement")  OR  len(arguments.sqlStatement) gt 2000 OR len(arguments.sqlStatement) eq 0 >
		<cfset exec = arrayAppend(errorMessages,   "Sql Statement is required and must be 2000 characters or less")>  
	</cfif>

	<cfif arrayLen(errorMessages)>
		<cfset response.isValid=false>
		<cfset response.messages = errorMessages>
	<cfelse>
		<cfset response.isValid=true>
	</cfif>
	
	<cfreturn response>
</cffunction>
--->




    <!---    Date: 1/27/2010 Usage: ceneerate fk sql. return a sruture with up and down --->
<cffunction name="generateFKSql" output="false" access="public" returntype="struct" hint="ceneerate fk sql. return a sruture with up and down">
	<cfargument name="table"  type="string" required="true"/>
	<cfargument name="fkTable"  type="string" required="true"/>
	<cfargument name="column"  type="string" required="true"/>
	<cfargument name="dbo"  type="string" required="true"/>
   	
	<cfset var sql = structNew()>
	<cfset var shortTableName = "me">
	<cfset var shortFKTableName = "">
		
			<!--- if table is longer than five chars, truncate for fk name --->
<!---			<cfif len(arguments.table) gt 5>
				<cfset shortTableName = left(arguments.table, 5)>
			<cfelse>
				<cfset shortTableName = arguments.table>	
			</cfif>	
--->			
			<!--- if column name is longer than 5 chars, trunkate for fk name --->
	
			<cfif len(arguments.fkTable) gt 15>
				<cfset shortFKTableName = left(arguments.fkTable, 15)>
			<cfelse>
				<cfset shortFKTableName = arguments.fkTable>	
			</cfif>	
		
		<!--- store FK sql in varaible to runa nd capture --->
		<cfsavecontent variable="sql.up">
		<cfoutput>
		ALTER TABLE #arguments.dbo#.#arguments.table#
		add CONSTRAINT fk_#shortTableName#_to_#shortFKTableName#
		FOREIGN KEY (#arguments.column#)
		REFERENCES #arguments.fkTable# (id)
		</cfoutput>
		</cfsavecontent>
			
		<cfset sql.down = "ALTER TABLE #arguments.dbo#.#arguments.table#  DROP CONSTRAINT fk_#shortTableName#_to_#shortFKTableName#">
		
		<cfreturn sql>
		
    </cffunction>
	
	

    <!---    Date: 1/27/2010 Usage: ceneerate fk sql. return a sruture with up and down --->
<cffunction name="generateIndexSql" output="false" access="public" returntype="string" hint="ceneerate fk sql. return a sruture with up and down">
	<cfargument name="table"  type="string" required="true"/>
	<cfargument name="columns"  type="string" required="true"/>
	<cfargument name="dbo"  type="string" required="true"/>
   	
	<cfset var sql = structNew()>
		
		
		<!--- store FK sql in varaible to runa nd capture --->
		<cfsavecontent variable="sql">
		<cfoutput>
			CREATE INDEX #arguments.dbo#.idx_#arguments.table#_#randRange(100,2000)# ON #arguments.dbo#.#arguments.table#(#arguments.columns#)
		</cfoutput>
		</cfsavecontent>
			
		
		<cfreturn sql>
		
    </cffunction>
	
		
	


<cffunction name="write" access="public" output="false" returnType="string">
	<cfargument name="direction" type="string" required="true" hint="">

	<cfif arguments.direction eq 'conflict'>
		<cfset SchemaChanges = get(direction="C")>
		<cfset dir = "conflicts">
	<cfelseif arguments.direction eq 'down'>
		<cfset SchemaChanges = get(direction="D")>
		<cfset dir = "rollback">
	<cfelse>	
		<cfset schemaChanges = get(direction="U")>
		<cfset dir = "preSql">
	</cfif>
	



<cfsavecontent variable="migrationSQL">
/************* Deploy Sql Changes **********************/
<cfoutput query="schemaChanges">
#sqlStatement#;
</cfoutput>
</cfsaveContent>

<cffile action="write" output="#migrationSQL#" file="#getDirectoryFromPath(getBaseTemplatePath())#/_db/#DIR#/schema.sql.cfm">

<cfreturn migrationSQL>

</cffunction>


<cffunction name="saveSortOrder" returntype="void" access="public" output="true">
    <cfargument name="data" type="string" required="true">
    
	<cfoutput>
        <cfloop from="1" to="#listLen(arguments.data)#" index="i">
        <cfquery  datasource="#application.dsn#">
        update SCHEMA_CHANGES set sort_order = #i#  where id = #listGetAt(arguments.data, i, ",")#
        </cfquery>      
        </cfloop>
    </cfoutput>

</cffunction>








</cfcomponent>


	

	
	
