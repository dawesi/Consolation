<cfset fTables = scaffoldService.getfkTables(consoleRequest.tableName)>
<cfsavecontent variable="ModelTestCode">	<cfoutput>// generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified
component extends="coldbox.system.testing.BaseModelTest" model="#appMapping#.model.#consolerequest.name#"   {

	/*
		This is a Model Integration Test
			-- Database is used
			-- transaction/rollbacks are used when editing, adding, and deleting
					-- Should not corrupt any data
			-- Table must have some records or tests will fail
			-- If adding dummy data, use PK IDs with a value of less than 1000, I recommend 42.
	*/

	function setup(){
		super.setup();
		}
	
	
	function testList(){
		var result = model.list();
		debug(result);
		assertIsQuery(result);
		}


	function testListID(){
		var testData = getTableData();
		var foundResult = model.list(testData.id);
		debug(foundResult);
		assertIsQuery(foundResult);
		assertTrue(foundResult.recordCount eq 1, "only one record should be returned");
		
		var emptyResult = model.list(id=0);
		assertFalse(emptyResult.recordCount, "no records should be returned");
		
	}


<cfloop from="1" to="#arrayLen(fTables)#" index="i">
		
	function testListBy#scaffoldService.findComponent(fTables[i][1])#ID(){
		var testData = getTableData();
		var foundResult = model.list(#scaffoldService.findComponent(fTables[i][1])#ID=testData.#scaffoldService.findComponent(fTables[i][1])#ID);
		debug(foundResult);
		assertIsQuery(foundResult);
		assertTrue(foundResult.recordCount, "one or more records should be returned");
		
		var emptyResult = model.list(#scaffoldService.findComponent(fTables[i][1])#ID=0);
		assertFalse(emptyResult.recordCount, "no records should be returned");
		
	}

</cfloop>



	function testAdd(){
		
		var testData = getTableData();
		var currentcount = model.list().recordcount;
		
		transaction{
			var newR = {<cfloop query="qColumns">#findAlias(qColumns.Name, consoleRequest.params)#=testdata.#findAlias(qColumns.Name, consoleRequest.params)#,</cfloop>sortOrder=50};
			var newid = model.add(newR);
			var newcount = model.list().recordcount;
			
			assertTrue(isNumeric(newid));
			
			debug('current is ' & currentCount);
			debug('new is ' & newCount);
			
			assertFalse(currentcount eq newcount, "sorry ##currentCount## and ##newCount## should not be the same!");	
			
			transaction action="rollback";
		}
	}


	function testEdit(){
		var testData = getTableData();
		
		transaction{
			oldResult = model.get(testData.id);
			// chose some fields to update and then test against them
			var newR = {id= testData.id, <cfloop query="qColumns">#findAlias(qColumns.Name, consoleRequest.params)#=testdata.#findAlias(qColumns.Name, consoleRequest.params)#,</cfloop>sortOrder=50 };
			//debug(testData);
			var newid = model.update(id=testData.id, data=newR);
			newResult = model.get(testData.id);
			
			assertFalse(newResult.updateDate eq oldResult.updateDate);
			
			transaction action="rollback";
		}
	}

function testDelete(){
	var testData = getTableData();
	var firstQ = model.get(testData.id);
	
	var records = firstQ.recordCount;
	assertEquals(1, records, "oops. only one record should have been found");
	transaction{
		model.delete(testData.id);
		var secondQ = model.get(testData.id);
		assertFalse(secondQ.recordCount, "rhut-roh. No records should have come back dude...");
		debug(secondQ);
		transaction action="rollback";
	}
	
}


	private function getTableData(){
		var data = model.list();
		var testData = {id=data.id, <cfloop query="qColumns">#findAlias(qColumns.Name, consoleRequest.params)#=data.#findAlias(qColumns.Name, consoleRequest.params)#,</cfloop>sortOrder=50};
		return testData;
	}



}
</cfoutput>
</cfsavecontent>