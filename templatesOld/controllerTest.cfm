<cfcomponent extends="coldbox.system.testing.BaseTestCase" appMapping="/coldbox/ApplicationTemplates/Advanced">

	<cffunction name="setUp" returntype="void" output="false">
		<cfscript>
		// Call the super setup method to setup the app.
		super.setup();
		
		// Any preparation work will go here for this test.
		</cfscript>
	</cffunction>
	
	<cffunction name="testindex" returntype="void" output="false">
		<cfscript>
		var event = "";
		
		//Place any variables on the form or URL scope to test the handler.
		//URL.name = "luis"
		event = execute("#consoleRequest.name#.index");
		
		debug(event.getCollection());
		
		//Do your asserts below
		 assertIsArray(rc.#scaffoldService.pluralize(consoleRequest.name)#, 'oops! no array found for the index');
			
		</cfscript>
	</cffunction>
	

	
</cfcomponent>