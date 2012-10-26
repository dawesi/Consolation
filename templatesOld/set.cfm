<cfset objectName = scaffoldService.getPrimaryColumn(form.table_name)>

<cfsavecontent  variable="setView">	
<cfoutput>#chr(60)#</cfoutput>cfparam name="url.redirectTo" default="index.cfm?<cfoutput>#form.component_name#</cfoutput>">


<cfoutput>#chr(60)#</cfoutput>cfset <cfoutput>#form.querySource#</cfoutput> =  application.com.<cfoutput>#form.component_name#</cfoutput>.get(id=url.id)>

	<cfoutput>#chr(60)#</cfoutput>cflock scope="session" timeout="6" type="exclusive">
		   <cfoutput>#chr(60)#</cfoutput>cfset exec = session.userMessage.set("#<cfoutput>#form.querySource#.#objectName#</cfoutput># has been set as the current <cfoutput>#form.component_name#</cfoutput>")>	
	<cfoutput>#chr(60)#</cfoutput>/cflock>	
	
	


<cfoutput>#chr(60)#</cfoutput>cfset session.current<cfoutput>#form.component_name#ID</cfoutput> =  <cfoutput>#form.querySource#</cfoutput>.ID>
<cfoutput>#chr(60)#</cfoutput>cflocation url="index.cfm?#url.redirectTo#"  addToken="false">


</cfsavecontent>

