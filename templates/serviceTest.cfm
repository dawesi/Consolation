<cfset modelNameSingular = consoleRequest.name>
<cfset modelNamePlural = scaffoldService.pluralize(consoleRequest.name)>

<cfsavecontent variable="gatewayTestCode">
<cfoutput>// generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified

component  extends="coldbox.system.testing.BaseTestCase" appMapping="/"#appMapping#" {

	function setup(){
		super.setup();

		mb = getMockBox();
		cache = getCacheBox().getCache("default");
		
		service = createObject("component", "urapply.services.#modelNameSingular#ServiceGateway");
		mockery = createObject("component", "urapply.test.mocks.injectMockery");
		mockCore = createObject("component", "urapply.test.mocks.models._#modelNameSingular#Model");
		mb.prepareMock(service);

		// mock any child services		
		//mockService = mockery.getMockSubProgramService();
			
		service.$property("coreModel","variables",mockCore);
		//service.$property("subProgramService","variables",mockery.getMockService());

		
	}


	function testList(){
		var result = service.list();
		debug(result);
		assertIsArray(result);
		assertIsStruct(result[1]);
		assertTrue(arraylen(result));
		;
	}



}
</cfoutput>
</cfsavecontent>