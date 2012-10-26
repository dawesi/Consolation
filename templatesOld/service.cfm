
<cfsavecontent variable="serviceCode">

<cfoutput>

#chr(60)#cfcomponent extends="app.models.#consoleRequest.name#">

#chr(60)#cffunction name="init" access="public" output="false" returnType="any">
	#chr(60)#cfset variables.serviceUtility = createObject("component", "engine.com.framework.serviceUtility").init(authenticated=true)>
	#chr(60)#cfreturn this>
#chr(60)#/cffunction>



#chr(60)#cffunction name="saveSortOrder" access="public" output="false" returnType="string">
	
	#chr(60)#cftry>
		#chr(60)#cfset super.saveSortOrder(arguments.data.data)>
		#chr(60)#cfreturn "OK">

	#chr(60)#cfcatch>
		#chr(60)#cfreturn cfcatch.Message>
	#chr(60)#/cfcatch>
	
	#chr(60)#/cftry>

#chr(60)#/cffunction>


#chr(60)#!---  Disable all the table altering functions by default. Uncomment to use (with care!)--->
#chr(60)#cffunction name="list" access="public" output="false" returnType="void">#chr(60)#/cffunction>
#chr(60)#cffunction name="get" access="public" output="false" returnType="void">#chr(60)#/cffunction>
#chr(60)#cffunction name="add" access="public" output="false" returnType="void">#chr(60)#/cffunction>
#chr(60)#cffunction name="edit" access="public" output="false" returnType="void">#chr(60)#/cffunction>
#chr(60)#cffunction name="delete" access="public" output="false" returnType="void">#chr(60)#/cffunction>


#chr(60)#!--- 

#chr(60)#cffunction name="list" access="public" output="true" returnType="any">
		#chr(60)#cfparam name="arguments.data.format" default="json">
		#chr(60)#cfparam name="arguments.data.requestKey" default="">
		
		#chr(60)#cfif not serviceUtility.validateRequest(arguments.data.requestKey)>
			#chr(60)#cfabort showerror="Invalid Request">
		#chr(60)#/cfif>
		#chr(60)#cfset var result = super.list(data=arguments.data)>
		#chr(60)#cfset var formatedResult = format(result,arguments.data.format)>

		#chr(60)#cfreturn formatedResult>
#chr(60)#/cffunction>

	

#chr(60)#cffunction name="get" access="public" output="true" returnType="any">
		#chr(60)#cfparam name="arguments.data.format" default="json">
		
		#chr(60)#cfset var result = super.get(data=arguments.data)>
		#chr(60)#cfset var formatedResult = format(result,arguments.data.format)>

		#chr(60)#cfreturn formatedResult>
#chr(60)#/cffunction>



#chr(60)#cffunction name="add" access="public" output="false" returnType="any">
		#chr(60)#cfparam name="arguments.data" type="struct">
		#chr(60)#cfparam name="arguments.data.format" default="json">
		#chr(60)#cfparam name="arguments.data.requestKey" default="">
		
		#chr(60)#cftry>
			#chr(60)#cfif not serviceUtility.validateRequest(arguments.data.requestKey)>
				#chr(60)#cfabort showerror="ERROR:Invalid Request">
			#chr(60)#/cfif>
			
			#chr(60)#cfset validattionResults = super.validate(arguments.data)>
			#chr(60)#cfif validattionResults.isVAlid>
				#chr(60)#cfset newID = super.add(data=arguments.data)>
				#chr(60)#cfreturn newID>
			#chr(60)#cfelse>
				#chr(60)#cfreturn format(validattionResults, arguments.data.format)>
			#chr(60)#/cfif>
		
		#chr(60)#cfcatch>
			#chr(60)#cfreturn cfcatch.Message>
		#chr(60)#/cfcatch>
		
		#chr(60)#/cftry>		
#chr(60)#/cffunction>

#chr(60)#cffunction name="edit" access="public" output="false" returnType="string">
		#chr(60)#cfparam name="arguments.id" type="numeric">
		#chr(60)#cfparam name="arguments.data" type="struct">
		#chr(60)#cfparam name="arguments.data.format" default="json">
		#chr(60)#cfparam name="arguments.data.requestKey" default="">

	#chr(60)#cftry>		
		#chr(60)#cfif not serviceUtility.validateRequest(arguments.data.requestKey)>
			#chr(60)#cfabort showerror="Invalid Request">
		#chr(60)#/cfif>
		
		#chr(60)#cfset validattionResults = super.validate(arguments.data)>
		#chr(60)#cfif validattionResults.isValid>
			#chr(60)#cfset super.update(id=arguments.data.id,data=arguments.data)>
		#chr(60)#cfelse>
			#chr(60)#cfreturn format(validattionResults, arguments.data.format)>
		#chr(60)#/cfif>

		#chr(60)#cfreturn "OK">
		
	#chr(60)#cfcatch>
		#chr(60)#cfreturn cfcatch.Message>
	#chr(60)#/cfcatch>
	
	#chr(60)#/cftry>		
		
#chr(60)#/cffunction>

#chr(60)#cffunction name="delete" access="public" output="false" returnType="string">
		#chr(60)#cfparam name="arguments.data.id" type="numeric">

	#chr(60)#cftry>	
		#chr(60)#cfif not serviceUtility.validateRequest(arguments.data.requestKey)>
			#chr(60)#cfabort showerror="ERROR:Invalid Request">
		#chr(60)#/cfif>
		
		#chr(60)#cfset super.delete(id=arguments.data.id)>
		#chr(60)#cfreturn "OK">
		
		#chr(60)#cfcatch>
			#chr(60)#cfreturn cfcatch.Message>
		#chr(60)#/cfcatch>
		
	#chr(60)#/cftry>

#chr(60)#/cffunction>






 --->


#chr(60)#cffunction name="validate" access="public" output="true" returnType="any">
		#chr(60)#cfparam name="arguments.data.format" default="json">
		
		#chr(60)#cfset var result = super.validate(data=arguments.data)>
		#chr(60)#cfset var formatedResult = format(result,arguments.data.format)>

		#chr(60)#cfreturn formatedResult>
#chr(60)#/cffunction>


#chr(60)#cffunction name="format" access="private" output="false" returnType="any">
	#chr(60)#cfargument name="data"  type="any" required="true" hint="">
	#chr(60)#cfargument name="format" type="string" required="true" hint="">
	
		
		#chr(60)#cfif arguments.format eq 'JSON'>
			 #chr(60)#cfset formatedResult = SerializeJSON(arguments.data)>
		#chr(60)#cfelseif arguments.format eq 'WDDX'>
			#chr(60)#cfwddx action="cfml2wddx" input="##arguments.data##" output="formatedResult">
		#chr(60)#cfelseif arguments.format eq 'Dump'>
			#chr(60)#cfsavecontent variable="formatedResult">
			#chr(60)#cfdump var="##arguments.data##">
			#chr(60)#/cfsavecontent>
		#chr(60)#/cfif>
		
		#chr(60)#cfreturn formatedResult>
#chr(60)#/cffunction>


#chr(60)#/cfcomponent>




</cfoutput>
</cfsavecontent>