<cfsavecontent variable="editForm">
<cfoutput>
#chr(60)#!--- generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified --->
#chr(60)#cfimport prefix="form"  taglib="/#appMapping#/includes/tags/form"  >

<cfloop array="#columns#" index="col">
	#builderService.writeParam(model=consoleRequest.modelname, name=col.name, formType="update")#
</cfloop>

#chr(60)#form name="form" action="#chr(60)#cfoutput>##cgi.script_name##/#consoleRequest.modelName#/Save/ID/##rc.#consoleRequest.modelName#.id###chr(60)#/cfoutput>" id="form" method="post" class="formContainer">

<div class="formContainer">

<cfloop query="qColumns">

	
<cfset colParams = scaffoldService.getFieldElements({name=qColumns.name, type=qColumns.type, precision=qColumns.precision, length=qColumns.length})>


<cfif right(qColumns.name, 3) eq "_id">

	<cfset model = scaffoldService.camelCase(replaceNoCase(qColumns.name, "_id", ""))>
	<cfset collection = scaffoldService.pluralize(model)>
	<cfset collectionTable = scaffoldService.tableFormat(scaffoldService.pluralize(model))>
	<cfset displayField = dbService.getPrimaryColumn(collectionTable)>
	#builderService.build(
			element="select",
			type=colParams.type,
			label=colParams.label,
			name=findAlias(qColumns.name, consoleRequest.params),
			max=colParams.max,
			size=colParams.size,
			default=qColumns.defaultValue,
			hidden=false,
			source="#consoleRequest.modelName#",
			model="##rc."&collection&"##",
			displayField=displayField,
			required=isRequired(qColumns.name, consoleRequest.params))#
	<cfelse>
	#builderService.build(
			element=colParams.element,
			type=colParams.type,
			label=colParams.label,
			name=findAlias(qColumns.name, consoleRequest.params),		
			max=colParams.max,
			size=colParams.max,
			default=qColumns.defaultValue,
			hidden=false,
			required=isRequired(qColumns.name, consoleRequest.params))#

</cfif>
#chr(10)#
</cfloop>

	<div class="formRow">		
		<div class="formLabel"></div>
			<div class="formField"><input type="submit" name="sumbit" value="Submit" class="submit"></div> 
	</div>

	<div class="formRow">		
		<div class="formLabel"></div>
		<div class="formField">		

	#chr(60)#cfoutput>
		<a href="##cgi.script_name##/#consoleRequest.name#">Return to List</a>
	#chr(60)#/cfoutput>
		
		</div> 
	</div>


<input type="hidden" name="action" value="submit">	



</div>
</form>
</cfoutput>


</cfsavecontent>


