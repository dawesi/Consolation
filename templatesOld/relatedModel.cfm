
<cfsavecontent variable="relatedModel">

<cfoutput>#chr(60)#</cfoutput>cfset data = arguments.data>

<cfoutput>
	#chr(60)#h3>#chr(60)#cfoutput>##data.title###chr(60)#/cfoutput>#chr(60)#/h3>
	#chr(60)#cfoutput query="data.query">
	#chr(60)#p>
	#chr(60)#a href="##cgi.script_name##?##data.title##.Detail&ID=##application.com.utility.urlEncrypt(id)##">
	##name##
	</a>
	#chr(60)#/p>
	#chr(60)#/cfoutput>
</cfoutput>
</cfsavecontent>