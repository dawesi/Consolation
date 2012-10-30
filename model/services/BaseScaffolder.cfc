<cfcomponent extends="scaffoldUtility">



<cffunction name="init" returntype="scaffolder">
	<cfargument name="dsn" required="false" type="string" default="peeps">

		<cfset variables.dsn ="#arguments.dsn#">

	<cfreturn this>

</cffunction>

<cffunction name="findComponent" output="false" access="public" returntype="string" hint="remove the ending s">
   <cfargument name="string"  type="string" required="true"/>
    <cfscript>   var newString = replaceNoCase(arguments.string, "_", " ");
       newString = titleCase(newString);
  	   newString = replaceNoCase(newString, " ", "");
       newString = singularize(newString);
	</cfscript>
   
   <cfreturn newString>
   
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




<!---    Date: 2/1/2009 Usage: gets a table list of all tables with fk conenctions --->




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


</cfcomponent>