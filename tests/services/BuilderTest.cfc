component  extends="mxunit.framework.TestCase" {

	function setup(){
		super.setup();
		obj = createObject("component", "consolation.model.services.builder").init();
		
		}
		
	function writeParamsTest(){
		result = obj.writeParam(model="user", name="name", formType="add");
		debug(result);
		assertEquals('<cfparam name="form.name" default="">', result);
	}		
	
	
	function writeParamforUpdate(){
		result = obj.writeParam(model="user", name="name", formType="update");
		debug(result);
		assertEquals('<cfparam name="form.name" default="##rc.user.name##">', result);
	}
	
	function writeParamWithDefault(){
		result = obj.writeParam(model="user", name="name", formType="update", default="boo!");
		debug(result);
		assertEquals('<cfparam name="form.name" default="boo!">', result);
	}
	

		
}