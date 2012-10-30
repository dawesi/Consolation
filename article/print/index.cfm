<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Notre Dame Business Magazine</title>
<link rel="stylesheet" type="text/css" href="/styles/style-min.css" />
<cfparam name="attributes.ID" default="0">
<cfparam name="attributes.main" default="0">
<cfif val(attributes.main) eq 0>
  <cfset attributes.main = val(attributes.ID) />
</cfif>
<!--- <cfparam name="attributes.page" default="1"> --->
<cfset attributes.articleID = val(attributes.ID)>
<cfinclude template="/includes/bizmag/setissue.cfm" />
<!--- get articles --->
<cfobject component="bizmag_cfcs.bizmagarticles" name="articlesObject">
<!--- make page object queries --->
<cfset variables.articlequery = #articlesObject.getIssueArticles(attributes.issueID)# />
<!---JUST CHANGED FROM MAIN and now the left nav is goofed up --->
<cfset getthisarticle = #articlesObject.getEntireArticle(attributes.articleID)# />
</head>
<body onload="print()"><cfinclude template="/includes/bizmag/analytics.cfm" />

<div id="container">
<!---   <cfinclude template="/includes/bizmag/header.cfm" /> --->
  <!--content area start here-->
  <div id="content-2" >
    <!--content middle start here-->
    <!--- <div id="content-middle-2"> --->
    <cfif val(attributes.id) eq 0>
      <p style="font-size:16px"><strong>The article you are looking for is not in our system.</strong></p>
      <p style="margin-top:15px" align="center">&nbsp;
      <cfelse>
      <div id="front" class="print"> <cfoutput>
          <h3 class="heading">#getthisarticle.articletype#</h3>
          <span class="headline">#getthisarticle.headline#</span>
          <div class="cloud"><img class="frame-3" src="<cfif getthisarticle.mainimage neq "">#getthisarticle.mainimage#<cfelse>/userfiles/images/articles/mainimage/sorin_385x133.jpg</cfif>" alt="" /></div>
          <cfloop query="getthisarticle">#getthisarticle.pagecopy#</cfloop><cfif getthisarticle.signoff neq "">#getthisarticle.signoff#</cfif></cfoutput> </div>
    </cfif>
 <!---  </div> --->
  <!--content middle ends here -->
</div>
<!--content area ends here-->
</div>
</body>
</html>

