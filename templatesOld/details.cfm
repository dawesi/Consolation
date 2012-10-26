<cfsavecontent  variable="detailView">	
<cfoutput>	
<div class="detail-container">
	<div class="title"><h2>Details</h2></div>

<div class="body">
<cfloop query="qColumns">
<p>#scaffoldService.humanize(findAlias(qColumns.name, consoleRequest.params))#:		

<cfswitch expression="#qColumns.type#">
	<cfcase value="varchar2">
		<cfif qColumns.length gt 50><br /></cfif>	
			#chr(60)#cfoutput>##rc.#consoleRequest.modelName#.#findAlias(qColumns.name, consoleRequest.params)### #chr(60)#/cfoutput>
	</cfcase>
	
	<cfcase value="date">		
		#chr(60)#cfoutput> ##dateFormat( rc.#consoleRequest.modelName#.#findAlias(qColumns.name, consoleRequest.params)# , "medium")## #chr(60)#/cfoutput>
	</cfcase>

	<cfcase value="number">
		<cfif precision eq 1>
			#chr(60)#cfif rc.#consoleRequest.modelName#.#findAlias(qColumns.name, consoleRequest.params)#>Yes#chr(60)#cfelse>No#chr(60)#/cfif>
		<cfelse>
			#chr(60)#cfoutput>##rc.#consoleRequest.modelName#.#findAlias(qColumns.name, consoleRequest.params)####chr(60)#/cfoutput>
		</cfif>
	</cfcase>

		<cfdefaultCase>
		#chr(60)#cfoutput>##rc.#consoleRequest.modelName#.#findAlias(qColumns.name, consoleRequest.params)####chr(60)#/cfoutput>
		</cfdefaultCase>

	</cfswitch>
	</p>
	
</cfloop>


</div>

<div class="detail-nav">

#chr(60)#cfoutput>
<a href="##cgi.script_name##/#consoleRequest.modelName#">View All</a>
|
<a href="##cgi.script_name##/#consoleRequest.modelName#/Edit/ID/##rc.#consoleRequest.modelName#.id##">Edit</a>
#chr(60)#/cfoutput>

</div>
</cfoutput>

</cfsavecontent>

