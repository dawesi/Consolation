<cfcomponent>
	<cfproperty name="scaffoldService" inject="id:scaffoldService" >

<cffunction name="execute" access="public" output="false" returnType="array">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">
	
	<cfset var response = {}>
	<cfset response.result = "">
	<cfset response.messages = []>
	
	

<cfset cols = scaffoldService.getColumns(table=consoleRequest.table)>

<cfsavecontent variable="descText">

<style>
.model-prop, .model-name{
			 cursor:pointer; text-decoration:underline;
			 font-size:1.1em; color:#660000;
			 font-weight:bold}
</style>

<div class="desc-output">

<h3>Properties for <cfoutput><span class="model-name">#consoleRequest.name#</span> </cfoutput></h3>
<p><i>Table: <cfoutput>(#consoleRequest.table#)</cfoutput></i></p>


<cfoutput query="cols">
<p>
<span class="model-prop">#scaffoldService.camelCase(name)#</span> 
<em>#type#(<cfswitch expression="#type#">

	<cfdefaultcase>#length#</cfdefaultcase>
	<cfcase value="NUMBER">#precision#</cfcase>

</cfswitch>)</em>
</p>
</cfoutput>
</div>
</cfsavecontent>


<cfset arrayAppend(response.messages, descText)>

	<cfreturn response.messages>
	
</cffunction>


</cfcomponent>