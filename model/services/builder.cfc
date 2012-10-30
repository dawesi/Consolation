<cfcomponent  extends="scaffoldUtility">
	
<cffunction name="init" returntype="builder">	
	<cfreturn this>
</cffunction>


<cffunction name="writeParam" returntype="string"  access="public" output ="false" description="This will take a form element type, name and default and write the cfparam for it">
	
	<cfargument name="model" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="default" type="string" required="false" default="">
	
	<cfargument name="formType" type="string" required="false" default="I">
	
	<cfset arguments.property = camelCase(arguments.property)>
			
	<cfif arguments.formType eq "U">
		<cfset code = '<cfparam name="form.#arguments.property#" default="##rc.#arguments.model#.#arguments.property###">
	'> 
			<cfelse>
		<cfset code = '	<cfparam name="form.#arguments.property#" default="">		
	'> 
			</cfif>		
	
		<cfreturn code>

</cffunction>


<cffunction name="build" access="public" output="false" returnType="string">
	<cfargument name="element" type="string" required="true" hint="">
	<cfargument name="name" type="string" required="true">
	<cfargument name="label" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	
	<cfargument name="required" type="boolean" required="false" default="false">
	
	<cfargument name="size" type="numeric" required="false" default="25">
	<cfargument name="maxsize" type="numeric" required="false" default="50">
	<cfargument name="precision" type="any" required="false" default="0">
	
	<cfargument name="source" type="string" required="false" default="">
	<cfargument name="default" type="string" required="false" default="">
	
	<cfargument name="valueField" type="string" required="false" default="">
	<cfargument name="displayField" type="string" required="false" default="name">
	
	<cfargument name="layout" type="string" required="false" default="p" hint="" />
	<cfargument name="position" type="string" required="false" hint="" default="h">
				
	
	<cfswitch expression="#arguments.element#">
	
	
	
	<cfcase value="select" >
			<cfset returnedCode = 
					writeDropdown(	
								label=arguments.label, 
								name=arguments.name, 
								default=arguments.default, 
								required=arguments.required, 
								position=arguments.position,
								model=arguments.model, 
								value=arguments.valueField, 
								display=displayField )
								>
		</cfcase>
		
		
		<cfcase value="text" >
			<cfset returnedCode = 
					writeText(	
								label=arguments.label, name=arguments.name, default=arguments.default, 
								size=arguments.size, maxsize=arguments.maxsize,
								required=arguments.required, position=arguments.position )
								>
		</cfcase>
		
		<cfcase value="textArea" >
			<cfset returnedCode = 
					writeTextArea(	
								label=arguments.label, name=arguments.name, default=arguments.default, 
								size=arguments.size, maxsize=arguments.maxsize,
								required=arguments.required )
								>
		</cfcase>
		
		<cfcase value="date" >
			<cfset returnedCode = 
					writeDate(	
								label=arguments.label, name=arguments.name, default=arguments.default, 
								required=arguments.required, position=arguments.position )
								>
		</cfcase>
		
		<cfcase value="boolean" >
			<cfset returnedCode = 
					writeBoolean(	
								label=arguments.label, name=arguments.name, default=arguments.default, 
								required=arguments.required, position=arguments.position )
								>
		</cfcase>
		
		
		
		<cfcase value="number" >
			<cfset returnedCode = 
					writeNumeric(	
								label=arguments.label, name=arguments.name, default=arguments.default, 
								size=arguments.size, maxsize=arguments.maxsize,
								required=arguments.required, position=arguments.position )
								>
		</cfcase>
		
		
		<cfcase value="hidden" >
			<cfset returnedCode = 
					writeHidden(name=arguments.name, default=arguments.default)
								>
		</cfcase>
	</cfswitch> 
	
	
			<cfreturn returnedCode>
	
</cffunction>




<cffunction name="writeText" access="private" output="false" returnType="string">
	<cfargument name="label" type="string" required="true" hint="">
	<cfargument name="name" type="string" required="true" hint="">
	<cfargument name="default" type="string" required="true" hint="">
	<cfargument name="size" type="numeric" required="true" hint="">
	<cfargument name="maxsize" type="numeric" required="true" hint="">
	<cfargument name="required" type="boolean" required="true" hint="">
	<cfargument name="position" type="string" required="true" hint="">
	
	<cfset code = '<form:text label="#arguments.label#" name="#arguments.name#" default="##form.#arguments.name###" required="#arguments.required#" size="#arguments.size#" max="#arguments.maxsize#" position="#arguments.position#" >'>
	<cfreturn code>
	
</cffunction>

<cffunction name="writeTextArea" access="private" output="false" returnType="string">
	<cfargument name="label" type="string" required="true" hint="">
	<cfargument name="name" type="string" required="true" hint="">
	<cfargument name="default" type="string" required="true" hint="">
	<cfargument name="size" type="numeric" required="true" hint="">
	<cfargument name="required" type="boolean" required="true" hint="">
	<cfargument name="position" type="string" required="false" hint="v or h" default="v">
	
	<cfset code = '<form:textarea label="#arguments.label#" name="#arguments.name#" default="#arguments.default#" position="#arguments.position#">'>
	<cfreturn code>

</cffunction>

<cffunction name="writeDate" access="private" output="false" returnType="string">
	<cfargument name="label" type="string" required="true" hint="">
	<cfargument name="name" type="string" required="true" hint="">
	<cfargument name="default" type="string" required="true" hint="">
	<cfargument name="required" type="boolean" required="true" hint="">
	
	<cfset code = '<form:date label="#arguments.label#" name="#arguments.name#" default="##form.#arguments.name###" required="#arguments.required#"  position="#arguments.position#" >'>
	<cfreturn code>
</cffunction>

<cffunction name="writeBoolean" access="private" output="false" returnType="string">
	<cfargument name="label" type="string" required="true" hint="">
	<cfargument name="name" type="string" required="true" hint="">
	<cfargument name="default" type="string" required="true" hint="">
	<cfargument name="size" type="numeric" required="true" hint="" default="1">
	<cfargument name="required" type="boolean" required="true" hint="">
	
	<cfset code = '<form:boolean label="#arguments.label#" name="#arguments.name#" default="##form.#arguments.name###" format="Radio" values="1,0" required="#arguments.required#"  position="#arguments.position#" >'>
	<cfreturn code>
</cffunction>

<cffunction name="writeDropDown" access="private" output="false" returnType="string">
	<cfargument name="label" type="string" required="true" hint="">
	<cfargument name="name" type="string" required="true" hint="">
	<cfargument name="default" type="string" required="true" hint="">
	
	<cfargument name="required" type="boolean" required="true" hint="">
	<cfargument name="model" type="string" required="true" hint="">
	<cfargument name="value" type="string" required="true" hint="">
	<cfargument name="display" type="string" required="true" hint="">
	<cfargument name="filter" type="string" required="false" hint="" default="">
	
	<cfset code = '<form:select label="#arguments.label#" 	name="#arguments.name#" required="#arguments.required#" model="#arguments.model#" value="id" display="#arguments.display#" default="##form.#arguments.name###" filter="#arguments.filter#" position="#arguments.position#" >'>
	<cfreturn code>
</cffunction>

<cffunction name="writeNumeric" access="private" output="false" returnType="string">
	<cfargument name="label" type="string" required="true" hint="">
	<cfargument name="name" type="string" required="true" hint="">
	<cfargument name="default" type="string" required="true" hint="">
	<cfargument name="size" type="numeric" required="true" hint="">
	<cfargument name="maxsize" type="numeric" required="true" hint="">
	<cfargument name="required" type="boolean" required="true" hint="">
	
	<cfset code = '<form:text label="#arguments.label#" name="#arguments.name#" default="##form.#arguments.name###" required="#arguments.required#" size="#arguments.size#" max="#arguments.maxsize#" position="#arguments.position#" >'>
	<cfreturn code>
</cffunction>

<cffunction name="writeHidden" access="private" output="false" returnType="string">
	
	<cfargument name="name" type="string" required="true" hint="">
	<cfargument name="default" type="string" required="true" hint="">
		
	<cfset code = '<form:hidden  name="#arguments.name#" default="#arguments.default#" >'>
	<cfreturn code>
	
</cffunction>
</cfcomponent>