<cfcomponent extends="scaffoldUtility">

	
	
<cffunction name="findComponent" output="false" access="public" returntype="string" hint="remove the ending s">
   <cfargument name="string"  type="string" required="true"/>
    <cfscript>   var newString = replaceNoCase(arguments.string, "_", " ");
       newString = titleCase(newString);
  	   newString = replaceNoCase(newString, " ", "");
       newString = singularize(newString);
	</cfscript>
   
   <cfreturn newString>
   
</cffunction>



	
<!--- get a query of tables in schema --->	
<!--- currently a query, should be an array --->
<cffunction name="getTables" access="public" output="false" returntype="Query">
	<cfargument name="filter" type="string" required="false" default="">
	<cfargument name="match" type="string" required="false" default="exact">
	
	<cfset var table_table = "tabs">
	
	<!--- if stupid banner then change the way all other oracle databases work just for them --->				
	<cfif variables.is_banner>
		<cfset table_table = "dba_tables">
	</cfif>

	<cfquery name="qTables" datasource="#variables.dsn#">
		SELECT lower(table_name) AS name
		FROM #table_table#
		WHERE upper(table_name) LIKE '#ucase(arguments.filter)#<cfif arguments.match eq "wildcard">%</cfif>'
		ORDER BY table_name
	</cfquery>

	<cfreturn qTables />

</cffunction>	
	
<!--- get a query of columns for a table --->	
<cffunction name="getColumns" access="public" output="true" returntype="Query">
	<cfargument name="table" type="string" required="true">
	<cfargument name="columns" type="string" required="false" hint="comma delimited list of column names to filter by">
	
	<cfset var col_table = "cols">
	<cfdump var="#variables#">
	<!--- if stupid banner then change the way all other oracle databases work just for them --->							
	<cfif variables.is_banner>
		<cfset col_table = "dba_tab_columns">
	</cfif>

	<cfquery name="qColumns" datasource="#variables.dsn#" debug="true">
		SELECT
		<!--- pass in a list of columns to return in the where in clause order --->
		<cfif isDefined("arguments.columns")> 
		  CASE lower(column_name)
		  <cfloop from="1" to="#listLen(arguments.columns)#" index="i">
		  		WHEN '#lcase(listGetAt(arguments.columns, i))#' THEN #i#
		  </cfloop>
		  END columnSortOrder,
		  
		  <cfelse>
		  column_id as columnSortOrder,
		</cfif>
		
			 lower(COLUMN_NAME) AS name,
			 lower(DATA_TYPE) AS type,
			 DATA_LENGTH AS length,
			 DATA_PRECISION AS precision,
			 DATA_SCALE AS scale,
			 NULLABLE as NULLABLE,
			 data_default as defaultData
		FROM #col_table#
		WHERE upper(table_name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.table)#">
		
		<cfif isDefined("arguments.columns")>
			AND upper(COLUMN_NAME) IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#uCase(arguments.columns)#" list="true" separator="," > )
		<cfelse>
			AND upper(COLUMN_NAME) NOT IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="ID,SORT_ORDER" list="true" separator="," > )
		</cfif>
		
		order by columnSortOrder
	</cfquery>

	<cfreturn qColumns />
</cffunction>



<!--- get the second column (the first after ID --->
<cffunction name="getPrimaryColumn" access="public" output="false" returntype="string">
	<cfargument name="table" type="string" required="true">

	<cfset primaryColumn = "name">
	<cfset var col_table = "cols">
			
		<cfif variables.is_banner>
			<cfset col_table = "dba_tab_columns">
		</cfif>

	<cfquery name="qColumns" datasource="#variables.dsn#">
		SELECT
		 COLUMN_NAME AS name
		FROM #col_table#
		WHERE upper(table_name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.table)#">
		AND column_id = 2
	</cfquery>

	<cfset primaryColumn = qColumns.name >
		
	<cfreturn primaryColumn>
</cffunction>


	
	
<!--- pass in oracle column data and bet a simple struct that can be used in the code for form generation and such --->
<cffunction name="getColumnParams" access="public" output="false" returnType="struct">
	<cfargument name="type" type="string" required="true" hint="">
	<cfargument name="length" type="any" required="true" hint="">
	<cfargument name="precision" type="any" required="true" hint="">

	<cfset var params = structNew()>
	
	<cfswitch expression="#arguments.type#">
	
	<cfcase value="date">
		<cfset params.type = 'date'>
		<cfset params.length = arguments.length>
		<cfset params.element = "date">
	</cfcase>
	
	<cfcase value="number">
		<cfif arguments.precision eq 1>
			<cfset params.type = 'boolean'>
			<cfset params.length = 1>
			<cfset params.element = "boolean">
		<cfelse>
			<cfset params.type = 'number'>
			<cfset params.length = arguments.precision>
			<cfset params.element = "number">
		</cfif>
	</cfcase>

	<cfdefaultcase>
		<cfset params.type = 'varchar2'>
		<cfset params.length = arguments.length>
		<cfif params.length gt 50>
			<cfset params.element = "textarea">
			<cfelse>
			<cfset params.element = "text">			
		</cfif>
	</cfdefaultcase>

	</cfswitch>
	
	<cfreturn params>
</cffunction>




<!--- take column and table and creates alias for sql [col]From[Table] --->
<cffunction name="createAlias" access="public" output="false" returnType="string">
	<cfargument name="column" type="string" required="true" >
	<cfargument name="table" type="string" required="true" >
	
	<cfset var alias = "#camelCase(arguments.column)#From#camelCase2(arguments.table)#">
		<cfif len(alias) gt 30>
			<cfset alias = left(alias, 30)>
		</cfif>
		
		<cfreturn alias>
</cffunction>




<!--- this will attempt to find the forign tables based on convention and database meta data --->
<cffunction name="linkToTable" returntype="struct"  output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="useStrictFind" type="boolean" required="false" default="false">

	<cfset var Result = structNew()>
	<cfset var fkTable = pluralize(replaceNoCase(arguments.name, "_id", ""))>

	<cfset Result.result = false>
	<cfset Result.tableList = "">
	
	<cfif right(arguments.name,3) eq "_id">

		<cfset Result.result = true>
		<!--- make sure by looking it up --->
		<cfset Result.tableQ = getTables(filter=fkTable, match='exact')>
		<!--- if 1 record, you got it --->
		<cfset Result.tableList =valueList(Result.tableQ.name)>

	</cfif>

	<cfreturn Result>
</cffunction>


<!---    Date: 2/1/2009 Usage: gets a table list of all tables with fk conenctions --->
<cffunction name="getFKTables" output="false" access="public" returntype="array" hint="gets a table list of all tables with fk conenctions">
   <cfargument name="table_name"  type="string" required="true"/>

	<cfset var result = false>
	<cfset var fkConn = arrayNew(2)>
	<cfset var index = 0>
	<!--- get all columns in table, loop through and look for "_id" --->
	<cfset var qcolumns = getColumns(table=arguments.table_name)>

	<cfoutput query="qColumns">
		<cfif findNoCase("_id",name)>
			<cfset result = linkToTable(name)>

			<cfif result.result>
				<cfset index++>
				<cfset fkConn[index][1] =   "#result.tableList#">
				<cfset fkConn[index][2] =   "#qcolumns.name#">
			</cfif>
		</cfif>
	</cfoutput>

	<cfreturn fkConn>

</cffunction>




<!--- todo: please explain --->
<!---    Date: 2/1/2009 Usage: gets a table list of all tables with fk conenctions --->
<cffunction name="getFKColumns" output="false" access="public" returntype="string" hint="gets a table list of all tables with fk conenctions">
   <cfargument name="table_name"  type="string" required="true"/>

	<cfset var result = false>
	<cfset var fkList = "">

	<cfset var qcolumns = getColumns(table=arguments.table_name)>

	<cfoutput query="qColumns">
		<cfif findNoCase("_id",name)>
			<cfif result.result>
				<cfset fkList =   "#fkList#,#name#">
			</cfif>
		</cfif>
	</cfoutput>

	<cfreturn fkList>

</cffunction>

<cffunction name="getSequences" access="public" output="false" returntype="Query">
	<cfargument name="filter" type="string" required="false" default="">

	<cfquery name="qTables" datasource="#variables.dsn#">
		SELECT sequence_name AS sequence
		FROM user_sequences
		WHERE upper(sequence_name) LIKE '#ucase(arguments.filter)#%'
		ORDER BY sequence_name
	</cfquery>

	<cfreturn qTables />
</cffunction>


<cffunction name="translateType" access="public" output="false" returnType="struct">
	<cfargument name="type" type="string" required="true" hint="">
	<cfargument name="db" type="string" required="false" default="oracle" hint="">
	
	<cfset var ret = structNew()>
	
	<cfswitch expression="#arguments.type#">
	
	<cfdefaultcase>
		<cfif arguments.db eq "mysql">
			<cfset ret.type = "varchar">
		<cfelse>
			<cfset ret.type = "varchar2">
		</cfif>

		<cfset ret.length = "50">
		<cfset ret.default = "">
	</cfdefaultcase>


	<cfcase value="text">
		<cfif arguments.db eq "mysql">
			<cfset ret.type = "varchar">
		<cfelse>
			<cfset ret.type = "varchar2">
		</cfif>
		<cfset ret.length = "500">
		<cfset ret.default = "">
	</cfcase>
	
	<cfcase value="number">
		<cfif arguments.db eq "mysql">
			<cfset ret.type = "numeric">
		<cfelse>
			<cfset ret.type = "number">
		</cfif>

		<cfset ret.length = "6">
		<cfset ret.default = "">
	</cfcase>	
	
	<cfcase value="int">
		<cfif arguments.db eq "mysql">
			<cfset ret.type = "numeric">
		<cfelse>
			<cfset ret.type = "number">
		</cfif>
		<cfset ret.length = "6">
		<cfset ret.default = "">
	</cfcase>
	
	<cfcase value="date">
		<cfset ret.type = "date">
		<cfset ret.length = "">

		<cfif arguments.db eq "mysql">
			<cfset ret.default = "">
		<cfelse>
			<cfset ret.default = "sysdate">
		</cfif>

	
	</cfcase>
	
	
	<cfcase value="boolean">
	
	
		<cfif arguments.db eq "mysql">
			<cfset ret.type = "bit">
		<cfelse>
			<cfset ret.type = "number">
		</cfif>
		
		
		<cfset ret.length = "1">
		<cfset ret.default = "0">
	</cfcase>
	
				
	</cfswitch>
	
	<cfreturn ret>
	
</cffunction>

<cffunction name="init" returntype="scaffolder">
	<cfargument name="dsn" required="false" type="string" default="urapply">
	<cfargument name="is_banner" required="false" type="numeric" default="0">

		<cfset variables.dsn ="#arguments.dsn#">

		<cfif isDefined("arguments.is_banner")>
			<cfset variables.is_banner ="#arguments.is_banner#">
		</cfif>

	<cfreturn this>

</cffunction>


<!--- messy and/or unecessary --->


<!--- get all the tables that this is a fk of --->
<cffunction name="getChildTables" access="public" output="false" returntype="Query">
	<cfargument name="table" type="string" required="true">

	<!--- this will attempt to find all tables that have fk pointing back to the table --->

		<cfscript>
			var col_table = "cols";
			var tablename = arguments.table;
			var tnLen = len(tableName);
			var searchName = left(tablename, evaluate(tnLen - 1));
		</cfscript>
				
		<cfif variables.is_banner>
			<cfset col_table = "dba_tab_columns">
		</cfif>


		<cfquery name="qChildren" datasource="#variables.dsn#">
				SELECT
				COLUMN_NAME AS "column",
				TABLE_NAME AS name,
				 DATA_TYPE AS type,
				 DATA_LENGTH AS length,
				 DATA_PRECISION AS precision,
				 DATA_SCALE AS scale,
				 NULLABLE as NULLABLE,
				 data_default as defaultData
			FROM cols
			WHERE upper(COLUMN_NAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(searchName)#%">
			AND  TABLE_NAME NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%=%">
			AND  upper(TABLE_NAME) <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(tablename)#">

			order by rownum

		</cfquery>

		<cfreturn qChildren />
	</cffunction>


</cfcomponent>