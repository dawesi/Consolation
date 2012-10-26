<cfsavecontent variable="unitTestCode">	
<cfoutput>

component extends="coldbox.system.testing.BaseTestCase" {

/*
function testProperties(){

		//var rResult = object.getresult();

		//debug(testuser);
		assertEquals('value',testdata.key,"message");
		assertIsArray(arrayVal);
		assertFalse(boolean);
		assertTrue(boolean);
	}
*/

	
	function setup(){
		testObj = createObject("component", "model.#consoleRequest.name#").init();
		super.setup();
	}
}

</cfoutput>
</cfsavecontent>