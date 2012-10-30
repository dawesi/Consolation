<!--- 
Created By: Matt Chupp
Created On:	5/19/2010
Description: ND Business Magazine Page Functions
 --->
<cfcomponent>
      <cffunction name="getPageArticles"
               returntype="query"
               hint="Get a complete article records for this page">
  <cfargument name="thisIssueid" required="true" type="numeric" />
  <cfargument name="thisTypeID" required="true" type="numeric" />
  <!--- Get user email --->
  <cfquery name="gettypearticles" datasource="#application.dsn#">
SELECT     bizmag_issues.issueID, bizmag_issues.issuename, bizmag_articles.displayorder, bizmag_articles.headline, bizmag_articles.articleID, bizmag_articles.urlslug, bizmag_articles.articletypeID,bizmag_articles.subhead,
                       bizmag_articles.articledate, bizmag_articles.issueID AS Expr1, bizmag_articles.author, bizmag_articles.mainimage, bizmag_articles.mainthumbnail, 
                      bizmag_articles.articlesummary, bizmag_articles.articlecutline, bizmag_articles.submitdate, bizmag_articles.cutline, bizmag_articles.externalURL, 
                      bizmag_articles.smallportrait, bizmag_articles.live, bizmag_articletype.articleType
FROM         bizmag_issues INNER JOIN
                      bizmag_articles ON bizmag_issues.issueID = bizmag_articles.issueID INNER JOIN
                      bizmag_articletype ON bizmag_articles.articletypeID = bizmag_articletype.articleTypeID
WHERE     (bizmag_issues.issueID = <cfqueryPARAM value = "#ARGUMENTS.thisissueID#" CFSQLType = "CF_SQL_INTEGER">) AND (bizmag_articles.live = 1) AND (bizmag_articles.articletypeID = #thisTypeID#)
ORDER BY bizmag_articles.displayorder
      </cfquery>
  <cfreturn gettypearticles>
</cffunction>
      <!--- get tab for class notes pages --->
      <cffunction name="getClassNotesTabs"
               returntype="query"
               hint="Get tabs for Class Notes pages">
  <cfargument name="thisIssueid" required="true" type="numeric" />
  <cfargument name="thisTypeID" required="true" type="numeric" />
  <!--- Get user email --->
  <cfquery name="getNotestabs" datasource="#application.dsn#">
SELECT     bizmag_articles.headline, bizmag_articles.articleID, bizmag_articles.urlslug, bizmag_articles.articledate, bizmag_articles.author, bizmag_articles.mainimage, bizmag_articles.mainthumbnail, 
                      bizmag_articles.articlesummary, bizmag_articles.articlecutline, bizmag_articles.submitdate, bizmag_articles.cutline, bizmag_articles.externalURL, 
                      bizmag_articles.smallportrait, bizmag_articles.live, bizmag_articletype.articleType, bizmag_classnotesassoc.displayorder, bizmag_articles.issueID, 
                      bizmag_classnotesassoc.articletypeID, bizmag_articletype.webpageURL
FROM         bizmag_classnotesassoc INNER JOIN
                      bizmag_articles ON bizmag_classnotesassoc.articleID = bizmag_articles.articleID INNER JOIN
                      bizmag_articletype ON bizmag_classnotesassoc.articletypeID = bizmag_articletype.articleTypeID
WHERE     (bizmag_articles.issueID = <cfqueryPARAM value = "#ARGUMENTS.thisissueID#" CFSQLType = "CF_SQL_INTEGER">) AND (bizmag_articles.live = 1) AND (bizmag_classnotesassoc.articletypeID = #thisTypeID#) and bizmag_articles.externalURL = ''
ORDER BY bizmag_articles.displayorder
      </cfquery>
  <cfreturn getNotestabs>
</cffunction>
      <cffunction name="getClassNotesLinks"
               returntype="query"
               hint="Get links for Class Notes pages">
  <cfargument name="thisIssueid" required="true" type="numeric" />
  <cfargument name="thisTypeID" required="true" type="numeric" />
  <!--- Get user email --->
  <cfquery name="getNoteslinks" datasource="#application.dsn#">
SELECT     bizmag_articles.headline,bizmag_articles.urlslug, bizmag_articles.articleID, bizmag_articles.articledate, bizmag_articles.author, bizmag_articles.mainimage, bizmag_articles.mainthumbnail, 
                      bizmag_articles.articlesummary, bizmag_articles.articlecutline, bizmag_articles.submitdate, bizmag_articles.cutline, bizmag_articles.externalURL, 
                      bizmag_articles.smallportrait, bizmag_articles.live, bizmag_articletype.articleType, bizmag_classnotesassoc.displayorder, bizmag_articles.issueID, 
                      bizmag_classnotesassoc.articletypeID, bizmag_articletype.webpageURL
FROM         bizmag_classnotesassoc INNER JOIN
                      bizmag_articles ON bizmag_classnotesassoc.articleID = bizmag_articles.articleID INNER JOIN
                      bizmag_articletype ON bizmag_classnotesassoc.articletypeID = bizmag_articletype.articleTypeID
WHERE     (bizmag_articles.issueID = <cfqueryPARAM value = "#ARGUMENTS.thisissueID#" CFSQLType = "CF_SQL_INTEGER">) AND (bizmag_articles.live = 1) AND (bizmag_classnotesassoc.articletypeID = #thisTypeID#) and bizmag_articles.externalURL <> ''
ORDER BY bizmag_articles.displayorder
      </cfquery>
  <cfreturn getNoteslinks>
</cffunction>
      <cffunction name="getClassNotesType"
               returntype="query"
               hint="Get a complete article records for this page">
  <cfargument name="thisIssueid" required="true" type="numeric" />
  <cfargument name="thisUpdateTypeID" required="true" type="string"/>
  <cfquery name="gettypearticles" datasource="#application.dsn#">
SELECT     classnotes.classnotesID, classnotes.editedcomments, classnotes.lastname, classnotes.mainimage,classnotes.mainimage,classnotes.lgsquareimage, classnotes.portrait, classnotes.classyear, classnotes.live, 
                      classnotes.firstname, classnotes.issueID, classnotes.middlename, classnotes_assoc.updatetypeID, classnotes.degreedetail
FROM         classnotes INNER JOIN
                      bizmag_issues ON classnotes.issueID = bizmag_issues.issueID INNER JOIN
                      classnotes_assoc ON classnotes.classnotesID = classnotes_assoc.classnotesID
WHERE     (bizmag_issues.issueID = <cfqueryPARAM value = "#ARGUMENTS.thisissueID#" CFSQLType = "CF_SQL_INTEGER">) AND (classnotes.live = 1) AND (classnotes_assoc.updatetypeID IN (#thisUpdateTypeID#))
ORDER BY classnotes.classyear DESC, classnotes.lastname,classnotes.firstname
      </cfquery>
  <cfreturn gettypearticles>
</cffunction>
<cffunction name="getContactPage"
               returntype="query"
               hint="Get a listing of staff for this page">
  <cfquery name="geteditors" datasource="#application.dsn#">
SELECT     content_id, editororder
FROM         bizmag_contactus
ORDER BY editororder
</cfquery>
  <cfquery name="getfromcms" datasource="#application.cmsdsn#">
SELECT     content_id, LastName, FirstName, Phone, Email, Bio, biopagelink, NetID, SecondaryUnit, Title
FROM         cms_faculty
WHERE     (content_id IN (#ValueList(geteditors.content_id,',')#))
</cfquery>
  <cfquery name="getstaff" dbtype="query">
SELECT getfromcms.content_id, getfromcms.LastName, getfromcms.FirstName, getfromcms.Phone, getfromcms.Email, getfromcms.Bio, getfromcms.biopagelink, getfromcms.NetID, getfromcms.SecondaryUnit, getfromcms.Title
FROM 
     getfromcms, geteditors
WHERE
     geteditors.content_ID = getfromcms.content_ID
ORDER BY geteditors.editororder
</cfquery>
  <cfreturn getstaff>
</cffunction>

<cffunction name="getArchives" returntype="query" hint="Get a listing of archived issues">
<cfquery name="getrecords" datasource="#application.dsn#">
SELECT     bizmag_issues.issueID, bizmag_issues.issuedate, bizmag_issues.live, bizmag_issues.issuename, bizmag_issues.pdflink, bizmag_issues.submitdate, 
                      bizmag_issues.pdfimage, bizmag_issues.seasonID, bizmag_issues.archiveimage, bizmag_issues.archivelink, bizmag_issuedates.season
FROM         bizmag_issues INNER JOIN
                      bizmag_issuedates ON bizmag_issues.seasonID = bizmag_issuedates.seasonID
WHERE     (bizmag_issues.live = 1) AND (bizmag_issues.issueID NOT IN
                          (SELECT     TOP (1) issueID
                            FROM          bizmag_issues AS bizmag_issues_2
                            WHERE      (live = 1) OR
                                                   (archivelink <> '')
                            ORDER BY issuedate DESC)) OR
                      (bizmag_issues.archivelink <> '') AND (bizmag_issues.issueID NOT IN
                          (SELECT     TOP (1) issueID
                            FROM          bizmag_issues AS bizmag_issues_1
                            WHERE      (live = 1) OR
                                                   (archivelink <> '')
                            ORDER BY issuedate DESC))
ORDER BY bizmag_issues.issuedate DESC
</cfquery>
<cfreturn getrecords>
</cffunction>
</cfcomponent>
