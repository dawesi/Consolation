<cfsavecontent variable="childCode">
<cfoutput>

#chr(60)#!---#chr(60)#cfif children.recordcount>

<div class="related-item-container">

#chr(60)#cfoutput>
	<cfloop query="children">
		<cfset objectName = "q#session.scaffolder.findComponent(children.name)#s"> 
		
		<div class="related-item">
		
		#chr(60)#cfset #objectName# = application.com.#session.scaffolder.findComponent(children.name)#.get(#form.component_name#ID=url.ID)>
		<h3>Related Item: #children.name#</h3>
		#chr(60)#cfoutput query="q#session.scaffolder.findComponent(children.name)#s">
		
		<p> <a href="index.cfm?#session.scaffolder.findComponent(children.name)#.Detail&ID=##palmEncrypt(q#session.scaffolder.findComponent(children.name)#s.id)##">		##q#session.scaffolder.findComponent(children.name)#s.#session.scaffolder.getPrimaryColumn(children.name)###</a></p>
		#chr(60)#/cfoutput>
		
		</div>
	
	</cfloop>
#chr(60)#/cfoutput>
</div>

#chr(60)#/cfif>
--->

</cfoutput>
</cfsavecontent>