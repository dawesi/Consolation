<!---
Application.cfc reference

materials for this page were obtained from the following sources:
	http://www.bennadel.com/blog/726-ColdFusion-Application-cfc-Tutorial-And-Application-cfc-Reference.htm
	http://ray.camdenfamily.com/downloads/app.pdf
--->
<cfcomponent displayname="nd" output="false" hint="Handle the application.">
<!--- set up the application --->
<cfset this.name 		= "nd" />
<cfset this.applicationTimeout	= createTimeSpan(0,2,0,0) />
<cfset this.sessionManagement 	= true />
<cfset this.sessionTimeout 	= createTimeSpan(0,0,45,0) />
<cfset this.setClientCookies 	= true />
<!--- define the page request properties --->
<cfsetting requesttimeout="20" showdebugoutput="false" enablecfoutputonly="false" />
<cffunction name="onApplicationStart" access="public" returntype="boolean" output="false" hint="fires when the application is first created.">
  <!---
		This is the perfect place to define application-scoped variables (ex. application.DSN for data source structures).
		If this method is invoked manually, be sure to call structClear() on the application scope before you re-initialize the data values.
		This will help to ensure a clean refresh.

		The return boolean signals as to whether or not the application loaded successfully.
		Returning false will halt the processing of the rest of the events of the current page request.
		--->
<!--- set contact variables --->
<cfset application.embaphone="1-800-631-3622">
<cfset application.embalocalphone="574-631-5285">
<cfset application.embafax="574-631-6783">

<cfset application.mbaphone="1-800-631-8488">
<cfset application.mbalocalphone="574-631-8488">
<cfset application.mbafax="574-631-8800">

<cfset application.fromemail="">
<cfset application.mbaemail="mba.business@nd.edu">
<cfset application.embaemail="emba.business@nd.edu">
<cfset application.tollfree="">
<!---  site variables --->
<cfset application.siteliteral="webapp.business.nd.edu ">
<cfset application.sitedomain="webapp.business.nd.edu ">
<cfset application.siteadmin="/admin/">
<cfset application.sitetechnical="http://webapp.business.nd.edu">
<cfset application.companyname="Mendoza College of Business">
<cfset application.companynickname="MCOB">
<cfset application.adminname="#application.adminname#">
<cfset application.adminemail="mmwg@nd.edu">

<!--- set system variables --->
<!---<cfset application.emailserver="smtp.nd.edu">--->
<cfset application.emailuser="">
<cfset application.emailwebmaster="bcook1@nd.edu">
<cfset application.emailpassword="">
<cfset application.dsn="markgroup">
<cfset application.cmsdsn="cms_mendoza">
<cfset application.cmsdevdsn="cmsdev"> 
<cfset application.deepdivedsn="markgroup_galleon"> 
<cfset application.mcob="mcob"> 
<cfset application.key="n&d1">
<cfset application.googlemapskey="ABQIAAAAc6NVSMJppqvBbI4NyHnD4RR202y-0uSoAR1T7tqRimD7V06s-RRriVMvGL-clJjZkrrT-DuUShHi4w">
<cfset application.userFilesPath="/userfiles/">
<cfset application.jquerypath="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js">
<cfset application.jqueryUIpath="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/jquery-ui.min.js">
<cfset application.jqueryvalidatepath="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.8.1/jquery.validate.min.js">
<!---<cfset application.cmsuserFilesPath="w:\web\www\userfiles\">--->
<!--- custom fields used in the site --->
<cfset application.tailgate_open_date="8/1/2011 2:16 PM">
<cfcookie name="CFID" value="#CFID#">
<cfcookie name="CFTOKEN" value="#CFTOKEN#">
  <cfreturn true />
</cffunction>
<cffunction name="onSessionStart" access="public" returntype="void" output="false" hint="fires when the session is first created.">
  <!---
		This is the perfect place to define session-scoped variables (ex. session.cart for eCommerce cart data).
		If this method is invoked manually, be sure to call structClear() on the session scope before you re-initialized the data values.
		HOWEVER! before clearing the scope, get a copy of the CFID/CFTOKEN values so that you can store them back into the session during re-initialization.
		ColdFusion will not automatically re-create these values as calling this event method is not actually restarting the session.
		--->
  <cfreturn />
</cffunction>
<cffunction name="onRequestStart" access="public" returntype="boolean" output="false" hint="fires at first part of page processing.">
  <cfargument name="TargetPage" type="string" required="true" />
  <!---
		This the perfect place to define request-specific and other request-scoped variables (ex. request.attributes for the union of the form/URL scopes).
		This is also a good place to do universal form value scrubbing (such as removing smart quotes and trimming form field values).

		If your application or sessions can handle manual re-initialization, this is a good place to check for those URL flags (ex. structKeyExists(URL, 'resetApp'))
		and then manually invoke the OnApplicationStart() or OnSessionStart() application events.

		If you are using the OnRequest() method and you expect this application to be used for flash remoting or CFC-based web service calls,
		this is the ideal time at which to check for the request type (standard page request vs. web service) and if need be,
		delete the OnRequest() method from the Application.cfc (ex. structDelete(this, "OnRequest")).

		If the return value is false, the page processing will be halted.
		--->
  <cfset attributes = duplicate( url ) />
  <cfset structAppend( attributes, form ) />
  <cfreturn true />
</cffunction>
<cffunction name="onRequest" access="public" returntype="void" output="true" hint="fires after pre page processing is complete.">
  <cfargument name="TargetPage" type="string" required="true" />
  <!---
		If you include this event then you must include the requested page via a cfinclude tag.
		The relative path of the template is passed as the only argument to this function.
		If you include the page in this manner, the processed template becomes what is essentially a "Mix-In" of the Application.cfc,
		meaning that it is actually part of the Application.cfc code.
		If you do this, the processed page will have access to the this and variables scopes of the Application.cfc.

		If the request page is included in this manner, it also means that the requested page will have access to all methods defined in the Application.cfc.

		This is the perfect place to handle login management. Since this method determines which template gets executed,
		this is where you can check login status and conditionally include the login template rather than the requested template.
		--->
  <!--- include the requested page. --->
  <cfinclude template="#arguments.TargetPage#" />
  <cfreturn />
</cffunction>
<cffunction name="onRequestEnd" access="public" returntype="void" output="true" hint="fires after the page processing is complete.">
</cffunction>
<cffunction name="onSessionEnd" access="public" returntype="void" output="false" hint="fires when the session is terminated.">
</cffunction>
<cffunction name="onApplicationEnd" access="public" returntype="void" output="false" hint="fires when the application is terminated.">
  <cfargument name="applicationScope" type="struct" required="false" default="#structNew()#" />
  <!---
		This is the perfect place to log information about the application.
		This method does not have inherent access to the application scope. In order to access that scope, you must used the passed in argument.
		--->
  <cfreturn />
</cffunction>
<!--- <cffunction name="onError" access="public" returntype="void" output="true" hint="fires when an exception occures that is not caught by a try/catch.">
  <cfargument name="Exception" type="any" required="true" />
  <cfargument name="EventName" type="string" required="false" default="" />
  <!---
		This event gets called when an event fires and allows you to handle that error and include an error handling template if you so desire.
		However, this event cannot display anything to the user if the error occurs during the OnApplicationEnd() or OnSessionEnd() events
		as those are not request-related (unless called explicitly during a request).

		One thing to be aware of (as of MX7) is that the <cflocation> tag throws a runtime Abort exception
		(which makes sense if you understand that the <cflocation> tag halts the page and flushes header information to the browser).
		As a work around to this, you can check the passed in Exception type and if its a Abort exception do not process the error:
		<cfif NOT compareNoCase(arguments.Exception.RootCause.Type, "coldfusion.runtime.AbortException")>
			<!--- do not process this error --->
			<cfreturn />
		</cfif>
		--->
  <cfreturn />
</cffunction> --->
</cfcomponent>