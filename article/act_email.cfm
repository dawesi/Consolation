<!--- 
Created By: Matt Chupp
Created On:	5/13/2010
Description: Action page for the email article Form
 --->
 
<cfparam name="attributes.emailcommenttext" default="" >
<cfparam name="attributes.recipientemail" default="" >
<cfparam name="attributes.recipientname" default="" >
<cfparam name="attributes.senderemail" default="" >
<cfparam name="attributes.sendername" default="" >
<cfparam name="attributes.thisarticleid" default="0" >
<cfparam name="attributes.thismainID" default="0" >

<cfif attributes.thisarticleid neq 0>
  <!--- add new campaign --->
  <cfquery datasource="#application.dsn#" name="insertemail">
	INSERT INTO  bizmag_email(
    articleID,
   emailcommenttext,
recipientemail,
recipientname,
senderemail,
sendername,
submitdate,
ipaddress
)
	VALUES(
    
<cfqueryPARAM value = "#val(attributes.thisarticleid)#" cfsqltype="cf_sql_integer" />,
<cfqueryPARAM value = "#trim(HtmlEditFormat(attributes.emailcommenttext))#" cfsqltype="cf_sql_longvarchar" />,
<cfqueryPARAM value = "#trim(HtmlEditFormat(attributes.recipientemail))#" cfsqltype="cf_sql_varchar" maxlength="255" />,
<cfqueryPARAM value = "#trim(HtmlEditFormat(attributes.recipientname))#" cfsqltype="cf_sql_varchar" maxlength="255" />,
<cfqueryPARAM value = "#trim(HtmlEditFormat(attributes.senderemail))#" cfsqltype="cf_sql_varchar" maxlength="255" />,
<cfqueryPARAM value = "#trim(HtmlEditFormat(attributes.sendername))#" cfsqltype="cf_sql_varchar" maxlength="255" />,
'#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(), "hh:mm tt")#',
'#trim(CGI.REMOTE_ADDR)#'
    )
	SELECT SCOPE_IDENTITY()  as maxemailID
	</cfquery>
  <cfset variables.thisemailID=insertemail.maxemailID>
  <!--- send email --->
  <!--- get article info --->
   <cfquery datasource="#application.dsn#" name="getarticle">
SELECT     articleID, articletypeID, articledate, headline, subhead, issueID, author, signoff, mainimage, mainthumbnail, featurethumbnail, frontlinesthumbnail, smallportrait, 
                      featureimage, articlesummary, articlecutline, submitdate, cutline, displayorder, externalURL, live
FROM         bizmag_articles
WHERE articleID=<cfqueryPARAM value = "#attributes.thisarticleID#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfif attributes.thismainID neq attributes.thisarticleid><cfset variables.mainurlparams = "&main=" & #val(attributes.thismainID)# /><cfelse><cfset variables.mainurlparams = ""></cfif>
    <cfmail from="ND BIZ MAG <bizalum.1@nd.edu>"
        to="#attributes.recipientemail#"
        server="smtp.nd.edu"
		subject="An article from the Notre Dame Business Magazine has been emailed for you to read"
		type="html">
        <p>#HtmlEditFormat(attributes.recipientname)#</p>
        <p>One of our readers, #HtmlEditFormat(attributes.sendername)#, has suggested that you be sent a link to the following article.</p>
        <p><a href="http://bizmagazine.business.nd.edu/article/?id=#attributes.thisarticleID##variables.mainurlparams#">#getarticle.headline#</a>
        <cfif attributes.emailcommenttext neq "">
        <p>Their message is below:<br />#attributes.emailcommenttext#</p>
        </cfif>
      </cfmail>

  <cfelse>
 <!--- error has occurred send email --->
  <cfmail from="ND BIZ MAG <#application.adminemail#>"
        to="#application.adminemail#"
        server="smtp.nd.edu"
		subject="An error has occured trying to submit an email for article #attributes.thisarticleid#"
		type="html">
        <p>Here is the error</p>
      </cfmail>
</cfif>
<cfoutput>
<cflocation url="/article/?id=#attributes.thisarticleid##variables.mainurlparams#" addtoken="No">
</cfoutput>
 