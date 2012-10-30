<!--- <cfinclude template="/includes/bizmag/setissue.cfm" />
<cfobject component="bizmag_cfcs.bizmagarticles" name="articlesObject"> --->
<!-- Display email address --->
<!--- <cfset variables.articlequery = #articlesObject.getIssueArticles(attributes.issueID)# /> --->
<!--- page queries --->

<cfset featurearticlequery = #articlesObject.getallArticleType(attributes.issueID,1)#>
<cfset takingstockquery = #articlesObject.getallArticleType(attributes.issueID,3)#>
<cfset frontlinesquery = #articlesObject.getallArticleType(attributes.issueID,2)#>
<cfset frontrowquery = #articlesObject.getallArticleType(attributes.issueID,4)#>
<cfset forefrontquery = #articlesObject.getallArticleType(attributes.issueID,5)#>
<cfset askmorequery = #articlesObject.getallArticleType(attributes.issueID,6)#>
<cfset webexclusivesquery = #articlesObject.getallArticleType(attributes.issueID,7)#>
<cfset coverstoryquery = #articlesObject.getallArticleType(attributes.issueID,11)#>
<cfset editorquery = #articlesObject.getallArticleType(attributes.issueID,12)#>
<!-- top slider-->

<div id="testZone">
  <div class="column-sec">
      <cfoutput>
    <h3><cfif coverstoryquery.recordcount neq 0><a href="/article/#coverstoryquery.articleID#/#coverstoryquery.urlslug#/">COVER STORY</a><cfelse>COVER STORY</cfif></h3>
    <ul class="gray">
        <cfloop query="coverstoryquery">
          <li><a href="/article/#coverstoryquery.articleID#/#coverstoryquery.urlslug#/">#coverstoryquery.headline#</a></li>
        </cfloop>
    </ul>
          </cfoutput>
    <h3><a href="/feature_articles/?issueid=<cfoutput>#attributes.issueID#</cfoutput>">FEATURED ARTICLES</a></h3>
    <ul class="gray">
      <cfoutput>
        <cfloop query="featurearticlequery">
          <li><a href="/article/#featurearticlequery.articleID#/#featurearticlequery.urlslug#/">#featurearticlequery.headline#</a></li>
        </cfloop>
      </cfoutput>
    </ul>
    <h3><a href="/taking_stock/?issueid=<cfoutput>#attributes.issueID#</cfoutput>">TAKING STOCK</a></h3>
     <span class="normal">FIRST-PERSON ESSAYS</span>
    <ul class="gray">
      <cfoutput>
        <cfloop query="takingstockquery">
          <li><a href="/article/#takingstockquery.articleID#/#takingstockquery.urlslug#/">#takingstockquery.headline#</a></li>
        </cfloop>
      </cfoutput>
    </ul>
  </div>
  <div class="column">
    <h3><a href="/front_lines/?issueid=<cfoutput>#attributes.issueID#</cfoutput>">FRONT LINES</a></h3>
    <span class="normal">CURRENT NEWS FROM THE COLLEGE</span>
    <ul class="gray">
      <cfoutput>
        <cfloop query="frontlinesquery">
          <li><a href="/article/#frontlinesquery.articleID#/#frontlinesquery.urlslug#/">#frontlinesquery.headline#</a></li>
        </cfloop>
      </cfoutput>
    </ul>
    <cfoutput>
      <h3><cfif val(frontrowquery.articleID) neq 0><a href="/front_row/?issueid=<cfoutput>#attributes.issueID#</cfoutput>">FRONT ROW</a><cfelse>FRONT ROW</cfif></h3>
       <span class="normal">INSIDE THE CLASSROOM</span>
      <ul class="gray">
        <cfloop query="frontrowquery">
          <li><a href="/article/#frontrowquery.articleID#/#frontrowquery.urlslug#/">#frontrowquery.headline#</a></li>
        </cfloop>
      </ul>
    </cfoutput> </div>
  <div class="column">
    <h3><a href="/fore_front/?issueid=<cfoutput>#attributes.issueID#</cfoutput>">FOREFRONT</a></h3>
    <span class="normal">FOCUS ON FACULTY RESEARCH</span>
    <ul class="gray">
      <cfoutput>
        <cfloop query="forefrontquery">
          <li><a href="/article/#forefrontquery.articleID#/#forefrontquery.urlslug#/">#forefrontquery.headline#</a></li>
        </cfloop>
      </cfoutput>
    </ul>
    <h3><a href="/class_notes/alumni_news/?issueid=<cfoutput>#attributes.issueID#</cfoutput>">CLASS NOTES</a></h3>
    <cfoutput>
      <ul class="gray">
        <li><a href="/class_notes/alumni_news/?issueid=#attributes.issueID#">Alumni News</a></li>
        <li><a href="/class_notes/weddings/?issueid=#attributes.issueID#">Weddings</a></li>
        <li><a href="/class_notes/future_domers/?issueid=#attributes.issueID#">Future Domers</a></li>
        <li><a href="/class_notes/in_memoriam/?issueid=#attributes.issueID#">In Memoriam</a></li>
        <li><a href="http://webapp.business.nd.edu/class_notes/" target="_blank">Update your Class Notes</a></li>
      </ul>
      <h3><cfif askmorequery.recordcount neq 0><a href="/article/#askmorequery.articleID#/#askmorequery.urlslug#/">ASK MORE OF BUSINESS</a><cfelse>ASK MORE OF BUSINESS</cfif></h3>
      <ul class="gray">
        <cfloop query="askmorequery">
          <li><a href="/article/#askmorequery.articleID#/#askmorequery.urlslug#/">#askmorequery.headline#</a></li>
        </cfloop>
      </ul>
    </cfoutput> </div>
  <div class="column-sec">
    <ul class="yellow">
      <li><cfif editorquery.recordcount neq 0><a href="<cfoutput>/article/#editorquery.articleID#/#editorquery.urlslug#/</cfoutput>">FROM THE EDITOR</a><cfelse>FROM THE EDITOR</cfif></li>
      <li><a href="http://webapp.business.nd.edu/class_notes/" target="_blank">SEND A CLASS NOTE</a></li>
      <li><a href="/contact_us/">EDITORS / CONTACT US</a></li>
      <li><a href="/past_issues/">PAST ISSUES</a></li>
    </ul>
    <h3><a href="/web_exclusives/?issueid=<cfoutput>#attributes.issueID#</cfoutput>">WEB EXCLUSIVES</a></h3>
    <ul class="gray">
      <cfoutput>
        <cfloop query="webexclusivesquery">
          <li><a href="/article/#webexclusivesquery.articleID#/#webexclusivesquery.urlslug#/">#webexclusivesquery.headline#</a></li>
        </cfloop>
      </cfoutput>
    </ul>
  </div>
</div>
<!-- top slider-->
