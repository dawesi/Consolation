<cfcomponent output="false" hint="runs console requests">
	 <cfproperty name="parserService" inject="id:parser" >
	 <cfproperty name="descRunner" inject="id:runner@desc" >
	 <cfproperty name="createRunner" inject="id:runner@create" >
	 <cfproperty name="scaffoldRunner" inject="id:runner@scaffold" >
	 <cfproperty name="bindRunner" inject="id:runner@bind" >
	 <cfproperty name="addRunner" inject="id:runner@add" >
	 <cfproperty name="joinRunner" inject="id:runner@join" >

	<cfproperty name="consoleConfig" inject="coldbox:setting:consolation" >
	<cfscript>
		this.prehandler_only 		= "";
		this.prehandler_except 		= "";
		this.posthandler_only 		= "";
		this.posthandler_except 	= "";
		this.aroundHandler_only 	= "";
		this.aroundHandler_except 	= "";		
		// REST HTTP Methods Allowed for actions.
		// Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'} */
		this.allowedMethods 	= {};
	</cfscript>




	<cffunction name="index" output="true" hint="index">
		<cfargument name="event">
		<cfset var rc = event.getCollection()>
		
		<!--- take the string request and return a structured request for the runners --->
		<cfset var statusMessages = []>		
		
		<cfset var rc.request = parserService.parseCommand(rc.command)>
		
		<cfswitch expression="#rc.request.command#">
			<cfcase value="create">
				<cfset statusMessages = createRunner.execute(rc.request)>
			</cfcase>	
			
			<cfcase value="desc">
				<cfset statusMessages = descRunner.execute(rc.request)>
			</cfcase>	

			<cfcase value="join">
				<cfset statusMessages = joinRunner.execute(rc.request)>
			</cfcase>	
			
			<cfcase value="add">
				<cfset statusMessages = addRunner.execute(rc.request)>
			</cfcase>	

			<cfcase value="bind">
				<cfset statusMessages = createRunner.execute(rc.request)>
				<cfset statusMessages = bindRunner.execute(rc.request)>
			</cfcase>
				
			<cfcase value="scaffold">
				<cfset statusMessages = scaffoldRunner.execute(consoleRequest=rc.request)>
			</cfcase>		
			
		</cfswitch> 

			<cfset event.renderData("Json", statusMessages)>

	</cffunction>

<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>

</cfcomponent>

