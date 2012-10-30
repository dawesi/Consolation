<div id="footer">
  <div id="footer-nav">
    <div class="over-div">
      <ul class="editor">
        <li><a href="/from_the_editor/?issueID=<cfoutput>#attributes.issueID#</cfoutput>">From the Editor</a></li>
        <li><a href="http://webapp.business.nd.edu/class_notes/" target="_blank">Send a Class Note</a></li>
        <li><a href="/contact_us/">Editors / Contact Us</a></li>
        <li style="background:none"><a href="/past_issues/">Past Issues</a></li>
      </ul>
    </div>
    <div class="over-div">
      <ul class="editor-2">
        <li><a href="/">Home</a></li>
        <li><a href="http://nd.edu/~gradalum"> Business Graduate Alumni Relations</a></li>
        <li><a href="http://business.nd.edu"> Mendoza College of Business</a></li>
        <li class="bcg1"><a href="http://nd.edu">University of Notre Dame</a></li>
      </ul>
    </div>
    <span class="copy">&copy; COPYRIGHT <cfoutput>#dateformat(now(),"yyyy")#</cfoutput></span></div>
  <cfoutput><cfif articlequery.pdfimage neq ""><div id="footer-right"><div style="margin-left:11px;"><a href="#articlequery.pdflink#" target="_blank"><img src="#articlequery.pdfimage#" alt="" align="top" /></a></div><span class="magazine"><a href="#articlequery.pdflink#" target="_blank">Business Magazine PDF</a></span> </div></cfif></cfoutput>
</div>
<!-- <a href="http://bizmagazine.nd.edu/includes/hpot_bizmag.cfm">quintuplicate</a> -->