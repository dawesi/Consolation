<cfcomponent output="false" hint="A normal ColdBox event handler"> 
	<cfproperty name="consoleConfig" inject="coldbox:setting:consolation" >
	
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
    	<cfset rc.consoleConfig = consoleConfig>
    	<cfset event.setView("home/settings")>
		
    </cffunction>

</cfcomponent>