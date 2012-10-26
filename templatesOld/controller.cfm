<cfsavecontent  variable="controllerCode">	
<cfoutput>component extends="baseHandler"   {	
	property name="coreService" inject="id:#consoleRequest.modelName#Model";



<cfloop query="qColumns">
	<cfif right(qColumns.name, 3) eq "_id">
		<cfset model = scaffoldService.camelCase(replaceNoCase(qColumns.name, "_id", ""))>
		property name="#model#Service" inject="id:#model#Model";
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
	rc.#consoleRequest.modelName# = coreService.get(id=rc.id);
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
