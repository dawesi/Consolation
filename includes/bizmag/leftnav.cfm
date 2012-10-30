<cfif attributes.allow>
<cfset variables.urlAccess = "&allow=1" />
<cfelse>
<cfset variables.urlAccess = "" />
</cfif>
<div id="cover">
  <h3>TABLE OF CONTENTS</h3>
  <ul>
    <li>
    <cfoutput>
      <div class="nav"><a href="/article/#coverstoryquery.articleID#/#coverstoryquery.urlslug#/#variables.urlAccess#" rel="toggle[COVER-STORY]">COVER STORY</a></div>
      <cfif variables.thisarticletypeID eq 11>
        <ul id="COVER-STORY">
          <cfloop query="coverstoryquery">
            <cfif val(coverstoryquery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="/article/#coverstoryquery.articleID#/#coverstoryquery.urlslug#/#variables.urlAccess#">#coverstoryquery.headline#</a>
            </li>
          </cfloop>
        </ul>
      </cfif>
    </cfoutput>
    </li>
    <li>
    <div class="nav"><a href="/feature_articles/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>" rel="toggle[FEATURE-ARTICLES]">FEATURED ARTICLES</a></div>
    <cfif variables.thisarticletypeID eq 1>
      <ul id="FEATURE-ARTICLES">
        <cfoutput>
          <cfloop query="featurearticlequery">
            <cfif val(featurearticlequery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="/article/#featurearticlequery.articleID#/#featurearticlequery.urlslug#/#variables.urlAccess#">#featurearticlequery.headline#</a>
            </li>
          </cfloop>
        </cfoutput>
      </ul>
    </cfif>
    </li>
    <li>
    <div class="nav"><a href="/taking_stock/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>" rel="toggle[TAKING-STOCK]">TAKING STOCK <span>FIRST-PERSON ESSAYS</span></a></div>
    <cfif variables.thisarticletypeID eq 3>
      <ul id="TAKING-STOCK">
        <cfoutput>
          <cfloop query="takingstockquery">
            <cfif val(takingstockquery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="/article/#takingstockquery.articleID#/#takingstockquery.urlslug#/#variables.urlAccess#">#takingstockquery.headline#</a>
            </li>
          </cfloop>
        </cfoutput>
      </ul>
    </cfif>
    </li>
    <li>
    <div class="nav active"><a href="/front_lines/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>" rel="toggle[front-line]">FRONT LINES <span>CURRENT NEWS FROM THE COLLEGE</span></a></div>
    <cfif variables.thisarticletypeID eq 2>
      <ul id="front-line">
        <cfoutput>
          <cfloop query="frontlinesquery">
            <cfif val(frontlinesquery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="/article/#frontlinesquery.articleID#/#frontlinesquery.urlslug#/#variables.urlAccess#">#frontlinesquery.headline#</a>
            </li>
          </cfloop>
        </cfoutput>
      </ul>
    </cfif>
    </li>
    <li>
    <cfoutput>
      <div class="nav"><a href="/front_row/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>" rel="toggle[FRONT-ROW]">FRONT ROW <span>INSIDE THE CLASSROOM</span></a></div>
      <cfif variables.thisarticletypeID eq 4>
        <ul id="FRONT-ROW">
          <cfloop query="frontrowquery">
            <cfif val(frontrowquery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="/article/#frontrowquery.articleID#/#frontrowquery.urlslug#/#variables.urlAccess#">#frontrowquery.headline#</a>
            </li>
          </cfloop>
        </ul>
      </cfif>
    </cfoutput>
    </li>
    <li>
    <div class="nav"><a href="/fore_front/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>" rel="toggle[FOREFRONT]">FOREFRONT <span>FOCUS ON FACULTY RESEARCH</span></a></div>
    <cfif variables.thisarticletypeID eq 5>
      <ul id="FOREFRONT">
        <cfoutput>
          <cfloop query="forefrontquery">
            <cfif val(forefrontquery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="/article/#forefrontquery.articleID#/#forefrontquery.urlslug#/#variables.urlAccess#">#forefrontquery.headline#</a>
            </li>
          </cfloop>
        </cfoutput>
      </ul>
    </cfif>
    </li>
    <li>
    <div class="nav"><a href="/class_notes/alumni_news/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>" rel="toggle[CLASS-NOTES]">CLASS NOTES</a></div>
    <cfif variables.thisarticletypeID eq 13 or variables.thisarticletypeID eq 14 or variables.thisarticletypeID eq 15 or variables.thisarticletypeID eq 16 >
      <ul id="CLASS-NOTES">
        
          <li <cfif variables.thisarticletypeID eq 13> class="selected"</cfif>>
        <a href="/class_notes/alumni_news/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">Alumni News</a>
        </li>
        
          <li <cfif variables.thisarticletypeID eq 14>class="selected"</cfif>>
        <a href="/class_notes/weddings/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">Weddings</a>
        </li>
        
          <li <cfif variables.thisarticletypeID eq 15>class="selected"</cfif>>
        <a href="/class_notes/future_domers/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">Future Domers</a>
        </li>
        
          <li <cfif variables.thisarticletypeID eq 16>class="selected"</cfif>>
        <a href="/class_notes/in_memoriam/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">In Memoriam</a>
        </li>
        <li><a href="http://webapp.business.nd.edu/class_notes/" target="_blank">Update your Class Notes</a></li>
      </ul>
    </cfif>
    </li>
    <li>
    <cfoutput>
      <div class="nav"><a href="/article/#askmorequery.articleID#/#askmorequery.urlslug#/#variables.urlAccess#" rel="toggle[BUSINESS-PROFILE]">ASK MORE OF BUSINESS PROFILE</a></div>
      <cfif variables.thisarticletypeID eq 6>
        <ul id="BUSINESS-PROFILE">
          <cfloop query="askmorequery">
            <cfif val(askmorequery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="/article/#askmorequery.articleID#/#askmorequery.urlslug#/#variables.urlAccess#">#askmorequery.headline#</a>
            </li>
          </cfloop>
        </ul>
      </cfif>
    </cfoutput>
    </li>
  </ul>
</div>
<cfif webexclusivesquery.recordcount neq 0>
<div id="web-box">
  <div id="web-bottom">
    <div id="web-top">
      <h3><a href="/web_exclusives/?issueid=<cfoutput>#attributes.issueID##variables.urlAccess#</cfoutput>">WEB EXCLUSIVES</a></h3>
      <ul>
        <cfoutput>
          <cfloop query="webexclusivesquery">
            <cfif val(webexclusivesquery.articleID) eq val(attributes.main)>
              <li class="selected">
                <cfelse>
              <li>
            </cfif>
            <a href="<cfif webexclusivesquery.externalurl eq ''>/article/#webexclusivesquery.articleID#/#webexclusivesquery.urlslug#/#variables.urlAccess#<cfelse>#webexclusivesquery.externalurl##variables.urlAccess#</cfif>">#webexclusivesquery.headline#</a>
            </li>
          </cfloop>
        </cfoutput>
      </ul>
    </div>
  </div>
</div>
</cfif>