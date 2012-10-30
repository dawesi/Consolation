<cfsavecontent variable="addForm">
<cfoutput>
#chr(60)#!--- generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified --->
#chr(60)#cfimport prefix="form"  taglib="/#appMapping#/includes/tags/form"  >



<cfloop array="#columns#" index="col">
	#builderService.writeParam(model=consoleRequest.modelname, name=col.name, formType="add")##chr(10)#
</cfloop>

#chr(10)#
#chr(60)#form name="form" action="#chr(60)#cfoutput>##cgi.script_name##/#consoleRequest.modelName#/Save#chr(60)#/cfoutput>" id="form" method="post" class="formContainer">

<div class="formContainer">

<cfloop array="#columns#" index="col">





<cfif col.field eq "select">
	<!--- todo: singularize --->
	<cfset model = scaffoldService.camelCase(replaceNoCase(col.name, "id", ""))>
	<cfset collection = scaffoldService.pluralize(model)>
	<cfset collectionTable = scaffoldService.tableFormat(scaffoldService.pluralize(model))>
		
		#builderService.build(
				element="select",
				type=col.type,
				label=col.label,
				name=col.name,
				max=col.max,
				size=col.size,
				hidden=false,
				source="model",
				model="##rc."&collection&"##",
				valueField="id",
				displayField=dbService.getPrimaryColumn(collectionTable),
				required=isRequired(col.name, consoleRequest.params),
				meta=dbService.getPrimaryColumn(scaffoldService.tableFormat(model))	)#

	<cfelse>
		
		#builderService.build(
				element=col.field,
				type=col.type,
				label=col.label,
				name=col.name,		
				max=col.max,
				size=col.size,
				hidden=false,
				required=isRequired(col.name, consoleRequest.params))#



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


