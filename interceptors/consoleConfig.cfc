<cfcomponent hint="used to decrty and encryt rc varaibles" output="false"  extends="coldbox.system.interceptor">
	
<!------------------------------------------- CONFIGURATOR ------------------------------------------->

	<cffunction name="configure" access="public" returntype="void" output="false" hint="Interceptor config">
		<cfscript>
			
		</cfscript>
	</cffunction>

<!------------------------------------------- INTERCEPTION POINTS ------------------------------------------->




	
	<cffunction name="preProcess" access="public" returntype="void" output="true" hint="Interceptor config">
		<cfset var rc = event.getCollection()>

		<cfset settings = getModuleSettings("consolation").settings>
		
		<cfset rc.consoleConfig = {
			dbo = settings.dbo,
			dsn = settings.dsn,
			dbtype= settings.dbtype,
			appRoot=settings.appRoot
			}>
		<cfset createMigrations()>
		<cfset createSchemaChanges()>
	</cffunction>


	<cffunction name="postEvent" access="public" returntype="void" output="false" hint="Interceptor config">
 	

	</cffunction>



<cffunction name="createMigrations" access="private" output="false" returnType="void">
	
</cffunction>


<cffunction name="createSchemaChanges" access="private" output="false" returnType="void">
	
</cffunction>


	
</cfcomponent>	
