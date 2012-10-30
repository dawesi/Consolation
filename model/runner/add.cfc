<cfcomponent>
	<cfproperty name="scaffoldService" inject="id:scaffoldService" >
	<cfproperty name="schemaChangeService" inject="id:schemaChangeService" >
	<cfproperty name="consoleConfig" inject="coldbox:setting:consolation" >


<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">
	

	<cfset var result = {}>
	
	<cfset result.messages = []>	
	<cfset result.response = {}>

	<cfset totalProps = arraylen(consoleRequest.params)>
	<cfset arrayCount = 1>

	<cfsavecontent variable="tableSQL">	
	<cfoutput>
		alter table #consoleConfig.dbo#.#consoleRequest.table#
		add
		(
		<cfloop array="#consoleRequest.params#" index="p">

		<cfif listLen(p, " ") gt 1>
			<cfset paramDetail =  scaffoldService.translateType( listGetAt(p, 2, " ") )>				
		<cfelse>
			<cfset paramDetail =  scaffoldService.translateType( "string" )>	
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

					
		<cfif arrayCount lt totalProps>,</cfif>
		 
	<cfset arrayCount++>	
	</cfloop>
	)
	
</cfoutput>
</cfsavecontent>

	<cftry>
		<cfquery  datasource="#consoleConfig.dsn#">
		#preserveSingleQuotes(tableSQL)#
		</cfquery>
		
		<cfset arrayAppend(result.messages, "Model has been updated")>		
		
		<cfcatch>
			<cfset arrayAppend(result.messages, "Model failed to be updated: #cfcatch.Detail# #cfcatch.SQL#")>		
		</cfcatch>
		
	</cftry>
	
	<cfreturn result.messages>
</cffunction>

</cfcomponent>