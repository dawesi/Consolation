<cfcomponent  displayname="migration" extends="editor" output="false">
		
		
<!--- INIT METHOD FOR CFC --->	
	
<cffunction name="init" access="public" output="false" returntype="migration">
	<cfargument name="id" type="numeric" required="false">
	
	<cfif isDefined("arguments.id")>
		<cfset variables.id = arguments.id>
	</cfif>
	
	<cfreturn this/>
</cffunction>	
	
<!--- GET METHOD FOR CFC --->
<!--- --------------------------------- --->
	
<cffunction name="get" access="public" output="false" returntype="query">
	<cfargument name="id" type="numeric" required="false" hint="send id to return single item">
	<cfargument name="netid" type="string" required="false" hint="send id to return single item">
	

	<cfset var q_migrations = false>
	
	<cfquery name="q_migrations" datasource="#application.dsn#">
		select		
		M.IS_INACTIVE as isInactive, M.SORT_ORDER as sortOrder, M.ROUTE_DELIMITER as routeDelimiter, M.IS_BANNER as isBanner, M.TABLE_FILTER as tableFilter, 
		M.DATASOURCE as datasource, M.DBO as dbo, M.NETIDS as netids, M.DESCRIPTION as description, m.svn as svn, approot as approot, 
		M.ADDED_DATE as addedDate, M.ADDED_BY as addedBy, M.UPDATED_DATE as updatedDate, M.UPDATED_BY as updatedBy, M.IS_DELETED as isDeleted, M.TARGET_VERSION as targetVersion, M.APPLICATION_ID as applicationId, M.NAME as name, M.ID as id 			
			 
		from #application.dbo#.MIGRATIONS M 		
		WHERE (M.is_deleted = 0 or M.is_deleted is null)
		
		
		<cfif isDefined("arguments.id")>
			AND M.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
		</cfif>
		
		<cfif isDefined("variables.ID")>
			AND M.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.clientID#">
		</cfif>
	
				
		<cfif isDefined("arguments.netid")>
			AND upper(M.netids) LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(arguments.netid)#%">
		</cfif>
	
	
	ORDER BY M.sort_order
	
	</cfquery>	
	
	<cfreturn q_migrations/>
	
	
	
</cffunction>

<cffunction name="getCurrentID" access="public" output="false" returntype="numeric">

	<cfset var q_migrations = false>
	
	<cfquery name="q_migrations" datasource="#application.dsn#">
		select max(m.id) as maxid
		from #application.dbo#.MIGRATIONS M 		
		WHERE (M.is_deleted = 0 or M.is_deleted is null)
		ORDER BY M.sort_order
	
	</cfquery>	
	
	<cfreturn q_migrations.maxid/>
	
	
	
</cffunction>


<!--- ADD METHOD FOR CFC --->
<!--- --------------------------------- --->
	
	

<cffunction name="add" access="public" output="false" returntype="numeric">
<cfargument name="isInactive" type ="numeric" required="false">
<cfargument name="sortOrder" type ="numeric" required="false">
<cfargument name="routeDelimiter" type ="string" required="false">
<cfargument name="isBanner" type ="numeric" required="false">
<cfargument name="tableFilter" type ="string" required="false">
<cfargument name="datasource" type ="string" required="false">
<cfargument name="dbo" type ="string" required="false">
<cfargument name="netids" type ="string" required="false">
<cfargument name="description" type ="string" required="false">
<cfargument name="isDeleted" type ="numeric" required="false">
<cfargument name="targetVersion" type ="string" required="false">
<cfargument name="applicationId" type ="numeric" required="false">
<cfargument name="name" type ="string" required="false">
<cfargument name="svn" type ="string" required="false">
<cfargument name="approot" type ="string" required="false">

<cfargument name="addedBy" type="numeric" required="true">	
	<cfset var qGetID = false>
	<cfset var qCheck = false>
	
	<cfquery datasource="#application.dsn#" Name="qGetId">
	select #application.dbo#.MIGRATIONS_seq.nextVal as newId from dual 
	</cfquery>			
			
				<cfquery datasource="#application.dsn#">
	INSERT INTO #application.dbo#.MIGRATIONS 
	(ID, IS_INACTIVE, SORT_ORDER, ROUTE_DELIMITER, IS_BANNER, TABLE_FILTER, DATASOURCE, DBO, NETIDS, DESCRIPTION, IS_DELETED, TARGET_VERSION, APPLICATION_ID, NAME, svn, approot, added_by, updated_by,added_date,updated_date)
	
	VALUES (#qGetID.newID#,
	<cfif isDefined("arguments.isInactive")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isInactive#"> <cfelse>0</cfif>,
	<cfif isDefined("arguments.sortOrder")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.sortOrder#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.routeDelimiter")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.routeDelimiter)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.isBanner")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isBanner#"> <cfelse>0</cfif>,
	<cfif isDefined("arguments.tableFilter")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.tableFilter)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.datasource")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.datasource)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.dbo")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.dbo)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.netids")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.netids)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.description")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.description)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.isDeleted")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isDeleted#"> <cfelse>0</cfif>,
	<cfif isDefined("arguments.targetVersion")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.targetVersion)#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.applicationId")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.applicationId#"> <cfelse>NULL</cfif>,
	<cfif isDefined("arguments.name")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.name)#"> <cfelse>NULL</cfif>,
	
	<cfif isDefined("arguments.svn")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.svn)#"> <cfelse>NULL</cfif>,
	
	<cfif isDefined("arguments.approot")>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.approot)#"> <cfelse>NULL</cfif>,
	
	<cfif isDefined("arguments.addedBy")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.addedBy#"> <cfelse>0</cfif>,
	
	<cfif isDefined("arguments.addedBy")>
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.addedBy#"> <cfelse>0</cfif>,
	
	
	sysdate,
	sysdate
	)
	</cfquery>
	<cfreturn #qGetId.newId#><br />
</cffunction>





<!--- UPDATE METHOD FOR CFC --->
<!--- --------------------------------- --->




<cffunction name="update" access="public" output="false" returntype="void">
<cfargument name="id" type="numeric" required="true">
<cfargument name="isInactive" type ="numeric" required="false">
<cfargument name="sortOrder" type ="numeric" required="false">
<cfargument name="routeDelimiter" type ="string" required="false">
<cfargument name="isBanner" type ="numeric" required="false">
<cfargument name="tableFilter" type ="string" required="false">
<cfargument name="datasource" type ="string" required="false">
<cfargument name="dbo" type ="string" required="false">
<cfargument name="netids" type ="string" required="false">
<cfargument name="description" type ="string" required="false">
<cfargument name="isDeleted" type ="numeric" required="false">
<cfargument name="targetVersion" type ="string" required="false">
<cfargument name="applicationId" type ="numeric" required="false">
<cfargument name="name" type ="string" required="false">
<cfargument name="svn" type ="string" required="false">
<cfargument name="approot" type ="string" required="false">
<cfargument name="updatedBy" type="numeric" required="true">					


	<cfquery datasource="#application.dsn#">
	UPDATE #application.dbo#.MIGRATIONS 
	SET
	<cfif isDefined("arguments.isInactive")>
	IS_INACTIVE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isInactive#">,</cfif>
	<cfif isDefined("arguments.sortOrder")>
	SORT_ORDER = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.sortOrder#">,</cfif>
	<cfif isDefined("arguments.routeDelimiter")>
	ROUTE_DELIMITER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.routeDelimiter)#">,</cfif>
	<cfif isDefined("arguments.isBanner")>
	IS_BANNER = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isBanner#">,</cfif>
	<cfif isDefined("arguments.tableFilter")>
	TABLE_FILTER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.tableFilter)#">,</cfif>
	<cfif isDefined("arguments.datasource")>
	DATASOURCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.datasource)#">,</cfif>
	<cfif isDefined("arguments.dbo")>
	DBO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.dbo)#">,</cfif>
	<cfif isDefined("arguments.netids")>
	NETIDS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.netids)#">,</cfif>
	<cfif isDefined("arguments.description")>
	DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.description)#">,</cfif>
	<cfif isDefined("arguments.isDeleted")>
	IS_DELETED = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isDeleted#">,</cfif>
	<cfif isDefined("arguments.targetVersion")>
	TARGET_VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.targetVersion)#">,</cfif>
	<cfif isDefined("arguments.applicationId")>
	APPLICATION_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.applicationId#">,</cfif>
	<cfif isDefined("arguments.name")>
	NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.name)#">,</cfif>
	
	<cfif isDefined("arguments.svn")>
	svn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.svn)#">,</cfif>
	
	<cfif isDefined("arguments.approot")>
	approot = <cfqueryparam cfsqltype="cf_sql_varchar" value="#superHtmlEditFormat(arguments.approot)#">,</cfif>
	
	
	<cfif isDefined("arguments.updatedBy")>
	updated_by = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.updatedBy#"> , </cfif>
	updated_date = sysdate
	
	
	WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#"> </cfquery>
	
	</cffunction>	



<!--- DELETE METHOD FOR CFC --->
<!--- --------------------------------- --->



<cffunction name="delete" access="public" output="false" returntype="void">
	<cfargument name="id" type="numeric" required="true">
	
	<cfquery datasource="#application.dsn#">
	UPDATE #application.dbo#.MIGRATIONS
	SET is_deleted = 1
	WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
	</cfquery>
	
</cffunction>






<!--- validation METHOD FOR CFC --->
<!--- --------------------------------- --->



<cffunction name="isValidated" access="public" output="false" returntype="struct">
	
	<cfargument name="action" type="string" required="true">
	<cfargument name="id" type="any" required="false" default="">
	<cfargument name="isInactive" type ="any" required="false" default="">
<cfargument name="sortOrder" type ="any" required="false" default="">
<cfargument name="routeDelimiter" type ="any" required="false" default="">
<cfargument name="isBanner" type ="any" required="false" default="">
<cfargument name="tableFilter" type ="any" required="false" default="">
<cfargument name="datasource" type ="any" required="false" default="">
<cfargument name="dbo" type ="any" required="false" default="">
<cfargument name="netids" type ="any" required="false" default="">
<cfargument name="description" type ="any" required="false" default="">
<cfargument name="isDeleted" type ="any" required="false" default="">
<cfargument name="targetVersion" type ="any" required="false" default="">
<cfargument name="applicationId" type ="any" required="false" default="">
<cfargument name="name" type ="any" required="false" default="">
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



	<cfif not isDefined("arguments.applicationId")  OR  len(arguments.applicationId) gt 6 OR len(arguments.applicationId) eq 0 OR not isNumeric(arguments.applicationId) >
		<cfset exec = arrayAppend(errorMessages,   "Application Id is required and must be 6 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.name")  OR  len(arguments.name) gt 200 OR len(arguments.name) eq 0 >
		<cfset exec = arrayAppend(errorMessages,   "Name is required and must be 200 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.description")  OR  len(arguments.description) gt 500 >
		<cfset exec = arrayAppend(errorMessages,   "Description is required and must be 500 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.targetVersion")  OR  len(arguments.targetVersion) gt 50 OR len(arguments.targetVersion) eq 0 >
		<cfset exec = arrayAppend(errorMessages,   "Target Version is required and must be 50 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.netids")  OR  len(arguments.netids) gt 150 OR len(arguments.netids) eq 0 >
		<cfset exec = arrayAppend(errorMessages,   "Netids is required and must be 150 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.routeDelimiter")  OR  len(arguments.routeDelimiter) gt 3 OR len(arguments.routeDelimiter) eq 0 >
		<cfset exec = arrayAppend(errorMessages,   "Route Delimiter is required and must be 3 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.datasource")  OR  len(arguments.datasource) gt 50 OR len(arguments.datasource) eq 0 >
		<cfset exec = arrayAppend(errorMessages,   "Datasource is required and must be 50 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.dbo")  OR  len(arguments.dbo) gt 25 OR len(arguments.dbo) eq 0 >
		<cfset exec = arrayAppend(errorMessages,   "Dbo is required and must be 25 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.tableFilter")  OR  len(arguments.tableFilter) gt 25 >
		<cfset exec = arrayAppend(errorMessages,   "Table Filter is required and must be 25 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.isBanner")  OR  len(arguments.isBanner) gt 1 OR len(arguments.isBanner) eq 0 OR not isNumeric(arguments.isBanner) >
		<cfset exec = arrayAppend(errorMessages,   "Is Banner is required and must be 1 characters or less")>  
	</cfif>

	<cfif not isDefined("arguments.isInactive")  OR  len(arguments.isInactive) gt 1 OR len(arguments.isInactive) eq 0 OR not isNumeric(arguments.isInactive) >
		<cfset exec = arrayAppend(errorMessages,   "Is Inactive is required and must be 1 characters or less")>  
	</cfif>

	<cfif arrayLen(errorMessages)>
		<cfset response.isValid=false>
		<cfset response.messages = errorMessages>
	<cfelse>
		<cfset response.isValid=true>
	</cfif>
	
	<cfreturn response>
</cffunction>




<cffunction name="saveSortOrder" returntype="void" access="public" output="true">
    <cfargument name="data" type="string" required="true">
    
	<cfoutput>
        <cfloop from="1" to="#listLen(arguments.data)#" index="i">
        <cfquery  datasource="#application.dsn#">
        update MIGRATIONS set sort_order = #i#  where id = #listGetAt(arguments.data, i, ",")#
        </cfquery>      
        </cfloop>
    </cfoutput>

</cffunction>


<!---    Date: 1/28/2010 Usage: checks for schema_changes table --->
<cffunction name="hasTables" output="false" access="public" returntype="boolean" hint="checks for schema_changes table">
   	
	<cfset var checker = false>
	<cfset var answer = true>
		
   <cftry>
   	<cfquery datasource="#application.dsn#" name="checker">
		select ID from #application.dbo#.schema_changes		
	</cfquery>
   
   <cfcatch>
   	<cfset answer = false>
	</cfcatch>
	
	</cftry>
	
	<cfreturn answer>
	
</cffunction>

<!---    Date: 1/28/2010 Usage: create schema_changes table --->
<cffunction name="createTables" output="false" access="public" returntype="void" hint="checks for schema_changes table">
   
   <cftransaction>
   	<cfquery datasource="#application.dsn#" name="checker">
	  CREATE TABLE #application.dbo#.SCHEMA_CHANGES 
	   (	
	    ID NUMBER, 
		SQL_STATEMENT VARCHAR2(2000), 
		IS_DELETED NUMBER(1) DEFAULT 0, 
		UPDATED_BY NUMBER(6) DEFAULT 0, 
		UPDATED_DATE DATE DEFAULT sysdate, 
		ADDED_BY NUMBER(6) DEFAULT 0, 
		ADDED_DATE DATE DEFAULT sysdate, 
		MIGRATION_KEY VARCHAR2(50), 
		DIRECTION VARCHAR2(1) DEFAULT 'U', 
		MIGRATION_ID NUMBER(6) DEFAULT 0, 
		SORT_ORDER NUMBER(2) DEFAULT 50, 
		OBJECT VARCHAR2(150), 
		PRIMARY KEY (ID)
		)
	</cfquery>   

  	<cfquery datasource="#application.dsn#">
		CREATE SEQUENCE #application.dbo#.SCHEMA_CHANGES_SEQ START WITH 1000 INCREMENT BY 1
	</cfquery>

   	<cfquery datasource="#application.dsn#" name="checker">
	  CREATE TABLE #application.dbo#.MIGRATIONS 
	   (	
	   	ID NUMBER, 
		NAME VARCHAR2(200), 
		APPROOT VARCHAR(100),
		SVN VARCHAR(250),
		APPLICATION_ID NUMBER(6) DEFAULT 0, 
		TARGET_VERSION VARCHAR2(50), 
		DESCRIPTION VARCHAR2(500), 
		NETIDS VARCHAR2(150), 
		DBO VARCHAR2(25), 
		DATASOURCE VARCHAR2(50), 
		TABLE_FILTER VARCHAR2(25), 
		IS_BANNER NUMBER(1) DEFAULT 0, 
		ROUTE_DELIMITER VARCHAR2(3), 
		SORT_ORDER NUMBER(2) DEFAULT 50, 
		IS_INACTIVE NUMBER(1) DEFAULT 1, 
		IS_DELETED NUMBER(1) DEFAULT 0, 
		UPDATED_BY NUMBER(6) DEFAULT 0, 
		UPDATED_DATE DATE DEFAULT sysdate, 
		ADDED_BY NUMBER(6) DEFAULT 0, 
		ADDED_DATE DATE DEFAULT sysdate, 
		PRIMARY KEY (ID)
		)
	</cfquery>

  	<cfquery datasource="#application.dsn#">
		CREATE SEQUENCE #application.dbo#.MIGRATIONS_SEQ START WITH 1000 INCREMENT BY 1
	</cfquery>

	<cfset newID = add(
			name="Initial Launch / Version 1.0",
			targetVersion="1.0.0",
			description="initial start",
			netids=session.visit.netid,
			datasource=application.dsn,
			dbo=application.dbo,
			routeDelimiter=".",
			sort_order="1",
			addedBy=0
			)
		>

	<cfsavecontent variable="alsql">
	
	  CREATE TABLE <cfoutput>#application.dbo#</cfoutput>.AUDIT_LOGS 
	   (	
		ID NUMBER, 
		NETID VARCHAR2(15), 
		CONTROLLER VARCHAR2(50), 
		ACTION VARCHAR2(50), 
		MESSAGE VARCHAR2(150), 
		RELATED_DATA VARCHAR2(4000), 
		IS_CLEARED NUMBER(1,0) DEFAULT 0, 
		IS_DISPLAYED NUMBER(1,0) DEFAULT 0, 
		SORT_ORDER NUMBER(2,0) DEFAULT 50, 
		IS_DELETED NUMBER(1,0) DEFAULT 0, 
		UPDATED_BY NUMBER(6,0) DEFAULT 0, 
		UPDATED_DATE DATE DEFAULT sysdate, 
		ADDED_BY NUMBER(6,0) DEFAULT 0, 
		ADDED_DATE DATE DEFAULT sysdate, 		
	 PRIMARY KEY (ID)
   )
	</cfsavecontent>

 	<cfquery datasource="#application.dsn#" name="checker">
	  #alsql#
	</cfquery>

  	<cfquery datasource="#application.dsn#">
		CREATE SEQUENCE #application.dbo#.AUDIT_LOGS_SEQ START WITH 1000 INCREMENT BY 1
	</cfquery>
	
	<cfquery datasource="#application.dsn#">
	GRANT DELETE, INSERT, SELECT, UPDATE ON #application.dbo#.AUDIT_LOGS TO #replaceNoCase(application.dbo, "_admin", "")#_U_ROLE
	</cfquery>
	
	<cfquery datasource="#application.dsn#">
	GRANT SELECT ON #application.dbo#.AUDIT_LOGS TO #replaceNoCase(application.dbo, "_admin", "")#_Q_ROLE
	</cfquery>
	
	<cfquery datasource="#application.dsn#">
	GRANT SELECT ON #application.dbo#.AUDIT_LOGS TO #replaceNoCase(application.dbo, "_admin", "")#_Q_ROLE
	</cfquery>
	
	<cfset exec = application.com.schemaChange.add(migrationID=1000, object="audit_logs", sqlStatement=alSql, addedBy=session.visit.userid)>
	<cfset exec = application.com.schemaChange.add(migrationID=1000, object="audit_logs", sqlStatement="CREATE SEQUENCE #application.dbo#.AUDIT_LOGS_SEQ START WITH 1000 INCREMENT BY 1", addedBy=session.visit.userid)>

	<cfset exec = application.com.schemaChange.add(migrationID=1000, object="audit_logs", sqlStatement='GRANT SELECT ON #application.dbo#.AUDIT_LOGS TO #replaceNoCase(application.dbo, "_admin", "")#_Q_ROLE', addedBy=session.visit.userid)>
	<cfset exec = application.com.schemaChange.add(migrationID=1000, object="audit_logs", sqlStatement='GRANT SELECT ON #application.dbo#.AUDIT_LOGS TO #replaceNoCase(application.dbo, "_admin", "")#_Q_ROLE', addedBy=session.visit.userid)>
	
	<cfset exec = application.com.schemaChange.add(migrationID=1000, object="audit_logs", direction="D", sqlStatement="DROP SEQUENCE #application.dbo#.AUDIT_LOGS_SEQ", addedBy=session.visit.userid)>
	<cfset exec = application.com.schemaChange.add(migrationID=1000, object="audit_logs", direction="D", sqlStatement="DROP TABLE #application.dbo#.AUDIT_LOGS", addedBy=session.visit.userid)>


</cftransaction>
</cffunction>






</cfcomponent>


	

	
	
