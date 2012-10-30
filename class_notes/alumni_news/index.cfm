<!--- 
Created By: Matt Chupp
Created On:	5/19/2010
Description: ND Business Magazine Alumni News
 --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Notre Dame Business Magazine - Alumni News</title>
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
<cfparam name="attributes.anchor" default="">
<cfset attributes.issueID = val(attributes.issueID)>
<cfinclude template="/includes/bizmag/setissue.cfm" />
<!---Variable for leftnav --->
<cfset variables.thisarticletypeID = 13 />
<!---*** get articles needed for top nav and left nav to work so this must be in every page ***--->
<cfobject component="bizmag_cfcs.bizmagarticles" name="articlesObject">
<!--- make page object queries --->
<cfset variables.articlequery = #articlesObject.getIssueArticles(attributes.issueID)# />
<cfparam name="attributes.main" default="0">
<!---*** end ***--->
<cfobject component="bizmag_cfcs.bizmagpages" name="pageObject">
<!--- make page object queries --->
<cfset variables.thisNoteType = "1,2,3,4,5,7,8,9" >
<cfset pagequery = #pageObject.getClassNotesType(attributes.issueID,variables.thisNoteType)# />
<cfset classnotesslotquery = #articlesObject.getIssueClassNotes(val(attributes.issueID),5)#>
<cfset gettabcontent = #pageObject.getClassNotesTabs(attributes.issueID,variables.thisarticletypeID)# />
<cfset getSidebarLinks = #pageObject.getClassNotesLinks(attributes.issueID,variables.thisarticletypeID)# />
<cfoutput>
<script type="text/javascript">
function goToAnchor() {
location.href = "###attributes.anchor#";
}
</script>
</cfoutput>
</head>
<cfif attributes.anchor eq ''>
<body>
<cfelse>
<body onload="goToAnchor();">
</cfif>
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
          <h3 class="heading">Class Notes</h3>
          <h4>#gettabcontent.articletype#</h4>
          <cfset variables.thisheadervalue = "">
          <cfif pagequery.recordcount neq 0>
            <cfset variables.thisnoteid = 0 />
            <cfloop query="pagequery">
              <!--- check for duplicate records --->
              <cfif variables.thisnoteid neq pagequery.classnotesID>
                <cfset variables.thisnoteid = pagequery.classnotesID>
                <div class="listingwrapper">
                  <cfif variables.thisheadervalue neq pagequery.classyear>
                    <div class="notesHeader">&##8217;#right(pagequery.classyear,2)#</div>
                    <cfset variables.thisheadervalue = pagequery.classyear>
                  </cfif>
                  <cfset varaibles.classNotesSlotIds = ValueList(classnotesslotquery.classnotesID)>
                  <cfif ListFind(varaibles.classNotesSlotIds, pagequery.classnotesID) neq 0>
                    <a name="news#ListFind(varaibles.classNotesSlotIds, pagequery.classnotesID)#" id="news#ListFind(varaibles.classNotesSlotIds, pagequery.classnotesID)#"></a>
                  </cfif>
                  <h5>#pagequery.firstname#
                    <cfif pagequery.middlename eq ''>
                      #pagequery.middlename#
                    </cfif>
                    #pagequery.lastname# (#pagequery.degreedetail#)</h5>
                  <!---handle images--->
                  <cfif pagequery.mainimage neq ''>
                    <div class="cloud"><img class="frame-3" src="#pagequery.mainimage#" alt="" align="left" /></div>
                    <cfelseif pagequery.lgsquareimage neq ''>
                    <img class="lightblueframe" src="#pagequery.lgsquareimage#" alt="" align="left" />                    
                    <cfelseif pagequery.portrait neq ''>
                    <img class="lightblueframe" src="#pagequery.portrait#" alt="" align="left" />
                  </cfif>
                  <!---end images--->
                  #pagequery.editedcomments#</div>
              </cfif>
            </cfloop>
            <cfelse>
            <p class="message">There are no class notes in this issue for this section.</p>
          </cfif>
        </div>
      </cfoutput> </div>
    <!--content middle ends here -->
    <div id="content-right-2">
      <div id="related">
        <cfinclude template="/includes/bizmag/sidebarnav.cfm" />
        <cfif gettabcontent.recordcount neq 0>
          <h3>RELATED CONTENT</h3>
        </cfif>
      </div>
      <!--- empty list needed for background graphic --->
      <div id="beige-center">
        <ul>
          <cfif gettabcontent.recordcount neq 0>
            <li class="first selected">Alumni News</li>
            <cfoutput>
              <cfloop query="gettabcontent">
                <li <cfif gettabcontent.recordcount eq gettabcontent.currentrow>class="last"</cfif>> <a href="/article/#gettabcontent.articleID#/#gettabcontent.urlslug#?classnotes=13">#gettabcontent.headline#</a> </li>
              </cfloop>
            </cfoutput>
            <li class="bottom">&nbsp;</li>
            <cfelse>
            <!--- no related content found --->
            <li class="bottom empty">&nbsp;</li>
          </cfif>
        </ul>
      </div>
      <cfif getSidebarLinks.recordcount neq 0>
        <h3>Related Links</h3>
        <ul class="relatedlinks">
          <cfoutput>
            <cfloop query="getSidebarLinks">
              <li><a href="#getSidebarLinks.externalURL#">#getSidebarLinks.headline#</a></li>
            </cfloop>
          </cfoutput>
        </ul>
      </cfif>
    </div>
  </div>
  <!--content area ends here-->
  <!--footer start here-->
  <cfinclude template="/includes/bizmag/footer.cfm" />
  <!--footer ends here-->
</div>
</body>
</html>