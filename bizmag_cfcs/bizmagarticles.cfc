<!--- 
Created By: Matt Chupp
Created On:	5/19/2010
Description: ND Business Magazine Article Functions
 --->
<cfcomponent>
      <cffunction name="getIssueArticles"
               returntype="query"
               hint="Get a complete article record for this issue">
  <cfargument name="thisissueID"
                  type="string"
                  required="true"
                  hint="Issue ID is required">
  <!--- Get all articles --->
  <cfquery name="allarticles" datasource="#application.dsn#">
SELECT     bizmag_issues.issueID, bizmag_issues.issuename, bizmag_issues.pdflink, bizmag_issues.pdfimage, bizmag_articles.displayorder, bizmag_articles.headline, 
                      bizmag_articles.articleID,bizmag_articles.urlslug, bizmag_articles.articletypeID, bizmag_articles.articledate, bizmag_articles.issueID AS Expr1, bizmag_articles.author, 
                      bizmag_articles.mainimage, bizmag_articles.mainthumbnail, bizmag_articles.featurethumbnail, bizmag_articles.frontlinesthumbnail, bizmag_articles.smallportrait, 
                      bizmag_articles.featureimage, bizmag_articles.articlesummary, bizmag_articles.subhead, bizmag_articles.signoff, bizmag_articles.articlecutline, 
                      bizmag_articles.submitdate, bizmag_articles.cutline, bizmag_articles.externalURL, bizmag_issuedates.seasonimage, bizmag_issues.issuedate
FROM         bizmag_issues INNER JOIN
                      bizmag_articles ON bizmag_issues.issueID = bizmag_articles.issueID INNER JOIN
                      bizmag_issuedates ON bizmag_issues.seasonID = bizmag_issuedates.seasonID
WHERE     bizmag_issues.issueID=<cfqueryPARAM value = "#ARGUMENTS.thisissueID#" CFSQLType = "CF_SQL_INTEGER"> and bizmag_articles.live = 1
ORDER BY bizmag_articles.articletypeID, bizmag_articles.displayorder
      </cfquery>
  <cfreturn allarticles>
</cffunction>
      <cffunction name="getrotatorArticles" returntype="query">
  <cfargument name="thisIssueid" required="true" />
  <cfargument name="numtoreturn" required="false" />
  <!--- get the cached data --->
  <cfset var qCached = getIssueArticles(thisIssueid) />
  <cfset var q = "" />
  <cfparam name="numtoreturn" default="0">
  <cfif val(numtoreturn) eq 0>
          <cfset numtoreturn = 4 />
        </cfif>
  <!--- query cached data to get actual record --->
  <cfquery name="q" dbtype="query" maxrows="#numtoreturn#">
      SELECT articleID, urlslug,articletypeID, headline, subhead, featurethumbnail, featureimage, displayorder, externalURL
      FROM qCached
      WHERE articletypeid in (1,11)
      ORDER BY articletypeid desc, displayorder
    </cfquery>
  <cfreturn q />
</cffunction>
      <!--- get class notes for home page --->
      <cffunction name="getIssueClassNotes" returntype="query">
  <cfargument name="thisIssueid" required="true" />
  <cfargument name="numtoreturn" required="false" />
  <!--- get the cached data --->
  <cfset var gettop = "" />
  <cfset var q = "" />
  <cfparam name="numtoreturn" default="0">
  <cfif val(numtoreturn) eq 0>
          <cfset numtoreturn = 5 />
        </cfif>
  <!--- query cached data to get actual record --->
  <cfquery name="gettop" datasource="#application.dsn#" maxrows="#numtoreturn#">
SELECT     classnotes.classnotesID, classnotes.firstname, classnotes.issueID, classnotes.lastname, classnotes.middlename, classnotes.portrait, classnotes.classyear, 
                      classnotes.live, classnotes_issueassoc.displayorder, classnotes.degreedetail, classnotes_gradyear.backgroundimage
FROM         classnotes INNER JOIN
                      classnotes_issueassoc ON classnotes.classnotesID = classnotes_issueassoc.classnotesID INNER JOIN
                      classnotes_gradyear ON classnotes.classyear = classnotes_gradyear.classyear
WHERE     (classnotes.issueID = <cfqueryPARAM value = "#val(thisIssueid)#" CFSQLType = "CF_SQL_INTEGER">) AND (classnotes.live = 1)
ORDER BY classnotes_issueassoc.displayorder
    </cfquery>
  <cfquery name="q" dbtype="query">
      SELECT backgroundimage, classnotesid, classyear, degreedetail, displayorder, firstname, issueid, lastname, live, middlename, portrait
      FROM gettop
      ORDER BY classyear desc
    </cfquery>
  <cfreturn q />
</cffunction>
      <!--- ***** GET Notes Page**** --->
      <cffunction name="getNotesPage" returntype="string">
  <cfargument name="thisNoteid" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <cfset var template = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     classnotes_updatetype.templateurl
FROM         classnotes INNER JOIN
                      classnotes_assoc ON classnotes.classnotesID = classnotes_assoc.classnotesID INNER JOIN
                      classnotes_updatetype ON classnotes_assoc.updatetypeID = classnotes_updatetype.updatetypeID
WHERE classnotes.classnotesID = <cfqueryPARAM value = "#val(thisNoteid)#" CFSQLType = "CF_SQL_INTEGER">
ORDER BY classnotes_updatetype.templateurl desc
</cfquery>
  <cfset template = q.templateurl />
  <cfreturn template />
</cffunction>
      <!--- ***** GET ARTICLE **** --->
      <cffunction name="getArticle" returntype="query">
  <cfargument name="thisArticleid" required="true" />
  <cfargument name="thispage" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     TOP (1) bizmag_articles.articleID,bizmag_articles.urlslug, bizmag_articles.articletypeID, bizmag_articles.articledate, bizmag_articles.headline, bizmag_articles.subhead, 
                      bizmag_articles.issueID, bizmag_articles.author, bizmag_articles.signoff, bizmag_articles.mainimage, bizmag_articles.mainthumbnail, bizmag_articles.content_ID,
                      bizmag_articles.featurethumbnail, bizmag_articles.frontlinesthumbnail, bizmag_articles.smallportrait, bizmag_articles.featureimage, bizmag_articles.articlesummary, 
                      bizmag_articles.articlecutline, bizmag_articles.submitdate, bizmag_articles.cutline, bizmag_articles.displayorder, bizmag_articles.externalURL, bizmag_articles.live, 
                      bizmag_articletype.articleType, bizmag_articlepages.pagenumber, bizmag_articlepages.pagecopy
FROM         bizmag_articles INNER JOIN
                      bizmag_articlepages ON bizmag_articles.articleID = bizmag_articlepages.articleID INNER JOIN
                      bizmag_articletype ON bizmag_articles.articletypeID = bizmag_articletype.articleTypeID
WHERE bizmag_articles.articleID = <cfqueryPARAM value = "#val(thisArticleid)#" CFSQLType = "CF_SQL_INTEGER"> and bizmag_articlepages.pagenumber=<cfqueryPARAM value = "#val(thispage)#" CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
  <cfreturn q />
</cffunction>
      <!--- ***** GET ENTIRE ARTICLE **** --->
      <cffunction name="getEntireArticle" returntype="query">
  <cfargument name="thisArticleid" required="true" />
  
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     bizmag_articles.articleID,bizmag_articles.urlslug, bizmag_articles.articletypeID, bizmag_articles.articledate, bizmag_articles.headline, bizmag_articles.subhead, bizmag_articles.issueID, 
                      bizmag_articles.author, bizmag_articles.signoff, bizmag_articles.mainimage, bizmag_articles.mainthumbnail, bizmag_articles.featurethumbnail, 
                      bizmag_articles.frontlinesthumbnail, bizmag_articles.smallportrait, bizmag_articles.featureimage, bizmag_articles.articlesummary, bizmag_articles.articlecutline, 
                      bizmag_articles.submitdate, bizmag_articles.cutline, bizmag_articles.displayorder, bizmag_articles.externalURL, bizmag_articles.live, 
                      bizmag_articletype.articleType, bizmag_articlepages.pagenumber, bizmag_articlepages.pagecopy
FROM         bizmag_articles INNER JOIN
                      bizmag_articlepages ON bizmag_articles.articleID = bizmag_articlepages.articleID INNER JOIN
                      bizmag_articletype ON bizmag_articles.articletypeID = bizmag_articletype.articleTypeID
WHERE     (bizmag_articles.articleID = <cfqueryPARAM value = "#val(thisArticleid)#" CFSQLType = "CF_SQL_INTEGER">) AND (bizmag_articles.live = 1)
ORDER BY bizmag_articlepages.pagenumber 
    </cfquery>
  <cfreturn q />
</cffunction>
      <cffunction name="getPageCount" returntype="query">
  <cfargument name="thisArticleid" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     bizmag_articlepages.pagenumber
FROM         bizmag_articles INNER JOIN
                      bizmag_articlepages ON bizmag_articles.articleID = bizmag_articlepages.articleID
WHERE bizmag_articles.articleID = <cfqueryPARAM value = "#val(thisArticleid)#" CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
  <cfreturn q />
</cffunction>
      <!--- get related content --->
      <cffunction name="getRelatedContent" returntype="query">
  <cfargument name="thisArticleid" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     bizmag_articleassoc.subarticleID,bizmag_articles.urlslug, bizmag_articles.headline, bizmag_articles.externalURL, bizmag_articleassoc.subarticleorder
FROM         bizmag_articleassoc INNER JOIN
                      bizmag_articles ON bizmag_articleassoc.subarticleID = bizmag_articles.articleID
WHERE     (bizmag_articleassoc.articleID = <cfqueryPARAM value = "#val(thisArticleid)#" CFSQLType = "CF_SQL_INTEGER">) AND (bizmag_articles.live = 1) and bizmag_articles.externalURL = ''
ORDER BY bizmag_articles.displayorder
    </cfquery>
  <cfreturn q />
</cffunction>
      <!---  --->
      <!--- get related links --->
      <cffunction name="getRelatedLinks" returntype="query">
  <cfargument name="thisArticleid" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     bizmag_articleassoc.subarticleID,bizmag_articles.urlslug, bizmag_articles.headline, bizmag_articles.externalURL, bizmag_articleassoc.subarticleorder
FROM         bizmag_articleassoc INNER JOIN
                      bizmag_articles ON bizmag_articleassoc.subarticleID = bizmag_articles.articleID
WHERE     (bizmag_articleassoc.articleID = <cfqueryPARAM value = "#val(thisArticleid)#" CFSQLType = "CF_SQL_INTEGER">) AND (bizmag_articles.live = 1) and bizmag_articles.externalURL <> ''
ORDER BY bizmag_articles.displayorder
    </cfquery>
  <cfreturn q />
</cffunction>
      <!---  --->
      <!--- get comments --->
      <cffunction name="getcomments" returntype="query">
  <cfargument name="thisArticleid" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     bizmag_articles.headline, bizmag_articles.externalURL, bizmag_comments.submitdate, bizmag_comments.commentname, bizmag_comments.commenttext, 
                      bizmag_comments.businessprogram, bizmag_comments.gradYear
FROM         bizmag_articles INNER JOIN
                      bizmag_comments ON bizmag_articles.articleID = bizmag_comments.articleID
WHERE     bizmag_comments.live = 1 AND bizmag_articles.articleID = <cfqueryPARAM value = "#val(thisArticleid)#" CFSQLType = "CF_SQL_INTEGER">
ORDER BY bizmag_comments.submitdate
    </cfquery>
  <cfreturn q />
</cffunction>

      <!--- get parent article --->
      <cffunction name="getparentarticle" returntype="query">
  <cfargument name="thisArticleid" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
SELECT     headline, externalURL,articleID,urlslug,articletypeID
FROM         bizmag_articles 
WHERE     (articleID = <cfqueryPARAM value = "#val(thisArticleid)#" CFSQLType = "CF_SQL_INTEGER">) AND (live = 1)
    </cfquery>
  <cfreturn q />
</cffunction>
<cffunction name="addComment" access="public" returntype="numeric" hint="For
Adding a Comment to the DB">
  <cfargument name="thisArticleID" required="yes">
  <cfargument name="businessprogram" required="yes">
  <cfargument name="commentname" required="yes">
  <cfargument name="commenttext" required="yes">
  <cfargument name="email" required="yes">
  <cfargument name="gradyear" required="yes">
  <cftransaction>
<cfquery datasource="#application.dsn#" name="checkforSpam">
SELECT     spamID, ipaddress
FROM         bannedips
WHERE ipaddress = '#trim(CGI.REMOTE_ADDR)#'
</cfquery>

<cfif checkforSpam.recordcount eq 0>
<cfquery datasource="#application.dsn#" name="insertComment">
INSERT INTO  bizmag_comments(
articleID,
businessprogram,
commentname,
commenttext,
email,
gradyear,
submitdate,
ipaddress,
live
)
	VALUES(
<cfqueryPARAM value = "#val(thisArticleID)#" cfsqltype="cf_sql_integer" />,
<cfqueryPARAM value = "#trim(businessprogram)#" cfsqltype="cf_sql_varchar" maxlength="255" />,
<cfqueryPARAM value = "#trim(commentname)#" cfsqltype="cf_sql_varchar" maxlength="255" />,
<cfqueryPARAM value = "#trim(commenttext)#" cfsqltype="cf_sql_longvarchar" />,
<cfqueryPARAM value = "#trim(email)#" cfsqltype="cf_sql_varchar" maxlength="255" />,
<cfqueryPARAM value = "#trim(gradyear)#" cfsqltype="cf_sql_varchar" maxlength="255" />,
'#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(), "hh:mm tt")#',
'#trim(CGI.REMOTE_ADDR)#',
0  
    )
	SELECT SCOPE_IDENTITY()  as maxcommentID
	</cfquery>
    <cfelse>
    <cfquery datasource="#application.dsn#" name="insertComment">
    INSERT INTO blockedips
                      (ipaddress, blockeddate)
VALUES     ('#trim(CGI.REMOTE_ADDR)#','#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(), "hh:mm tt")#')
</cfquery>
    <cfset insertcomment.maxcommentID = 0 />
    </cfif>
        </cftransaction>
  <cfreturn insertcomment.maxcommentID>
</cffunction>
      <cffunction name="getallArticleType" returntype="query">
  <cfargument name="thisIssueid" required="true" />
  <cfargument name="thisTypeID" required="true" />
  <cfargument name="numtoreturn" required="false" />
  <!--- get the cached data --->
  <cfset var qCached = getIssueArticles(thisIssueid) />
  <cfset var q = "" />
  <cfparam name="numtoreturn" default="0">
  <cfparam name="thisTypeID" default="0">
  <cfif val(numtoreturn) eq 0>
          <cfset numtoreturn = 1000 />
        </cfif>
  <!--- query cached data to get actual record --->
  <cfquery name="q" dbtype="query" maxrows="#numtoreturn#">
      SELECT articleID,urlslug,mainimage,mainthumbnail,author,featureimage, featurethumbnail,articletypeID, headline, subhead,articlesummary, frontlinesthumbnail, smallportrait,displayorder, externalURL
      FROM qCached
      WHERE articletypeid in (#thisTypeID#)
      ORDER BY articletypeid desc, displayorder
    </cfquery>
  <cfreturn q />
</cffunction>
      <cffunction name="getCaptcha" returntype="string">
  <!--- get the cached data --->
  <cfset var thisword = "" />
  <!--- query cached data to get actual record --->
  <cfquery name="q" datasource="#application.dsn#" >
      SELECT     TOP (1) word
FROM         captcha
ORDER BY NEWID()
    </cfquery>
  <cfset thisword = q.word />
  <cfreturn thisword />
</cffunction>
      <!--- ***** GET EKTRON CONTENT **** --->
      <cffunction name="getEktronData" returntype="query">
  <!--- this will return ektron queries to the caller.  If neither is found then the result will be empty --->
  <cfargument name="thiscontent_id" required="true" />
  <!--- get the cached data --->
  <cfset var q = "" />
  <!--- query the data to see if it is an article or video--->
  <cfquery name="q" datasource="#application.cmsdsn#" >
SELECT     content_id, headline, author, articledate, subhead, publication, contributor, mainimage, mainimagealt, largethumbnail, largethumbnailalt, smallthumbnail, smallthumbnailalt, featureimage, featureimagealt, folderID, content_status, articlesummary, articlecutline, hero, articlecopy, articlelive, galleryonly
FROM         cms_articles
WHERE     content_id = <cfqueryPARAM value = "#val(thiscontent_id)#" CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
  <cfif q.recordcount neq 0>
          <!--- Add the content type to the query to be returned --->
          <cfset contentType = ArrayNew(1)>
          <cfset contentType[1] = "article">
          <cfset nColumnNumber = QueryAddColumn(q, "contenttype", "VarChar", contentType ) />
          <!--- check for video --->
          <cfelse>
          <cfquery name="q" datasource="#application.cmsdsn#" >
SELECT     cms_videos.Live, cms_videos.swfplayerID, cms_multimedia.mediaShortDescription, cms_multimedia.mediaCopy, cms_multimedia.length, 
                      cms_videos.mediadescription, cms_flashplayers.height, cms_flashplayers.width, cms_flashplayers.windowheight, cms_flashplayers.windowwidth, 
                      cms_videos.StreamFileHq, cms_videos.ExternalURL
FROM         cms_multimedia INNER JOIN
                      cms_videos ON cms_multimedia.content_id = cms_videos.content_id INNER JOIN
                      cms_flashplayers ON cms_videos.swfplayerID = cms_flashplayers.swfplayerID
WHERE     cms_multimedia.content_id = <cfqueryPARAM value = "#val(thiscontent_id)#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
          <cfif q.recordcount neq 0>
      <!--- Add the content type to the query to be returned --->
      <cfset contentType = ArrayNew(1)>
      <cfset contentType[1] = "video">
      <cfset nColumnNumber = QueryAddColumn(q, "contenttype", "VarChar", contentType ) />
      <!--- check for podcast--->
      <cfelse>
       <cfquery name="q" datasource="#application.cmsdsn#" >
      SELECT     cms_podcasts.content_id, cms_podcasts.InternalURL, cms_podcasts.InternalURLtext, cms_podcasts.ExternalURL, cms_podcasts.live, 
                      cms_multimedia.mediaShortDescription, cms_multimedia.mediaCopy
      FROM         cms_podcasts INNER JOIN
                      cms_multimedia ON cms_podcasts.content_id = cms_multimedia.content_id
      WHERE     cms_multimedia.content_id = <cfqueryPARAM value = "#val(thiscontent_id)#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
          <cfif q.recordcount neq 0>
      <!--- Add the content type to the query to be returned --->
      <cfset contentType = ArrayNew(1)>
      <cfset contentType[1] = "podcast">
      <cfset nColumnNumber = QueryAddColumn(q, "contenttype", "VarChar", contentType ) />
      <cfelse>
      
      <!--- Ektron ID is bad send back empty query with error content type --->
      <!--- Add the content type to the query to be returned --->
           
      <cfset contentType = ArrayNew(1)>
      <cfset contentType[1] = "error">
      <cfset nColumnNumber = QueryAddColumn(q, "contenttype", "VarChar", contentType ) />
    </cfif>
    </cfif>
        </cfif>
  <cfreturn q />
</cffunction>
</cfcomponent>
