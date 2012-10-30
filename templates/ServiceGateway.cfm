<cfset modelNameSingular = consoleRequest.name>
<cfset modelNamePlural = scaffoldService.pluralize(consoleRequest.name)>
<cfset fTables = dbService.getfkTables(consoleRequest.tableName)>
<cfset relationArray = []>
	<cfloop from="1" to="#arrayLen(fTables)#" index="i">
		<cfset arrayAppend(relationArray, scaffoldService.objectify(fTables[i][1]))>
	</cfloop>
<cfsavecontent variable="gatewayCode">
<cfoutput>// generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified
component  {

	property name="coreModel" inject="id:#modelNameSingular#Model";
<cfloop array="#relationArray#" index="r" >
	property name="#r#Service" inject="id:#r#Service";
</cfloop>

function init(){
	return this;
	}
	
	
function transform(recordset, recursive=true){
	var #modelNamePlural# = [];
	var #modelNameSingular# = {};
	
	
		
	for (i=1; i lte recordset.recordcount; i++){
		
		#modelNameSingular# = {
				id= recordset["id"][i],
</cfoutput>	
		
		<cfoutput query="qColumns">
			<cfset paramName = #findAlias(qColumns.Name, consoleRequest.params)#>
			
				#paramName# = recordset["#paramName#"][i],
		</cfoutput>	

<cfoutput>		
				 updatedBy= recordset["updatedBy"][i],
				 addedBy= recordset["addedBy"][i],
				 addedDate= recordset["addedDate"][i],
				 updateDate= recordset["updateDate"][i],
				 isDeleted= recordset["isDeleted"][i],
				 sortOrder= recordset["sortOrder"][i]
		 		};
	 		
	 	if(recursive){
	 	<cfloop array="#relationArray#" index="s" >
			var #modelNameSingular#.#s# = #s#Service.get(id=#modelNameSingular#Q["id"][i]);
		</cfloop>	
	 	}	
	
		arrayAppend(#modelNamePlural#, #modelNameSingular#);
		
		}
		

	return #modelNamePlural#;
	
	
}


function list(id="", recursive=true){
	var #modelNamePlural# = [];

	
		if(len(trim(id)) ){
			var #modelNameSingular#Q = coreModel.list(id);
			#modelNamePlural# = transform(#modelNameSingular#Q, recursive);
			}
		
		else{
			var #modelNameSingular#Q = coreModel.list();
			#modelNamePlural# = transform(#modelNameSingular#Q, recursive);
			}
		
	
	return #modelNamePlural#;
	
	
	
	}	 


function get(id, recursive){
	var result = list(id, recursive);
	return result[1];
	}



function validate(data){
	return coreModel.validate(data);
	}

function add(data){
	return coreModel.add(data);
	}

function update(id,data){
	return coreModel.update(id,data);
	}

}


</cfoutput>
</cfsavecontent>





