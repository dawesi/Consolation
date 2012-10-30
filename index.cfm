<!--- 
Created By: Matt Chupp
Created On:	5/19/2010
Description: ND Business Magazine Home Page
 --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Notre Dame Business Magazine</title>
<link rel="stylesheet" type="text/css" href="/styles/style-min.css" />
<cfparam name="attributes.errortype" default="0">
<!--- set issue --->
<cfinclude template="/includes/bizmag/setissue.cfm" />
<cfif val(attributes.allow)>
<cfset variables.urlAccess = "&allow=1" />
<cfset session.urlAccess = "&allow=1" />
<cfelse>
<cfset variables.urlAccess = "" />
</cfif>
<!--- get articles --->
<cfobject component="bizmag_cfcs.bizmagarticles" name="articlesObject">
<!-- Display email address --->
<cfset articlequery = #articlesObject.getIssueArticles(val(attributes.issueID))# />
</head>
<body>
<!--- slot queries --->
<cfset forefrontslotquery = #articlesObject.getallArticleType(attributes.issueID,5,3)#>
<cfset frontrowslotquery = #articlesObject.getallArticleType(attributes.issueID,4,1)#>
<cfset takingstockslotquery = #articlesObject.getallArticleType(attributes.issueID,3,2)#>
<cfset askmoreslotquery = #articlesObject.getallArticleType(attributes.issueID,6,1)#>
<cfset classnotesslotquery = #articlesObject.getIssueClassNotes(val(attributes.issueID),5)#>
<cfset webexclusivesslotquery = #articlesObject.getallArticleType(attributes.issueID,7,5)#>
<div id="container">
  <cfif val(attributes.errortype) neq 0>
    <cfif val(attributes.errortype) eq 1>
      <cfwindow 
	center="true" 
	closable="true" 
	draggable="false"
    modal="true"		 
	height="180" 
	name="emailWindow"
	resizable="false"
	title="An error has occured"
	width="460"
    initshow="true"
> <cfoutput>
        <p align="center" style="margin-bottom:30px">The issue you are looking for does not exist. If you believe you have reached this page in error please contact <a href="mailto:bcook1@nd.edu?subject=Online Magazine Issue Not Found">bcook1@nd.edu</a>.<br />
          You have been redirected to the current issue.</p>
        <div align="center">
          <form>
            <input type="button" value="Close" onClick="ColdFusion.Window.hide('emailWindow')">
          </form>
        </div>
      </cfoutput> </cfwindow>
      <!---end Cfwindow --->
    </cfif>
  </cfif>
  <cfinclude template="/includes/bizmag/header.cfm" />
  <!--banner start here -->
  <cfset rotatorquery = #articlesObject.getrotatorArticles(attributes.issueID)#>
  <div id="banner">
    <div id="featured" >
      <ul class="ui-tabs-nav" id="featurelist">
        <cfoutput>
          <cfloop query="rotatorquery">
            <li class="ui-tabs-nav-item <cfif rotatorquery.currentrow eq 1>ui-tabs-selected</cfif>" id="nav-fragment-#rotatorquery.currentRow#"><a href="##fragment-#rotatorquery.currentRow#"><img src="<cfif rotatorquery.featurethumbnail neq ''>#rotatorquery.featurethumbnail#<cfelse>/userfiles/images/articles/featurethumbnail/sorin_161x56.jpg</cfif>" alt="" />
              <!--- hidden code in case you want to use subtitles for thumbnails --->
              <!--- <span>15+ Excellent High Speed Photographs</span>  --->
              </a></li>
          </cfloop>
        </cfoutput>
      </ul>
      <!-- First Content -->
      <cfoutput>
        <cfloop query="rotatorquery">
          <div id="fragment-#rotatorquery.currentrow#" class="ui-tabs-panel <cfif rotatorquery.currentrow neq 1>ui-tabs-hide</cfif>" style=""> <a href="/article/#rotatorquery.articleID#/#rotatorquery.urlslug#/#variables.urlAccess#"><img src="<cfif rotatorquery.featureimage neq ''>#rotatorquery.featureimage#<cfelse>/userfiles/images/articles/featureimage/sorin_812x251.jpg</cfif>" alt="" /></a>
            <!---hidden code in case you want to use an overlay for featured images --->
            <!--- <div class="info" >
				<h2><a href="##" >#rotatorquery.headline#</a></h2>
				<p>#rotatorquery.subhead#....<a href="##" >read more</a></p>
			 </div>  --->
          </div>
        </cfloop>
      </cfoutput> </div>
    <div id="banner-right">&nbsp;
      <!--- <ul>
        <li><a href="#"><img src="images/aff.jpg" alt="" border="0" /></a></li>
        <li><a href="#"><img src="images/teee.jpg" alt="" border="0" /></a></li>
        <li><a href="#"><img src="images/in.jpg" alt="" border="0" /></a></li>
      </ul> --->
    </div>
  </div>
  <!--banner ends here-->
  <!--content area start here-->
  <div id="content">
    <div id="content-left">
      <cfif frontlinesquery.recordcount neq 0>
        <h2 class="heading-1"><a href="/front_lines/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">FRONT LINES</a></h2>
        <div id="beige-box">
          <div id="beige-bottom">
            <div id="beige-top"> <cfoutput><a href="/article/#frontlinesquery.articleID#/#frontlinesquery.urlslug#/#variables.urlAccess#"><img class="stayer" src="#frontlinesquery.frontlinesthumbnail#" alt="" /></a><span class="look">#frontlinesquery.headline#</span>
                <cfif trim(frontlinesquery.articlesummary) neq ''>#frontlinesquery.articlesummary#</cfif>
                <span class="full-2"><a href="/article/#frontlinesquery.articleID#/#frontlinesquery.urlslug#/#variables.urlAccess#"> FULL STORY</a></span> </cfoutput> </div>
          </div>
        </div>
      </cfif>
      <div id="frontrow">
        <ul>
          <cfoutput>
            <cfloop query="frontrowslotquery">
              <li>
                <h2 class="heading-1"><a href="/front_row/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">FRONTROW</a></h2>
                <a href="/article/#frontrowslotquery.articleID#/#frontrowslotquery.urlslug#/#variables.urlAccess#"><img class="ipo" src="<cfif frontrowslotquery.mainthumbnail eq ''>/userfiles/images/articles/mainthumbnail/sorin_190x80.jpg<cfelse>#frontrowslotquery.mainthumbnail#</cfif>" alt="" /></a> <span class="bluelistingtitle"><a href="/article/#frontrowslotquery.articleID#/#frontrowslotquery.urlslug#/#variables.urlAccess#">#frontrowslotquery.headline#</a></span> <span class="date">#frontrowslotquery.author#</span> #frontrowslotquery.articlesummary# <span class="more"><a href="/article/#frontrowslotquery.articleID#/#frontrowslotquery.urlslug#/#variables.urlAccess#"> FULL STORY</a></span> </li>
            </cfloop>
          </cfoutput> <cfoutput>
            <cfloop query="forefrontslotquery">
              <li>
                <cfif forefrontslotquery.currentrow eq 1>
                  <h2 class="heading-1"><a href="/fore_front/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">FOREFRONT</a></h2>
                </cfif>
                <a href="/article/#forefrontslotquery.articleID#/#forefrontslotquery.urlslug#/#variables.urlAccess#"><img class="lightblueframe" src="<cfif forefrontslotquery.mainthumbnail eq ''>/userfiles/images/articles/mainthumbnail/sorin_190x80.jpg<cfelse>#forefrontslotquery.mainthumbnail#</cfif>" alt="" /></a>
                <div class="bluelistingtitle"><a href="/article/#forefrontslotquery.articleID#/#forefrontslotquery.urlslug#/#variables.urlAccess#">#forefrontslotquery.headline#</a></div>
              </li>
            </cfloop>
          </cfoutput>
        </ul>
      </div>
    </div>
    <!--content left ends here -->
    <div id="content-middle">
      <ul>
        <cfoutput>
          <cfloop query="takingstockslotquery">
            <li>
              <cfif takingstockslotquery.currentrow eq 1>
                <h3 class="heading"><a href="/taking_stock/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">TAKING STOCK</a></h3>
              </cfif>
              <cfif takingstockslotquery.mainimage neq ''><div class="cloud"><a href="/article/#takingstockslotquery.articleID#/#takingstockslotquery.urlslug#/#variables.urlAccess#"><img class="frame-3" src="#takingstockslotquery.mainimage#" alt="" /></a></div></cfif>
              <span class="some">#takingstockslotquery.headline#</span> <span class="essay">#takingstockslotquery.author#</span> #takingstockslotquery.articlesummary# <span class="full4"><a href="/article/#takingstockslotquery.articleID#/#takingstockslotquery.urlslug#/#variables.urlAccess#"> FULL STORY</a></span> </li>
          </cfloop>
        </cfoutput> <cfoutput>
          <cfloop query="askmoreslotquery">
            <li class="bcg-3">
              <cfif askmoreslotquery.currentrow eq 1>
                <h3 class="heading-2"><a href="/article/#askmorequery.articleID#/#askmorequery.urlslug#/#variables.urlAccess#">ASK MORE OF BUSINESS</a></h3>
              </cfif>
              <cfif askmoreslotquery.mainimage neq ''><div class="cloud"><a href="/article/#askmorequery.articleID#/#askmorequery.urlslug#/#variables.urlAccess#"><img class="frame-3" src="#askmoreslotquery.mainimage#" alt="" /></a></div></cfif>
              <span class="some">#askmoreslotquery.headline#</span> <span class="essay">#askmoreslotquery.author#</span> #askmoreslotquery.articlesummary# <span class="full4"><a href="/article/#askmoreslotquery.articleID#/#askmoreslotquery.urlslug#/#variables.urlAccess#"> FULL STORY</a></span> </li>
          </cfloop>
        </cfoutput>
      </ul>
    </div>
    <!--content middle ends here-->
    <div id="content-right">
      <div id="content-right-top">
        <cfinclude template="/includes/bizmag/sidebarnav.cfm" />
      </div>
      <cfif webexclusivesslotquery.recordcount neq 0>
        <div id="round-box" >
          <div id="round-bottom">
            <div id="round-top">
              <ul>
                <cfoutput>
                  <cfloop query="webexclusivesslotquery">
                    <li><a href="<cfif webexclusivesslotquery.externalurl eq ''>/article/#webexclusivesslotquery.articleID#/#webexclusivesslotquery.urlslug#/#variables.urlAccess#<cfelse>#webexclusivesslotquery.externalurl#</cfif>"> <img src="<cfif webexclusivesslotquery.smallportrait eq ''>/userfiles/images/articles/smallportrait/sorin_47x47.jpg<cfelse>#webexclusivesslotquery.smallportrait#</cfif>" alt="" width="47" height="47" align="left" class="popcorn" /> <div>#webexclusivesslotquery.headline# <span class="orangelink" style="display:inline"><cfif trim(webexclusivesslotquery.externalurl) eq ''>FULL STORY<cfelse>CLICK HERE</cfif></span></div></a></li>
                  </cfloop>
                </cfoutput>
              </ul>
            </div>
          </div>
        </div>
      </cfif>
      <cfif classnotesslotquery.recordcount neq 0>
        <cfset varaibles.lastClassYear = listlast(ValueList(classnotesslotquery.classyear))>
        <h3 class="heading-3"><a href="/class_notes/alumni_news/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">CLASS NOTES</a></h3>
        <div id="right-bottom">
        <cfset varaibles.thisclassyear =0 >
        <cfoutput>
          <cfloop query="classnotesslotquery">
            <cfif classnotesslotquery.classyear neq varaibles.thisclassyear>
              <cfif classnotesslotquery.currentrow neq 1>
                </ul>
              </cfif>
              <cfset varaibles.thisclassyear = classnotesslotquery.classyear />
              <ul class="grayboxlist" style="background:url(#classnotesslotquery.backgroundimage#) 132px top no-repeat;<cfif classnotesslotquery.classyear eq varaibles.lastClassYear>border-bottom:none</cfif> ">
            </cfif>
            <!--- get template for this class note --->
            <cfset variables.thispagetemplate= #articlesObject.getNotesPage(val(classnotesslotquery.classnotesID))#>
            <cfif variables.thispagetemplate eq ''>
              <cfset variables.thispagetemplate= "/class_notes/alumni_news/" >
            </cfif>
            <li><a href="#variables.thispagetemplate#?issueid=#attributes.issueID#&anchor=news#classnotesslotquery.currentrow##variables.urlAccess#" target="_top"><img class="popcorn" src="<cfif classnotesslotquery.portrait neq ''>#classnotesslotquery.portrait#<cfelse>/userfiles/images/class_notes/portrait/default_avatar_73x73_male.gif</cfif>" alt="" align="left" /></a><a href="#variables.thispagetemplate#?issueid=#attributes.issueID#&anchor=news#classnotesslotquery.currentrow##variables.urlAccess#" target="_top"><span class="name">#classnotesslotquery.firstname#
              <cfif classnotesslotquery.middlename neq ''>
                #classnotesslotquery.middlename#
              </cfif>
              #classnotesslotquery.lastname#</span><span class="qual">(#classnotesslotquery.degreedetail#)</span></a></li>
          </cfloop>
          </ul>
          <span class="more-2"><a href="/class_notes/alumni_news/?issueID=#attributes.issueID##variables.urlAccess#"> MORE ALUMNI NEWS</a></span>
          </div>
        </cfoutput>
      </cfif>
    </div>
  </div>
  <!--content area ends here-->
  <!--footer start here-->
  <cfinclude template="/includes/bizmag/footer.cfm" />
  <!--footer ends here-->
</div>
<script type="text/javascript" src="/js/scripts.js" ></script>

<script>
	$(document).ready(function(){
	$('#round-top').click(function() {
  window.location = "/web_exclusives/?issueID=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>";
});
$('#round-top').hover(function() {
 $(this).css('cursor','pointer');
 }, function() {
 $(this).css('cursor','auto');
});
	$('#featurelist').click(function() {
  window.location = "/feature_articles/?issueID=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>";
});
$('#featurelist').hover(function() {
 $(this).css('cursor','pointer');
 }, function() {
 $(this).css('cursor','auto');
});
	/*$("#testZone").slideBox({width: "100%", height: "285px", position: "top"});*/
	optionHeight = $("#testZone").height() - 640;
    $("#testZone").slideBox({width: "100%", height: "320px", position: "top"});
	 $("#featured").tabs({fx:{opacity: "toggle"}}).tabs("rotate", 8000, true);  
 $("#featured").hover(  
 function() {  
 $("#featured").tabs("rotate",0,true);  
 },  
 function() {  
 $("#featured").tabs("rotate",8000,true);  
 }  
 );  
	});
	</script>
<cfinclude template="/includes/bizmag/analytics.cfm" />
</body>
</html>
