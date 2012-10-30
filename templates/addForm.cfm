<cfsavecontent variable="addForm">
<cfoutput>
#chr(60)#!--- generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified --->
#chr(60)#cfimport prefix="form"  taglib="/#appMapping#/includes/tags/form"  >

<cfdump var="#columns#" format="text">

<cfloop query="qColumns">
	#builderService.writeParam(consoleRequest.modelname, qColumns.name, qColumns.defaultValue,"I")#
</cfloop>

#chr(60)#form name="form" action="#chr(60)#cfoutput>##cgi.script_name##/#consoleRequest.modelName#/Save#chr(60)#/cfoutput>" id="form" method="post" class="formContainer">

<div class="formContainer">

<cfloop query="qColumns">

 <cfset colParams = scaffoldService.getFieldElements({name=qColumns.name, type=qColumns.type, precision=qColumns.precision, length=qColumns.length})>



<cfif right(qColumns.name, 3) eq "_id">
	<!--- todo: singularize --->
	<cfset model = scaffoldService.camelCase(replaceNoCase(qColumns.name, "_id", ""))>
	<cfset collection = scaffoldService.pluralize(model)>
	<cfset collectionTable = scaffoldService.tableFormat(scaffoldService.pluralize(model))>
		
		#builderService.build(
				element="select",
				type=colParams.type,
				label=colParams.label,
				name=findAlias(qColumns.name, consoleRequest.params),
				max=colParams.max,
				size=colParams.size,
				default=qColumns.defaultValue,
				hidden=false,
				source="model",
				model="##rc."&collection&"##",
				valueField="id",
				displayField=dbService.getPrimaryColumn(collectionTable),
				required=isRequired(qColumns.name, consoleRequest.params),
				meta=dbService.getPrimaryColumn(scaffoldService.tableFormat(model))	)#

	<cfelse>
		
		#builderService.build(
				element=colParams.element,
				type=colParams.type,
				label=colParams.label,
				name=findAlias(qColumns.name, consoleRequest.params),		
				max=colParams.max,
				size=colParams.size,
				default=qColumns.defaultValue,
				hidden=false,
				required=isRequired(qColumns.name, consoleRequest.params))#



</cfif>
#chr(13)#
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

</form>
</cfoutput>

</div>
</cfsavecontent>


