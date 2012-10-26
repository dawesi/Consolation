<cfcomponent output="false" hint="A normal ColdBox event handler">
	<!--- index --->
    <cffunction name="index" output="false" hint="Index">
    	<cfargument name="event">    	
    	<cfset event.setView("home/index")>
    </cffunction>

    <cffunction name="api" output="false" hint="Index">
    	<cfargument name="event">
    	<cfset event.setView("home/api")>
    </cffunction>


    <cffunction name="settings" output="false" hint="Index">
    	<cfargument name="event">
		<cfset var rc =  event.getCollection()>
		
    	<cfset event.setView("home/settings")>
    </cffunction>

</cfcomponent>