<ul>
  <li>
    <cfif editorquery.recordcount neq 0>
      <a href="/article/<cfoutput>#editorquery.articleID#/#editorquery.urlslug##variables.urlAccess#</cfoutput>">FROM THE EDITOR</a>
      <cfelse>
      FROM THE EDITOR
    </cfif>
  </li>
  <li><a href="http://webapp.business.nd.edu/class_notes/" target="_blank">SEND A CLASS NOTE</a></li>
  <li><a href="/contact_us/">EDITORS / CONTACT US</a></li>
  <li><a href="/past_issues/">PAST ISSUES</a></li>
  <cfif getmostrecentissue.issueID neq attributes.issueID>
    <li><a href="/">CURRENT ISSUE</a></li>
  </cfif>
</ul>
