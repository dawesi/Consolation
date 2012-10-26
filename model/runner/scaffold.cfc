<cfcomponent>

<cfproperty name="scaffoldService" inject="id:scaffoldService" >
<cfproperty name="schemaChangeService" inject="id:schemaChangeService" >
<cfproperty name="cfcObjectService" inject="id:cfcObjectService" >

<cfproperty name="validatorService" inject="id:validatorService" >
<cfproperty name="sqlWriterService" inject="id:sqlWriterService" >
<cfproperty name="builderService" inject="id:builderService" >

<cffunction name="getdsn" rreturntype="string" >
	<cfreturn "peeps">
</cffunction>

<cffunction name="getRoot" rreturntype="string" >
	<cfreturn "peeps/">
</cffunction>

<cffunction name="execute" access="public" output="false" returnType="any">
	<cfargument name="consoleRequest" type="struct" required="true" hint="">
	<cfargument name="consoleConfig" type="struct" required="true" hint="">
	<cfargument name="applicationRoot" type="string" required="true" hint="">
	<cfargument name="appMapping" type="string" required="true" hint="">
	
	<cfset var result = {}>
	<cfset result.messages = []>	
	<cfset result.response = {}>
	
	<cfset applicationroot = arguments.applicationRoot>	
	<cfset appMapping = arguments.appMapping>	
	<!--- move to cfc --->
	<cfset result.messages = arrayNew(1)>

	<cfset columnList = "">
	
	
	<!--- Generate the table column list from the parameters passed in --->
	<!--- to function --->	
	<cfloop array="#consoleRequest.params#" index="p">
		<cfset paramString = listGetAt(p, 1, " ")>
		<cfset paramItem = listFirst(paramString, ":")>
		
		<cfif findNoCase("[", paramItem)>
			<cfset paramActual = listLast(paramItem, "[")>
			<cfset paramActual = replaceNoCase(paramActual, "]", "")>
		<cfelse>

		<cfset paramActual = listFirst(paramItem, "[")>
	
		</cfif>
		
		<cfif find(".", paramActual)>
			<cfset paramActual = "#listFirst(paramActual, ".")#_id">
			<cfset paramF = "#listlast(paramActual, ".")#">
		</cfif>
			
		<cfset columnList =  listAppend(columnList, scaffoldService.deCamelCase(paramActual) , "," )>
				
		</cfloop>


	<cfset arrayAppend(result.messages, "<h3>Generating files for <b>#consoleRequest.name#</b></h3>")>
	<cfset arrayAppend(result.messages, "<p>Columns to scaffold are:  [#columnList#]</p>")>
	
	
	
	<!--- -------------------------- -------------------------- -------------------------- -------------------------- --->	
	
	
	
	<cfset qColumns = scaffoldService.getColumns(table=consoleRequest.table, columns=columnList)>
		
	<!--- if you can find the table based on the naming conventions, pas in the exact entry --->
	<cfif qColumns.recordCount eq 0>
		<cfset qColumns = scaffoldService.getColumns(table=consoleRequest.table)>
	</cfif>

	<!--- -------------------------- -------------------------- -------------------------- -------------------------- --->	


	<!--- set path for code and cfc --->
	<cfset handlerLocation = '#applicationRoot#/handlers'>
	<cfset modelLocation = '#applicationRoot#/model'>
	<cfset serviceLocation = '#applicationRoot#/services'>
	<cfset viewLocation = '#applicationRoot#/views/#consoleRequest.name#'>
	<cfset iTestLocation = '#applicationRoot#/test/integration/'>
	<cfset uTestLocation = '#applicationRoot#/test/unit/'>
	<cfset mTestLocation = '#applicationRoot#/test/models/'>
	<cfset sTestLocation = '#applicationRoot#/test/services/'>
	<cfset mockLocation = '#applicationRoot#/test/mocks/'>
	<cfset mockModelLocation = '#applicationRoot#/test/mocks/models/'>
	

	<cfif not directoryexists("#viewLocation#")>
		<cfdirectory action="create" directory="#viewLocation#" >
		<cfset arrayAppend(result.messages, 'Views directory created')>
	</cfif>

	<cfif not directoryexists("#iTestLocation#")>
		<cfdirectory action="create" directory="#iTestLocation#" >
		<cfset arrayAppend(result.messages, 'integration test directory created')>
	</cfif>
	
	<cfif not directoryexists("#sTestLocation#")>
		<cfdirectory action="create" directory="#sTestLocation#" >
		<cfset arrayAppend(result.messages, 'service test directory created')>
	</cfif>

	<cfif not directoryexists("#mTestLocation#")>
		<cfdirectory action="create" directory="#mTestLocation#" >
		<cfset arrayAppend(result.messages, 'model test directory created')>
	</cfif>

	<cfif not directoryexists("#uTestLocation#")>
		<cfdirectory action="create" directory="#uTestLocation#" >
		<cfset arrayAppend(result.messages, 'Unit test directory created')>
	</cfif>	
	
	
	<cfif not directoryexists("#mockLocation#")>
		<cfdirectory action="create" directory="#mockLocation#" >
		<cfset arrayAppend(result.messages, 'mock directory created')>
	</cfif>



	<cfif not directoryexists("#mockModelLocation#")>
		<cfdirectory action="create" directory="#mockModelLocation#" >
		<cfset arrayAppend(result.messages, 'mock model directory created')>
	</cfif>

	<cfparam name="session.fullname" default="unknown">

		
	<cfset componentName = consoleRequest.name>




<cfif consoleRequest.file eq "model" OR consoleRequest.file eq "all">
	<cfinclude template="../../templates/model.cfm">
	<cffile action="write"  file="#modelLocation#/#consoleRequest.name#.cfc" output="#cfcCode#" nameconflict="overwrite" >
	
	<cfset arrayAppend(result.messages, "Model CFC created")>

</cfif>>



<cfif consoleRequest.file eq "controller" OR consoleRequest.file eq "all">
<cfinclude template="../../templates/controller.cfm">
	<cffile action="write"  file="#handlerLocation#/#consoleRequest.name#.cfc" output="#controllerCode#" nameconflict="overwrite" >
	
	<cfset arrayAppend(result.messages, 'Controller CFC created')>
</cfif>


<cfif consoleRequest.file eq "sort" OR consoleRequest.file eq "all">
<cfinclude template="../../templates/sort.cfm">
	<cffile action="write"  file="#viewLocation#/sort.cfm" output="#sort#" nameconflict="overwrite" >
	
	<cfset arrayAppend(result.messages, 'Sort view created')>
</cfif>



<cfif consoleRequest.file eq "add" OR consoleRequest.file eq "all">
	<cfinclude template="../../templates/addForm.cfm">
	<cffile action="write"  file="#viewLocation#/add.cfm" output="#addForm#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Add view created')>
</cfif>


<cfif consoleRequest.file eq "edit" OR consoleRequest.file eq "all">
<cfinclude template="../../templates/editForm.cfm">
	<cffile action="write"  file="#viewLocation#/edit.cfm" output="#editForm#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Edit view created')>
</cfif>


<cfif consoleRequest.file eq "default" OR consoleRequest.file eq "all">
<cfinclude template="../../templates/index.cfm">
	<cffile action="write"  file="#viewLocation#/index.cfm" output="#listCode#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Default view created')>
</cfif>

<cfif consoleRequest.file eq "index" OR consoleRequest.file eq "all">
<cfinclude template="../../templates/index.cfm">
	<cffile action="write"  file="#viewLocation#/index.cfm" output="#listCode#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Default view created')>
</cfif>


<cfif consoleRequest.file eq "details" OR consoleRequest.file eq "all">
	<cfinclude template="../../templates/details.cfm">
	<cffile action="write"  file="#viewLocation#/detail.cfm" output="#detailView#" nameconflict="overwrite" >	
	<cfset arrayAppend(result.messages, 'Detail view created')>
</cfif>


<cfif consoleRequest.file eq "service" OR consoleRequest.file eq "all">
	<cfinclude template="../../templates/serviceGateway.cfm">
	<cffile action="write"  file="#serviceLocation#/#consoleRequest.name#ServiceGateway.cfc" output="#gatewayCode#" nameconflict="overwrite" >	
	<cfset arrayAppend(result.messages, 'service gateway view created')>
</cfif>
<!---
<cfif consoleRequest.file eq "sort" OR consoleRequest.file eq "all">
	<cfinclude template="../../templates/sort.cfm">
	<cffile action="write"  file="#viewLocation#/sort.cfm" output="#sortCode#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Sort view created')>
</cfif>
--->


<cfif consoleRequest.file eq "tests" OR consoleRequest.file eq "all">
	
	<cfinclude template="../../templates/modelTest.cfm">
	<cffile action="write"  file="#mTestLocation#/#consoleRequest.name#Test.cfc" output="#modelTestCode#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Unit Test Stub  created')>
	
	
	<cfinclude template="../../templates/serviceTest.cfm">
	<cffile action="write"  file="#sTestLocation#/#consoleRequest.name#ServiceTest.cfc" output="#gatewayTestCode#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Unit - service) Test Stub  created')>

	<cfinclude template="../../templates/mockModel.cfm">
	<cffile action="write"  file="#mockModelLocation#/_#consoleRequest.name#Model.cfc" output="#mockModelCode#" nameconflict="overwrite" >
	<cfset arrayAppend(result.messages, 'Mock #consoleRequest.name# Model  created')>
	
	<cfset injectItResultText =  injectIt(consoleRequest.name, applicationroot)>
	
</cfif>

	<cfset resultText =  wireIt(consoleRequest.name, applicationroot,appMapping)>
	<cfset arrayAppend(result.messages, resultText)>


<cfreturn result.messages>
</cffunction>



<cffunction name="findAlias" access="public" output="false" returnType="string">
	<cfargument name="field" type="string" required="true" hint="">
	<cfargument name="params" type="array" required="true" hint="">
		
		<cfset var alias = scaffoldService.camelCase(arguments.field)>
			
			<cfloop array="#params#" index="p">
				<cfset paramItem = listFirst(p, ":")>
				
				<cfset paramActual = listLast(paramItem, "[")>
				<cfset paramActual = replaceNoCase(paramActual, "]", "")>

				<cfif  findNoCase("[", paramItem) and len(paramActual) and paramActual eq arguments.field>
					<cfset alias = listFirst(paramItem, "[")>
					<cfbreak/>
				</cfif>
			</cfloop>	
			
			<cfreturn trim(alias)>
				
	</cffunction>


	<cffunction name="isRequired" access="public" output="false" returnType="string">
		<cfargument name="field" type="string" required="true" hint="">
		<cfargument name="params" type="array" required="true" hint="">
			<cfset var isRequired = false>
			<cfset var checkString = "">
			
			<cfloop array="#params#" index="p">
			
				<cfset checkString = listLast(p, ":")>
				<p>
				#arguments.field# = "#listFirst(p, ":")#" // #p# // "#checkString#" eq  "required"
			
				<cfif trim(listFirst(p, ":")) eq trim(arguments.field) and trim(checkString) eq "required">
					<cfset isRequired = true >
					yes
					<cfbreak/>
					
				<cfelse>
					no
				</cfif>
					</p>
			</cfloop>	
			
			<cfreturn isRequired>
				
	</cffunction>

<cffunction name="injectIt" returntype="String" >
	<cfargument name="model" type="string" required="true" hint="">
	<cfargument name="applicationRoot" type="string" required="true" hint="">
	
	<cffile action="read"  file="#applicationroot#/test/mocks/injectMockery.cfc" variable="mockerycontent" >
			

	<cfsaveContent variable="caseText" >
	<cfoutput>
		case "#model#":
			 	interceptData.oHandler.$property("coreService","variables", getMock#model#Service() );
			 	break;
			 	
			 	/* $NewHandlerCase */
	</cfoutput>
	</cfsavecontent>
	
	<cfsaveContent variable="injectText" >
	<cfoutput>
	
	function getMock#model#Service(){
		setup();
		var service = mockbox.createMock("urapply.services.#model#ServiceGateway");
		var mock#model#Model = createObject("urapply.test.mocks.models._#model#Model");
		service.$property("coreModel", "variables", mock#model#Model);
		
		return service;
		
	}
	
	
	/* $NewServiceGet */
	</cfoutput>
	</cfsavecontent>
	
	<cfset includeMockContent = false>
	
	<cfif !findNoCase('case "#model#":', mockerycontent)>
		<cfset includeMockContent = true>
		<cfset newInjectFileContent = replaceNoCase(mockerycontent, '/* $NewHandlerCase */', caseText)>
	</cfif>
	
	<cfif !findNoCase("getMock#model#Service()", mockerycontent)>
	<cfset includeMockContent = true>	
	<cfset newInjectFileContent = replaceNoCase(newInjectFileContent, '/* $NewServiceGet */', injectText)>
	</cfif>

	<cfif includeMockContent>
		<cffile action="write"  file="#applicationroot#/test/mocks/injectMockery.cfc" output="#newInjectFileContent#" nameconflict="overwrite" >
	</cfif>

</cffunction>

<cffunction name="wireIt" returntype="String" >
	<cfargument name="model" type="string" required="true" hint="">
	<cfargument name="applicationRoot" type="string" required="true" hint="">
	<cfargument name="appMapping" type="string" required="true" hint="">
	<cffile action="read"  file="#applicationroot#/config/Wirebox.cfc" variable="wireboxcontent" >


	<cfset var modelMappingTExt = 'map("#model#Model").to("#appMapping#.model.#model#").asSingleton();'>
	<cfset var serviceMappingTExt = 'map("#model#Service").to("#appMapping#.services.#model#ServiceGateWay").asSingleton();'>
	
	
	<cfset var compareCheck = FindNoCase(modelMappingTExt, wireboxContent)>
	
	<cfif !compareCheck>
		<cfsavecontent variable="mapFullText" > 
			<cfoutput>
				#modelMappingTExt##chr(13)#
				#serviceMappingTExt#
				//*newmodel*
			</cfoutput>
		</cfsavecontent>
	
		<cfset newWireboxFile = replaceNoCase(wireboxContent, '//*newmodel*', mapFullText)>
		
		<cffile action="write"  file="#applicationroot#/config/Wirebox.cfc" output="#newWireboxFile#" nameconflict="overwrite" >
		
		<cfset var resultText = "#model# mapped. Wirebox updated">
	
	<cfelse>
		<cfset var resultText = "nuttin' mapped... [ find #modelMappingText#  - #compareCheck#]">
	
	</cfif>		
	
	<cfreturn resultText>
</cffunction>

	

</cfcomponent>