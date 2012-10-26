<cfsavecontent variable="listCode">
<cfoutput>

<div class="table-menu">
	<a href="#chr(60)#cfoutput>##cgi.script_name###chr(60)#/cfoutput>/#consoleRequest.name#/Sort">Sort</a>
	<a href="#chr(60)#cfoutput>##cgi.script_name###chr(60)#/cfoutput>/#consoleRequest.name#/Add">Add</a>
<!---	<a href="#chr(60)#cfoutput>##cgi.script_name###chr(60)#/cfoutput>?#consoleRequest.name#.Import">Import</a>--->
</div>

<table class="display sortable" width="100%" cellpadding="5" cellspacing="0">

<thead>
	<tr>
	<cfset totalRows = 1>
	<cfloop query="qColumns">
		<th>#scaffoldService.humanize(findAlias(qColumns.name, consoleRequest.params))#</th>
		<cfset totalRows++>	
	</cfloop>
	<td></td>
	</tr>
</thead>

<tbody>

#chr(60)#cfif rc.#consoleRequest.collectionName#.recordcount>

#chr(60)#cfoutput query="rc.#consoleRequest.collectionName#">
	<tr>
	
	<cfloop query="qColumns">
		<td>###findAlias(qColumns.name, consoleRequest.params)###</td>
	</cfloop>

	<td nowrap="true">
		<a href="##cgi.script_name##/#consoleRequest.modelName#/Set/ID/##id##">Set</a> | 
		<a href="##cgi.script_name##/#consoleRequest.modelName#/Detail/ID/##id##">View</a> | 
		<a href="##cgi.script_name##/#consoleRequest.modelName#/Edit/ID/##id##">Edit</a> | 
		<a ##ConfirmClick("Are you sure you want to delete this?")## href="##cgi.script_name##/#consoleRequest.modelName#/Delete/ID/##id##">Delete</a>
	</td>

	</tr>
	
#chr(60)#/cfoutput>
	
#chr(60)#cfelse>

	<tr>
	<td colspan="#totalRows#"><em>There are no #scaffoldService.pluralize(consoleRequest.name)#...</em></td>

	</tr>
	
#chr(60)#/cfif>

</tbody>


</table>

</cfoutput>
</cfsavecontent>
