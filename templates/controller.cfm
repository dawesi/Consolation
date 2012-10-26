<cfset rcArrayVar = "rc.#scaffoldService.pluralize(consoleRequest.modelName)#">
<cfset rcStructVar = "rc.#consoleRequest.modelName#">
<cfsavecontent  variable="controllerCode">	
<cfoutput>
// generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified
component extends="baseHandler"   {	
	property name="coreService" inject="id:#consoleRequest.modelName#Service";
<cfloop query="qColumns">
	<cfif right(qColumns.name, 3) eq "_id">
	<cfset model = scaffoldService.camelCase(replaceNoCase(qColumns.name, "_id", ""))>
	property name="#model#Service" inject="id:#model#Service";
	</cfif>
</cfloop>

 

//	ADD CUSTOM CONTROLLER METHODS HERE. 
////////////////////////////////////////////////////////////


//	OVERWRITE INHERITED CONTROLLER METHODS HERE. 
////////////////////////////////////////////////////////////


//	STANDARD CONTROLLER METHODS THAT ARE MODEL SPECIFIC HERE. 
////////////////////////////////////////////////////////////


function index (event){
	var rc = event.getCollection();
	rc.#scaffoldService.pluralize(consoleRequest.modelName)# = coreService.list();
	
	
		
	if(rc.format == "json"){
		event.renderData("json", #rcArrayVar#);			
		}
		
	else if(rc.format == "xml"){
		event.renderData("xml", #rcArrayVar#);	
		}
	}

function sort (event){
	var rc = event.getCollection();
	rc.#scaffoldService.pluralize(consoleRequest.modelName)# = coreService.list();
	
	
	}
	





function saveOrder(event){
	var rc = event.getCollection();
	var itemArray = listToArray(rc.data);
	var result = true;
	try{
		for(i=1; i lte arraylen(itemArray); i++){
			coreService.update(id=itemArray[i], data={sortOrder=i});
			}

		}	

		catch(any e){
			result = false;
			}


		event.renderData("text", result);			
	}
	





	
		
function add (event){
	var rc = event.getCollection();
	
	<cfloop query="qColumns">
	<cfif right(qColumns.name, 3) eq "_id">
		<cfset model = scaffoldService.camelCase(replaceNoCase(qColumns.name, "_id", ""))>
		rc.#scaffoldService.pluralize(model)# = #model#Service.list();
	</cfif>
	</cfloop>
	}	
	
function detail (event){
	var rc = event.getCollection();	
	#rcStructVar# = coreService.get(id=rc.id);
	
			
	if(rc.format == "json"){
		event.renderData("json", #rcStructVar#);			
		}
		
	else if(rc.format == "xml"){
		event.renderData("xml", #rcStructVar#);	
		}
	
	
	
	appendTitle('// Details');	
	}	
	

function edit (event){
	var rc = event.getCollection();
	rc.#consoleRequest.modelName# = coreService.get(id=rc.id);
	
		<cfloop query="qColumns">
	<cfif right(qColumns.name, 3) eq "_id">
		<cfset model = scaffoldService.camelCase(replaceNoCase(qColumns.name, "_id", ""))>
		rc.#scaffoldService.pluralize(model)# = #model#Service.list();
	</cfif>
	</cfloop>
	appendTitle('// Edit New Item');

	}

/*
function set(event){
	
	var model = coreService.get(id=arguments.id);
	session.currentteamID =  rc.ID;
	if( arguments.allowRedirect){
		redirect(controller='team', message="#consoleRequest.modelName# has been set as the current team");
		}
	
	}
*/

}
</cfoutput>
</cfsavecontent>
