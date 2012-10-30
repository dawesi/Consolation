component  extends="mxunit.framework.TestCase" {

	function setup(){
		super.setup();
		obj = createObject("component", "consolation.model.services.sqlWriter").init();
		
		}
		
	function wrapParamsForTextTest(){
		result = obj.wrapAsParam(type="text", name="name");
		assertEquals('<cfqueryparam cfsqltype="cf_sql_varchar" value="##superhtmleditformat(arguments.data.name)##">', result);
		}		
	
	
	function wrapParamsForDateTest(){
		result = obj.wrapAsParam(type="date", name="name");
		assertEquals('<cfqueryparam cfsqltype="cf_sql_date" value="##superhtmleditformat(arguments.data.name)##">', result);
		}			
				
				
		
	function writeUpdatePairTest(){
		
		var result = {text = 	obj.writeUpdatePair("firstName", "fn", "text")};
		var result.date = 		obj.writeUpdatePair("firstDate", "fdate", "date");
		var result.number = 	obj.writeUpdatePair("firstN", "fnum", "number");
		var result.ta = 		obj.writeUpdatePair("firstPara", "fpara", "textarea");
		
		debug(result);		
		
		assertTrue(findNoCase("cf_sql_varchar", result.text), "should be varchar");
		assertTrue(findNoCase("cf_sql_varchar", result.ta), "should be varchar");
		assertTrue(findNoCase("cf_sql_date", result.date), "should be date");
		assertTrue(findNoCase("cf_sql_numeric", result.number), "should be numeric");
		
	}
}