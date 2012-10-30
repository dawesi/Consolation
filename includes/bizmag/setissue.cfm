<cfparam name="attributes.allow" default="0" />
<cfparam name="attributes.issueID" default="0" />
<cfparam name="attributes.ID" default="0" />
<cfquery datasource="#application.dsn#" name="getmostrecentissue">
SELECT     issueID
FROM         bizmag_issues
WHERE     (live = 1)
ORDER BY issuedate DESC
</cfquery>
<cfif val(attributes.id) neq 0>
<cfquery datasource="#application.dsn#" name="getcurrentissue">
SELECT     issueID
FROM         bizmag_articles
WHERE     (articleID = #val(attributes.ID)#)
</cfquery>
  <cfset variables.thisissueID = val(getcurrentissue.issueID) />
<cfelseif val(attributes.issueID) eq 0>
  <!---sets to newest issue --->
<cfset variables.thisissueID = val(getmostrecentissue.issueID) />
<cfset getcurrentissue.issueID = val(getmostrecentissue.issueID) />
<cfelse>
<!--- issueID is in URL check to make sure it is valid --->
<cfquery datasource="#application.dsn#" name="getcurrentissue">
SELECT     issueID
FROM         bizmag_issues
WHERE     issueID = <cfqueryparam value="#val(attributes.issueID)#" cfsqltype="cf_sql_integer" /> <cfif val(attributes.allow) eq 0>and live = 1</cfif>
</cfquery>
<cfif getcurrentissue.recordcount neq 0>
<cfset variables.thisissueID = val(getcurrentissue.issueID) />
<cfelse>
<!--- issue isn't live for production site throw send them to most recent and throw error--->
<cflocation url="/?errortype=1" addtoken="no">
</cfif>
</cfif>
<cfset attributes.issueID = val(variables.thisissueID) />
