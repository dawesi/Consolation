<cfsavecontent variable="mockModelCode">
	<cfoutput>
// generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified
component {
	
function update()	{
		return true;
	}

function add() {
		return 42;
	}

function list(){

	setup();
	var queryIs =	mockbox.querySim("id, <cfloop query="qColumns">#findAlias(qColumns.Name, consoleRequest.params)#,</cfloop> sortOrder
		1000 | 
		1001 | ");
		
		return queryIs;
	}

function get(){
	setup();
	var queryIs =	mockbox.querySim("<cfloop query="qColumns">#findAlias(qColumns.Name, consoleRequest.params)#,</cfloop> sortOrder
		1000 | ");
		
		return queryIs;
	}

function setup(){
  	mockbox =createobject("component","coldbox.system.testing.MockBox").init();  
  }

}
		
	</cfoutput>
</cfsavecontent>	
