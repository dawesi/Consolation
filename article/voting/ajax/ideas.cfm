<cfif IsDefined("URL.Action") AND Len(URL.Action)>
	<cfif URL.Action EQ "Vote">
		<cfif IsDefined("URL.IdeaID") AND IsValid("integer",URL.IdeaID) AND IsDefined("URL.Direction") AND Len(URL.Direction) AND (URL.Direction EQ "Up" OR URL.Direction EQ "Down")>
			<cftry>
				<!--- Init a vote type holder var --->
				<cfset VoteType = "">
				
				<!--- Set the VoteType, based upon the URL Value --->
				<cfif URL.Direction EQ "Up">
					<cfset VoteType = "Up">
				<cfelseif URL.Direction EQ "Down">
					<cfset VoteType = "Down">
				</cfif>
				
				<!--- Perform our database insert --->
				<cfquery datasource="#application.dsn#" name="ProcessVote">
					<!--- Ensure that we are not comitting a duplicate vote for the same IP/IdeaID combination --->
					IF NOT EXISTS (Select ID From bizmag_ideas_votes WHERE IdeaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.IdeaID#"> AND IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">)
					BEGIN
						INSERT INTO bizmag_ideas_votes( IdeaID, Type, IP)
						VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.IdeaID#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#VoteType#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
								)
					END
				</cfquery>
			
				<!--- Clear the page's content headers and stream, to show only the result --->
				<cfcontent reset="true" /> <cfoutput>success</cfoutput>
				
					<!--- If an error occurs during insert, catch and report --->
					<cfcatch>
						<cfcontent reset="true" /> <cfoutput>error - during vote insert</cfoutput>
					</cfcatch>
			</cftry>
		<cfelse>
			<cfcontent reset="true" /> <cfoutput>error - missing/incorrect information</cfoutput>
		</cfif>
	</cfif>
<cfelse>
	<cfoutput>Error, you must specify an Action!</cfoutput>
</cfif>