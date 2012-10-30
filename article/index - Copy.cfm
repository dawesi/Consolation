<!--- 
Created By: Matt Chupp
Created On:	5/19/2010
Description: ND Business Magazine Article Display Page
 --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Notre Dame Business Magazine</title>
<link rel="stylesheet" type="text/css" href="/styles/style-min.css" />

<!--- <script type="text/javascript" src="/js/animatedcollapse.js"></script> --->

<!---play video --->
<link rel="stylesheet" type="text/css" href="shadowbox.css">
<!--- end video --->

<cfparam name="attributes.ID" default="0">
<cfparam name="attributes.main" default="0">
<cfparam name="attributes.classnotes" default="0">
<cfif val(attributes.main) eq 0>
  <cfset attributes.main = val(attributes.ID) />
</cfif>
<!--- get classnotes --->
<cfif val(attributes.classnotes) neq 0>
  <cfset attributes.main = val(attributes.ID) />
  <cfset variables.thisarticletypeid = val(attributes.classnotes) />
</cfif>
<cfparam name="attributes.page" default="1">
<cfset attributes.articleID = val(attributes.ID)>
<cfinclude template="/includes/bizmag/setissue.cfm" />
<!---*** get articles needed for top nav so this must be in every page ***--->
<cfobject component="bizmag_cfcs.bizmagpages" name="pageObject">
<cfobject component="bizmag_cfcs.bizmagarticles" name="articlesObject">
<!--- make page object queries --->
<cfset variables.articlequery = #articlesObject.getIssueArticles(attributes.issueID)# />
<!---*** end ***--->
<cfset getthisarticle = #articlesObject.getArticle(attributes.articleID,attributes.page)# />
<cfset articlepagecount = #articlesObject.getpagecount(attributes.articleID)# />
<cfif val(attributes.classnotes) eq 0>
  <cfset gettabcontent = #articlesObject.getRelatedContent(attributes.main)# />
  <cfset getSidebarLinks = #articlesObject.getRelatedLinks(attributes.articleID)# />
  <cfelse>
  <cfset gettabcontent = #pageObject.getClassNotesTabs(attributes.issueID,variables.thisarticletypeID)# />
  <cfset getSidebarLinks = #pageObject.getClassNotesLinks(attributes.issueID,variables.thisarticletypeID)# />
</cfif>
<cfset getarticlecomments = #articlesObject.getcomments(attributes.articleID)# />
<!---Variable for leftnav --->
<cfif val(attributes.classnotes) eq 0>
  <cfset getmain = #articlesObject.getparentarticle(val(attributes.main))# />
  <cfset variables.thisarticletypeID = val(getmain.articletypeID) />
</cfif>
</head>
<body>
<!--- <cfoutput>#CGI.REMOTE_ADDR#</cfoutput> --->
<cfif StructKeyExists(form,"Action-A")>
  <cfparam name="attributes.thisArticleID" default="0">
  <cfparam name="attributes.businessprogram" default="" >
  <cfparam name="attributes.commentname" default="" >
  <cfparam name="attributes.commenttext" default="" >
  <cfparam name="attributes.email" default="" >
  <cfparam name="attributes.gradyear" default="" >
  <!---insert comment --->
  <cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />  
  <cfif Cffp.testSubmission(form)>
       <!--- The submission has passed the form test.  Place processing here --->
<cftry>
<cfset attributes.thiscommentID = #articlesObject.addComment(HTMLEditFormat(attributes.thisArticleID),HTMLEditFormat(attributes.businessprogram),   HTMLEditFormat(attributes.commentname),HTMLEditFormat(attributes.commenttext),HTMLEditFormat(attributes.email),HTMLEditFormat(attributes.gradyear))# />
    <cfif val(attributes.thiscommentID) neq 0>
    <cfmail from="ND BIZ MAG <#application.adminemail#>"
        to="mbolstet@nd.edu"
        bcc="#application.adminemail#"
        server="smtp.nd.edu"
		subject="A comment has been submitted for an article"
		type="html">
      <p>Click <a href="http://webapp.business.nd.edu/admin/bizmag/commentform.cfm?commentID=#attributes.thiscommentID#">here</a> to view and activate the comment</p>
    </cfmail>
    </cfif>
    <cfcatch type="any">
      <cfmail from="ND BIZ MAG <#application.adminemail#>"
        to="#application.adminemail#"
        server="smtp.nd.edu"
		subject="An error has occured trying to submit a comment for article #attributes.ID#"
		type="html">
        <p>Here is the error</p>
        <cfdump var="#cfcatch#">
      </cfmail>
    </cfcatch>
  </cftry>
<cflocation url="/article/?#cgi.query_string###comments" addtoken="no"> 
<cfelse>
       <!--- The test failed.  Take appropriate failure action here. --->
<cflocation url="http://business.nd.edu/"  addtoken="no" />
</cfif> 
  <!--- use for another form on this page....e.g. search --->
  <cfelseif StructKeyExists(form,"Action-B")>
  &nbsp;
</cfif>
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
    <div id="content-middle-2">
    <cfif val(attributes.id) eq 0 or val(attributes.issueid) eq 0 or variables.thisarticletypeID eq 9>
      <p class="message" style="padding-left:5px">The article you are looking for is not in our system.</p>
      <!---  <p style="margin-top:15px" align="center"><img src="http://jc-schools.net/techupdate/index_files/leprechaun-sad1.gif"  /> --->
      <cfelse>
      <div id="front"> <cfoutput>
          <h3 class="heading">
            <cfif getthisarticle.articletypeID neq 10>
              #getthisarticle.articletype#
              <cfelse>
              Related Content
            </cfif>
          </h3>
          <div id="increasetext"> <a href="##" onclick="increaseFontSize();return false;"><img class="inline" src="/images/text_larger.gif" /></a><a onclick="decreaseFontSize();return false;" href="##"><img class="inline" src="/images/text_smaller2.gif" /></a></div>
          <cfif getthisarticle.articletypeID neq 12>
            <span class="headline">#getthisarticle.headline#</span>
          </cfif>
          <cfif trim(getthisarticle.subhead) neq ''>
            <span class="subhead">#getthisarticle.subhead#</span>
          </cfif>
          <cfif getthisarticle.mainimage neq ''>
            <div class="cloud"><img class="frame-3" src="#getthisarticle.mainimage#" alt="" /></div>
          </cfif>
          <cfif trim(getthisarticle.cutline) neq ''>
            <span class="cutline">#trim(getthisarticle.cutline)#</span>
            <cfelse>
            <!---add space between article and beginning of text --->
            <p style="margin:0; padding:0">&nbsp;</p>
          </cfif>
          <!--- check to see if video if so then add play video link --->
          <cfif val(getthisarticle.content_id) neq 0>
            <cfset getEktronInfo = #articlesObject.getEktronData(getthisarticle.content_id)# />
            <cfif getEktronInfo.contenttype eq 'video'>
              <p class="bluesubhead" style="text-align: center"><a class="player" rel="shadowbox; height=#getEktronInfo.windowheight#; width=#getEktronInfo.windowwidth#;" href="http://business.nd.edu/videoplayer/videoplayer.aspx?ID=#getthisarticle.content_id#">PLAY VIDEO</a></p>
              <cfif trim(getthisarticle.pagecopy) eq ''>
                <p>#getEktronInfo.mediacopy#</p>
              </cfif>
              <cfelseif getEktronInfo.contenttype eq 'article'>
                        #getEktronInfo.articlecopy#
              <cfelseif getEktronInfo.contenttype eq 'podcast'>
<!--- determine the URL --->
                        <cfset variables.thisURL = ''>
                        <cfif trim(getEktronInfo.internalURL) neq '' >
                        <cfset variables.thisURL = "http://business.nd.edu" & trim(getEktronInfo.internalURL) >
                        
                        <cfelse>
                        <cfset variables.thisURL = trim(getEktronInfo.externalURL) >
                        </cfif>
 <cfif variables.thisURL neq ''>
                        <!--- embed the flash controls --->
                        <cfinclude template="/includes/bizmag/flashheader.cfm" />
       <div style="padding:0; margin:-15px 0 0 0">&nbsp;</div>
        <script language="JavaScript" type="text/javascript">
<!--
if (AC_FL_RunContent == 0 || DetectFlashVer == 0) {
	alert("This page requires AC_RunActiveContent.js.");
} else {
	var hasRightVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);
	if(hasRightVersion) {  // if we've detected an acceptable version
		// embed the flash movie
		AC_FL_RunContent(
			'codebase', 'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=8,0,24,0',
			'width', '197',
			'height', '15',
			'src', 'mp3Play',
			'quality', 'high',
			'pluginspage', 'http://www.macromedia.com/go/getflashplayer',
			'align', 'middle',
			'play', 'true',
			'loop', 'false',
			'scale', 'noscale',
			'wmode', 'window',
			'devicefont', 'false',
			'id', 'mp3Play',
			'bgcolor', '##ffffff',
			'name', '/mp3Play',
			'menu', 'false',
			'allowScriptAccess','sameDomain',
			'allowFullScreen','false',
			'movie', '/mp3Play',
			'FlashVars', '&soundFile=#variables.thisURL#',
			'salign', ''
			); //end AC code
	} else {  // flash is too old or we can't detect the plugin
		var alternateContent = 'This content requires the Adobe Flash Player.'
			+ '<a href=http://www.macromedia.com/go/getflash/>Get Flash</a>';
		document.write(alternateContent);  // insert non-flash content
	}
}
// -->
</script><span style="font-size: 12px;height: 15px;line-height: 15px;margin-left: 10px;vertical-align: bottom;"><a target="_blank" href="#variables.thisURL#">Download MP3</a></span>
        <noscript>
This site's content is best viewed with Flash        <br />
        <a href="http://www.macromedia.com/go/getflash/">Get Flash</a>
        </noscript>
        <p style="margin:0; padding:0">&nbsp;</p>
        <cfif trim(getthisarticle.pagecopy) eq ''>
                <p>#getEktronInfo.mediacopy#</p>
              </cfif>
        </cfif>
              <cfelse>
              <!--- must have returned an error --->
            </cfif>
            <!--- contenttype = video --->
          </cfif>
          <!--- end ---> 
          #getthisarticle.pagecopy#
          <cfif val(articlepagecount.recordcount) eq val(attributes.page) >
            #getthisarticle.signoff#
          </cfif>
        </cfoutput> </div>
      <cfoutput>
        <cfif articlepagecount.recordcount neq 1 OR articlepagecount.recordcount neq attributes.page>
          <div class="continue">
            <cfif articlepagecount.recordcount neq attributes.page>
              <span class="blue">CONTINUED: </span><span class="upper" style="text-transform:uppercase">#getthisarticle.headline#</span>
            </cfif>
          </div>
          <span id="next"> 
          <!--- handle pagination ---> 
          <!--- previous --->
          <cfif val(attributes.page) gt 1>
            <cfset variables.previouspage = attributes.page - 1>
            <a href="/article/#attributes.ID#/#getthisarticle.urlslug#/?page=#variables.previouspage#<cfif attributes.main neq attributes.ID>?main=#val(attributes.main)#</cfif>">&lt; Previous&nbsp;&nbsp;</a>
          </cfif>
          <cfloop query="articlepagecount">
            <!--- check to see if this is current page --->
            <cfif val(articlepagecount.currentrow) eq val(attributes.page)>
              <span class="currentpage" style="font-weight:bold; color:##333333">#articlepagecount.currentrow#&nbsp;&nbsp;</span>
              <cfelse>
              <a href="/article/#attributes.ID#/#getthisarticle.urlslug#/?page=#articlepagecount.currentrow#<cfif attributes.main neq attributes.ID>&main=#val(attributes.main)#</cfif>">#articlepagecount.currentrow#</a>&nbsp;&nbsp;
            </cfif>
          </cfloop>
          <cfif articlepagecount.recordcount neq attributes.page and articlepagecount.recordcount neq 0>
            <cfset variables.nextpage = attributes.page + 1>
            <a href="/article/#attributes.ID#/#getthisarticle.urlslug#/?page=#variables.nextpage#<cfif attributes.main neq attributes.ID>&main=#val(attributes.main)#</cfif>">Next &gt;</a>
          </cfif>
          </span>
        </cfif>
      </cfoutput>
      <div id="mail">
        <ul>
          <li class="letter"><a href="#" onClick="ColdFusion.Window.show('emailWindow');return false;">EMAIL</a></li>
          <li class="print"><a href="/article/print/index.cfm?id=<cfoutput>#attributes.articleid#</cfoutput>" target="_blank">PRINT</a></li>
          <li style="width:120px"><!-- AddThis Button BEGIN -->
 <div class="addthis_toolbox addthis_default_style "> <span style="float:left">Share</span> <span class="addthis_separator">|</span> <a class="addthis_button_facebook"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_linkedin"></a></div>
          <script type="text/javascript">var addthis_config = {"data_track_clickback":true};</script> 
          <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=mchupp"></script> 
<!-- AddThis Button END -->
</li>
          <!---    <li class="discuss"><a href="#">DISCUSS</a> --->
        </ul>
        </ul>
      </div>
      <!--- comments section --->
      <h3 class="heading-4"><a name="comments" id="comments"></a>COMMENTS</h3>
      <cfoutput>
        <cfloop query="getarticlecomments">
          <cfif getarticlecomments.currentrow mod 2>
            <div class="point">
            <cfelse>
            <div class="point-2">
          </cfif>
          <span class="cook">By #getarticlecomments.commentname#
          <cfif trim(getarticlecomments.businessprogram) neq '' or trim(getarticlecomments.gradyear) neq ''>
            |
            <cfif trim(getarticlecomments.businessprogram) neq ''>
              #getarticlecomments.businessprogram#
            </cfif>
          </cfif>
          #getarticlecomments.gradyear#</span> <span class="date-2">#dateformat(getarticlecomments.submitdate, "long")# #timeformat(getarticlecomments.submitdate, "hh:mm tt")#</span>
          <p>#getarticlecomments.commenttext#</p>
          </div>
        </cfloop>
      </cfoutput>
      <h3 class="heading-4">Submit A Comment</h3>
      <div id="submission">
        <cfform name="commentform">
         <cfinclude template="/cfformprotect/cffp.cfm">  
          <input type="hidden" name="thisArticleID" value="<cfoutput>#val(attributes.ID)#</cfoutput>"  />
          <ul>
            <li>
              <label class="required" for="Name">Name (required):</label>
              <cfinput class="inp-2" name="commentname" type="text" id="Name" required="yes" message="You must enter your name"/>
            </li>
            <li>
              <label class="required" for="mail2">E-mail:</label>
              <cfinput class="inp-2" name="email" type="text" id="mail2" validate="email"  message="You must enter a valid e-mail address."/>
            </li>
            <li>
              <label class="required" for="program">Notre Dame Business Program:</label>
              <input class="inp-2" type="text" id="program" name="businessprogram"  />
            </li>
            <li>
              <label class="required" for="year">Year of Graduation:</label>
              <input class="inp-2" type="text" id="year" name="gradyear" />
            </li>
            <li>
              <label class="comment" for="comment">Comment</label>
              <textarea class="inp-3" rows="" cols="" style="width:375px" name="commenttext"></textarea>
            </li>
          </ul>
          <p align="center">
            <button type="submit" class="link" name="Action-A" value="A"><span>Submit Comment</span></button>
          </p>
        </cfform>
      </div>
    </cfif>
  </div>
  <!--content middle ends here -->
  <div id="content-right-2">
    <div id="related">
      <cfinclude template="/includes/bizmag/sidebarnav.cfm" />
      <cfif gettabcontent.recordcount neq 0>
        <h3>RELATED CONTENT</h3>
      </cfif>
    </div>
    <div id="beige-center">
      <ul>
        <!--- first item in sidebar list--->
        <cfif gettabcontent.recordcount neq 0>
          <cfif val(attributes.classnotes) eq 0>
            <cfoutput query="getmain">
              <cfif attributes.main eq attributes.articleID>
                <li class="first selected" >
                  <cfelse>
                <li class="first">
              </cfif>
              <!--- <a href="/article/#attributes.ID#/#getthisarticle.urlslug#/">#getmain.headline#</a> --->
                <a href="/article/#getmain.articleID#/#getmain.urlslug#/">#getmain.headline#</a>
              </li>
            </cfoutput>
            <cfelse>
            <!---           Handle class notes ---> 
            <cfoutput>
              <li class="first" > <a href="#gettabcontent.webpageURL#?issueid=#attributes.issueID#">#gettabcontent.articletype#</a> </li>
            </cfoutput>
          </cfif>
        </cfif>
        <cfif gettabcontent.recordcount neq 0>
          <cfoutput>
            <cfif val(attributes.classnotes) eq 0>
              <cfloop query="gettabcontent">
                <cfif gettabcontent.subarticleID eq attributes.articleID>
                  <li class="selected <cfif gettabcontent.recordcount eq gettabcontent.currentrow>last</cfif>">
                    <cfelse>
                  <li <cfif gettabcontent.recordcount eq gettabcontent.currentrow>class="last"</cfif>>
                </cfif>
                <a href="/article/#gettabcontent.subarticleID#/#gettabcontent.urlslug#/?main=#getmain.articleID#">#gettabcontent.headline#</a>
                </li>
              </cfloop>
              <cfelse>
              <!--- comes from a class notes page --->
              <cfloop query="gettabcontent">
                <cfif gettabcontent.articleID eq attributes.articleID>
                  <li class="selected <cfif gettabcontent.recordcount eq gettabcontent.currentrow>last</cfif>">
                    <cfelse>
                  <li <cfif gettabcontent.recordcount eq gettabcontent.currentrow>class="last"</cfif>>
                </cfif>
                <a href="/article/#gettabcontent.articleID#/#gettabcontent.urlslug#/?classnotes=#val(attributes.classnotes)#">#gettabcontent.headline#</a>
                </li>
              </cfloop>
            </cfif>
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
            <li> <a href="#getSidebarLinks.externalURL#">#getSidebarLinks.headline#</a></li>
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
<cfwindow 
	center="true" 
	closable="true" 
	draggable="false"
    modal="true"		 
	height="460" 
	name="emailWindow"
	resizable="false"
	title="Email this article"
	width="460"
    

> <cfoutput>
    <h3 class="heading-4">Email this Article</h3>
    <div id="submission">
      <cfform name="emailcommentform" action="/article/act_email.cfm" method="post" onsubmit = "javascript:ColdFusion.window.hide('emailWindow')">
        <input type="hidden" name="thisArticleID" value="<cfoutput>#val(attributes.ID)#</cfoutput>"  />
        <input type="hidden" name="thismainID" value="<cfoutput>#val(attributes.main)#</cfoutput>"  />
        <ul>
          <li>
            <label class="required" for="Name">Your Name (required):</label>
            <cfinput class="inp-2" name="sendername" type="text" id="Name" required="yes" message="You must enter your name"/>
          </li>
          <li>
            <label class="required" for="Name">Recipient Name (required):</label>
            <cfinput class="inp-2" name="Recipientname" type="text" id="Name" required="yes" message="You must enter the name of the person you are sending this article to"/>
          </li>
          <li>
            <label class="required" for="mail2">Your E-mail:</label>
            <cfinput class="inp-2" name="senderemail" type="text" id="senderemail" validate="email"  message="You must enter a valid e-mail address." required="yes"/>
          </li>
          <li>
            <label class="required" for="year">Recipient E-Mall:</label>
            <cfinput class="inp-2" name="Recipientemail" type="text" id="Recipientemail" validate="email"  message="You must enter a valid e-mail address." required="yes"/>
          </li>
          <li>
            <label class="comment" for="comment">Comment</label>
            <textarea class="inp-3" rows="" cols="" style="width:375px" name="emailcommenttext"></textarea>
          </li>
        </ul>
        <p align="center">
          <button type="submit" class="link" name="Action-B" value="B"><span>Send this Article</span></button>
        </p>
      </cfform>
    </div>
  </cfoutput></cfwindow>
<!---end Cfwindow ---> 
<!--- run scripts --->
<cfinclude template="/includes/bizmag/analytics.cfm" />
<script src="/js/scripts.js" type="text/javascript"></script> 
<script>
$(document).ready(function(){
optionHeight = $("#testZone").height() - 640;
$("#testZone").slideBox({width: "100%", height: "320px", position: "top"});
});
</script> 
<script type="text/javascript" src="/js/fontsize.js"></script> 
<script type="text/javascript" src="shadowbox.js"></script> 
<script type="text/javascript">
Shadowbox.init();
players: ["iframe"]
</script> 
<script language="javascript"> AC_FL_RunContent = 0; </script> 
<script language="javascript"> DetectFlashVer = 0; </script> 
<script src="AC_RunActiveContent.js" language="javascript"></script> 
<script language="JavaScript" type="text/javascript">
<!--
// -----------------------------------------------------------------------------
// Globals
// Major version of Flash required
var requiredMajorVersion = 8;
// Minor version of Flash required
var requiredMinorVersion = 0;
// Revision of Flash required
var requiredRevision = 24;
// -----------------------------------------------------------------------------
// -->
</script>
<style>
strong { font-weight:bold; }
em { font-style:italic; }
em.strong {font-weight:bold;}
strong.em {font-style:italic;}
</style>
</body>
</html>
