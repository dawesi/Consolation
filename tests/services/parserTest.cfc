component  extends="mxunit.framework.TestCase" {

	function setup(){
		super.setup();
		p = createObject("component", "consolation.model.services.parser").init();
		}
		

	function prepareRequestTest(){
		
		assertEquals("desc foo", p.prepareRequest(" desc foo "));
		assertEquals("desc foo", p.prepareRequest("desc%20foo"));
		debug(p.prepareRequest("desc%20foo"));
		assertEquals("create foo (a,b)", p.prepareRequest("create foo(a,b)"));
		
		//assertEquals("create foo ", p.prepareRequest(" desc foo ")); 
	}

	
	function parseCommandTestForDesc(){
		
		var c={requestString = "desc foo", command="desc"};
		result = p.parseDescribe(c);
		debug(result);
		assertIsStruct(result);
		assertEquals("foo", result.name);
		assertEquals("foos", result.table);
		
	}

}