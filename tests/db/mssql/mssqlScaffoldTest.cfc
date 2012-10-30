component  extends="mxunit.framework.TestCase" {

	function setup(){
		super.setup();
		obj = createObject("component", "consolation.model.services.mssql.scaffolder").init();
		}
			
	function witeIDTest(){
		var sql = obj.writeID();
		assertEquals("id numeric identity(1000,1),", sql);
		}		

	
	function getTextFieldElements(){
		
		var textresult = obj.getFieldElements({name="firstName", type="varchar", length="50", precision=""});
		debug(textresult);
		
		assertTrue(structkeyexists(textresult, "name"), "name should exist");
		assertTrue(structkeyexists(textresult, "type"), "type should exist");
		assertTrue(structkeyexists(textresult, "label"), "label should exist");
		
		assertTrue(structkeyexists(textresult, "size"), "size should exist");
		assertTrue(isNumeric(textresult.size), 'size should be a number');
		assertTrue(structkeyexists(textresult, "max"), "max should exist");
		assertTrue(isNumeric(textresult.max), 'size should be a number');	
		
		assertEquals("text", textresult.element);	
		
		assertTrue(50, textresult.max);
		assertTrue(35, textresult.size);
		
	}


	function getTextAreaElements(){
		var result = obj.getFieldElements({name="firstName", type="varchar", length="500", precision=""});
		debug(result);
		assertTrue(isNumeric(result.size), 'size should be a number');
		assertTrue(isNumeric(result.max), 'size should be a number');	
		assertEquals(35, result.size);
		assertEquals(500, result.max);
		assertEquals("textarea", result.element);
	}


	function getDateFieldElements(){
		var result = obj.getFieldElements({name="firstName", type="datetime", length="", precision=""});
		debug(result);
		assertTrue(isNumeric(result.size), 'size should be a number');
		assertTrue(isNumeric(result.max), 'size should be a number');	
		assertEquals(15, result.size);
		assertEquals(15, result.max);
		assertEquals("date", result.element);
	}


	function getBitFieldElements(){
		var result = obj.getFieldElements({name="isLive", type="bit", length="", precision=""});
		debug(result);
		assertTrue(isNumeric(result.size), 'size should be a number');
		assertTrue(isNumeric(result.max), 'size should be a number');	
		assertEquals(1, result.size);
		assertEquals(1, result.max);
		assertEquals("boolean", result.element);
	}


	function getNumberFieldElements(){
		var result = obj.getFieldElements({name="firstName", type="numeric", length="", precision="9"});
		debug(result);
		assertTrue(isNumeric(result.size), 'size should be a number');
		assertTrue(isNumeric(result.max), 'size should be a number');	
		assertEquals(5, result.size);
		assertEquals(9, result.max);
	}


	function witeBoilerTest(){
		var sql = obj.writeBoilerPlate();
		debug(sql);
		assertTrue(len(sql), "should have contenbt");
		}					
		
	function translateTypeTest(){
		assertEquals("varchar(50)", obj.translateType("string"));
		assertEquals("varchar(500)", obj.translateType("text"));
		assertEquals("datetime", obj.translateType("date"));
		assertEquals("datetime", obj.translateType("datetime"));
		assertEquals("numeric", obj.translateType("int"));
		assertEquals("numeric", obj.translateType("number"));
		assertEquals("numeric", obj.translateType("numeric"));
		assertEquals("bit", obj.translateType("boolean"));
	}	
		
	function getDefaultTest(){
		
		assertEquals("default getDate()", obj.getDefault("datetime"));
		assertEquals("default 0", obj.getDefault("bit"));
	}	
		

function getBasicStatementTest(){
	var results = {};
	var results.nameAsString = obj.getStatement("name:string");
	var results.descAsText = obj.getStatement("desc:text");
	var results.inAsDate = obj.getStatement("in:date");
	var results.isliveAsBoolean = obj.getStatement("isLive:boolean");
	var results.emaiAsString = obj.getStatement("email");
	
	assertEquals("name varchar(50)", results.nameAsString);
	assertEquals("desc varchar(500)", results.descAsText);
	assertEquals("in datetime default getDate()", results.inAsDate);
	assertEquals("is_live bit default 0", results.isLiveAsBoolean);
	assertEquals("email varchar(50)", results.emaiAsString);
	
	debug(results);
	
}


function getAdvancedStatementTest(){
	var results = {};
	
	var results.firstNameAsString = obj.getStatement("firstName:string");
	assertEquals("first_name varchar(50)", results.firstNameAsString);
	
	var results.newFirstNameAsString = obj.getStatement("FirstName:string");
	assertEquals("first_name varchar(50)", results.newFirstNameAsString);
	
	var results.lastNameAsString = obj.getStatement("lastName");
	assertEquals("last_name varchar(50)", results.lastNameAsString);
	
	var results.contentAsText = obj.getStatement("content:text");
	assertEquals("content varchar(500)", results.firstNameAsString);
	
	var results.birthAsDate = obj.getStatement("birth:date");
	assertEquals("birth datetime default getdate()", results.birthAsDate);
	
	var results.liveAsBoolean = obj.getStatement("live:boolean");
	assertEquals("live bit default 0", results.liveAsBoolean);
	
	debug(results);
	
}
				
}