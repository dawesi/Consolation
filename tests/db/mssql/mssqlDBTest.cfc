component  extends="mxunit.framework.TestCase" {

	function setup(){
		super.setup();
		obj = createObject("component", "consolation.model.services.mssql.db").init('peeps');
		
		/*
		
		Testing the foo table with the following properies:
			create table foo(
				id numeric identity(1000,1),
				my_string varchar(50),
				my_text varchar(500),
				my_date datetime default getDate(),
				my_int numeric,
				my_boolean bit default 0
				)
		
		*/
		}
		
	function testGetDSN(){
		assertEquals("peeps", obj.getDSN());
	}
	
	function getPrimaryColumnTest(){
		var result = obj.getPrimaryColumn("foos");
		debug(result);
		
		assertEquals("my_string", result);
	}


	function linkToTableTest(){
		
		var tables = obj.linkToTable("bar_id");
		debug(tables);
		assertTrue(tables.result);
		assertEquals("bars", tables.tableList);
	}

	function getFKColumnsTest(){
		var result = obj.getFKTables("foos");
		debug(result);
		assertIsArray(result);
		assertTrue(result.size(), "should find a fk table");
		
		var noresult = obj.getFKTables("bars");
		assertIsArray(noresult);
		assertFalse(noresult.size(), "should NOT find a fk table");
		
	}

	
	function getColumnsWithBoiler(){
	var resultw = obj.getColumns('foos', true);
		debug(resultw);
		assertIsQuery(resultw);
		//assertTrue(listFindNoCase(resultw.columnlist, 'id'), 'should have id in #resultw.columnlist#');
		}	
		

	function getColumnsWOBoiler(){
		var result = obj.getColumns('foos', false);
		debug(result);
		assertIsQuery(result);
		//assertFalse(structKeyExists(result, "id"), "should not have id");
		}	
	
		
	function getColumnsTest(){
		var result = obj.getColumns('foos');
		debug(result);
		assertIsQuery(result);
		assertTrue(result.recordcount, 'should be at least one column');
		assertTrue(isDefined("result.name"));
		assertTrue(isDefined("result.length"));
		assertTrue(isDefined("result.defaultValue"));
		assertTrue(isDefined("result.type"));
		assertTrue(isDefined("result.nullable"));
	}	
	
	function getTablesTest(){
		var result = obj.getTables();
		debug(result);

		assertIsQuery(result);
		assertTrue(result.recordcount, 'should be at least one table');
		assertTrue(isDefined("result.name"));
		
		var filterResult = obj.getTables('foos');
		debug(filterresult);
		debug(filterResult);
		assertTrue(filterResult.recordcount, 'should be at least one table');
		
		}
		

	function getTablesWithFilterTest(){
		
			
		var result = obj.getTables(filter='f');
		debug(result);
		
		assertIsQuery(result);
		assertTrue(isDefined("result.name"));
		assertTrue(result.recordcount, 'should be at least one table');
		
		var noresult = obj.getTables(filter='x');
		assertIsQuery(noresult);
		assertFalse(noresult.recordcount, 'should be no tables');
		}
		
		
				
}