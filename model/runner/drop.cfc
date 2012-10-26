<cfcomponent>

<cfproperty name="scaffoldService" inject="id:scaffoldService" >
<cfproperty name="schemaChangeService" inject="id:schemaChangeService" >

<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">
	<cfargument name="consoleConfig" type="struct" required="true" hint="">
	<cfset var result = {}>
	
	<cfset result.messages = []>	
	<cfset result.response = {}>





	
	<cfreturn result.messages>
</cffunction>

</cfcomponent>