<cfcomponent output="false" hint="My Module Configuration">
<cfscript>
	
	// Module Properties
	this.title 				= "consolation";
	this.author 			= "Hacksaw Arp";
	this.webURL 			= "http://jearp.com";
	this.description 		= "console based application generator";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= false;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = false;
	// Module Entry Point
	this.entryPoint			= "consolation:home.index";
	
	this.foo = 'bar';

	
	function configure(){
		
		// parent settings
		parentSettings = {
		
		};
	
		// module settings - stored in modules.name.settings
		
		
		settings = {
			dsn="peeps",
			dbo="dbo",
			dbtype="mssql",
			appRoot='/peeps'
		};
		
		// Layout Settings
		layoutSettings = {
			defaultLayout = "layout.cfm"
			};
		
	
		
		// web services
		webservices = {
		
		};
		
		// SES Routes
		routes = [
			//{pattern="/api-docs", handler="api",action="index"}		
		];		
		
		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};
		
		// Custom Declared Interceptors
		interceptors = [
		];
		binder.map("parser").to("#moduleMapping#.model.services.parser");
		
		binder.map("scaffoldService").to("#moduleMapping#.model.services.#settings.dbType#.scaffolder");
		binder.map("dbService").to("#moduleMapping#.model.services.#settings.dbType#.db");
		binder.map("schemaChangeService").to("#moduleMapping#.model.services.#settings.dbType#.schemaChange");
		
		binder.map("cfcObjectService").to("#moduleMapping#.model.services.cfcobject");
		binder.map("builderService").to("#moduleMapping#.model.services.builder");
		binder.map("sqlWriterService").to("#moduleMapping#.model.services.sqlWriter");
		binder.map("validatorService").to("#moduleMapping#.model.services.validator");
		
		binder.map("runner@desc").to("#moduleMapping#.model.runner.desc");
		
		binder.map("runner@create").to("#moduleMapping#.model.runner.create");
		binder.map("runner@bind").to("#moduleMapping#.model.runner.bind");
		binder.map("runner@add").to("#moduleMapping#.model.runner.add");
		binder.map("runner@join").to("#moduleMapping#.model.runner.join");
		binder.map("runner@scaffold").to("#moduleMapping#.model.runner.scaffold");
		binder.map("runner@drop").to("#moduleMapping#.model.runner.drop");
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		
	}
	
</cfscript>
</cfcomponent>