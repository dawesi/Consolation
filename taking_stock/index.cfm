<!--- 
Created By: Matt Chupp
Created On:	5/19/2010
Description: ND Business Magazine - Taking Stock
 --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Notre Dame Business Magazine - Taking Stock</title>
<link rel="stylesheet" type="text/css" href="/styles/style-min.css" />
<script type="text/javascript" src="/js/jquery-1.4.2.min.js" ></script>
<script src="/js/slidebox.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/jquery-1.8.1.ui.min.js" ></script>
<script>
$(document).ready(function(){
optionHeight = $("#testZone").height() - 640;
$("#testZone").slideBox({width: "100%", height: "320px", position: "top"});
});
</script>
<cfparam name="attributes.issueID" default="0">
<cfset attributes.issueID = val(attributes.issueID)>
<cfinclude template="/includes/bizmag/setissue.cfm" />
<!---Variable for leftnav --->
<cfset variables.thisarticletypeID = 3 />
<!---*** get articles needed for top nav and left nav to work so this must be in every page ***--->
<cfobject component="bizmag_cfcs.bizmagarticles" name="articlesObject">
<!--- make page object queries --->
<cfset variables.articlequery = #articlesObject.getIssueArticles(attributes.issueID)# />
<cfparam name="attributes.main" default="0">
<!---*** end ***--->
<cfobject component="bizmag_cfcs.bizmagpages" name="pageObject">
<!--- make page object queries --->
<cfset variables.pagequery = #pageObject.getPageArticles(attributes.issueID,variables.thisarticletypeID)# />
</head>
<body>
<cfinclude template="/includes/bizmag/analytics.cfm" />
<div id="container">
  <cfinclude template="/includes/bizmag/header.cfm" />
  <!--content area start here-->
  <div id="content-2">
    <!--content left start here -->
    <div id="content-left-2">
      <!--- Left Navigation --->
      <cfinclude template="/includes/bizmag/leftnav.cfm" />
    </div>
    <!--content left ends here-->
    <!--content middle start here-->
    <div id="content-middle-2"> <cfoutput>
        <div id="pagecontent">
          <h3 class="heading">#pagequery.articletype#</h3>
          <cfif pagequery.recordcount neq 0>
            <cfloop query="pagequery">
              <div class="listingwrapper">
                <div class="listing_leftcol"> <a href="<cfif pagequery.externalurl eq ''>/article/#pagequery.articleID#/#pagequery.urlslug#/<cfelse>#pagequery.externalurl#</cfif>"><img alt="" src="<cfif pagequery.mainthumbnail neq "">#pagequery.mainthumbnail#<cfelse>http://webapp.business.nd.edu/userfiles/images/articles/mainthumbnail/sorin_190x80.jpg</cfif>" class="lightblueframe"></a> </div>
                <div class="listing_rightcol">
                  <h4><a href="<cfif pagequery.externalurl eq ''>/article/#pagequery.articleID#/#pagequery.urlslug#/<cfelse>#pagequery.externalurl#</cfif>">#pagequery.headline#</a></h4>
                  <p class="byline">#pagequery.author#</p>
                  <cfif trim(pagequery.subhead) neq ''>
                    <p>#pagequery.subhead#</p>
                  </cfif>
                  <p><a href="<cfif pagequery.externalurl eq ''>/article/#pagequery.articleID#/#pagequery.urlslug#/<cfelse>#pagequery.externalurl#</cfif>">&gt; Full Story</a></p>
                </div>
              </div>
            </cfloop>
            <cfelse>
            <p class="message">There are no articles in this issue for this section.</p>
          </cfif>
        </div>
      </cfoutput> </div>
    <!--content middle ends here -->
    <div id="content-right-2">
      <div id="related">
        <cfinclude template="/includes/bizmag/sidebarnav.cfm" />
      </div>
      <!--- empty list needed for background graphic --->
      <div id="beige-center">
        <ul>
          <li class="bottom empty">&nbsp;</li>
        </ul>
      </div>
    </div>
  </div>
  <!--content area ends here-->
  <!--footer start here-->
  <cfinclude template="/includes/bizmag/footer.cfm" />
  <!--footer ends here-->
</div>
</body>
</html>
