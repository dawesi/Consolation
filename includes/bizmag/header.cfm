<!--- cfformprotect to prevent spam --->
<cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() /> 
<cfif getmostrecentissue.issueID eq attributes.issueID>
<cfset variables.thisIssuehomelink = "/" />
<cfelse>
<cfif isDefined("session.urlAccess")>
<cfset variables.thisIssuehomelink = "/?issueid=" &attributes.issueID & session.urlAccess />
<cfelse>
<cfset variables.thisIssuehomelink = "/?issueid=" &attributes.issueID />
</cfif>
</cfif>
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
<link rel="icon" href="/favicon.ico" type="image/x-icon">
<div id="header">
  <cfinclude template="/includes/bizmag/topslider.cfm" />
<!---   <cfdump var="#attributes.issueID#" /> --->
  <div id="header-left">
<!--- <cfoutput>NEWEST #getmostrecentissue.issueID# attrib #attributes.issueid#</cfoutput> --->
    <div id="nav">
      <ul>
        <li><cfoutput><a href="#variables.thisIssuehomelink#">Home</a></cfoutput></li>
        <cfif getmostrecentissue.issueID neq attributes.issueID><li><a href="/">Current Issue</a></li></cfif>
        <li><a href="http://www.nd.edu/~gradalum/">Business Graduate Alumni Relations</a></li>
        <li><a href="http://business.nd.edu/">Mendoza College of Business</a></li>
        <li class="bcg"><a href="http://www.nd.edu/">University of Notre Dame</a></li>
      </ul>
    </div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" ><tr><td width="27%"><a href="<cfoutput>#variables.thisIssuehomelink#</cfoutput>"><img src="/images/header_01.gif" width="337" height="51" class="inline" /></a></td>
<td width="3%"><a href="<cfoutput>#variables.thisIssuehomelink#</cfoutput>"><img src="<cfoutput>#articlequery.seasonimage#</cfoutput>" class="inline" /></a></td>
<td class="headeryear" width="6%" style="color:#E8ECF1; letter-spacing: 0.17em; font-weight: bold; font-family: Arial, Helvetica, sans-serif; font-size: 24px; padding-left:10px"><cfoutput><a href="#variables.thisIssuehomelink#">#dateformat(articlequery.issuedate,"yyyy")#</a></cfoutput></td><td width="44%">
<a href="<cfoutput>#variables.thisIssuehomelink#</cfoutput>"><img src="/images/header_03.gif" width="76" height="51" class="inline" /></a></td>
</tr>
</table>

<!--- <img src="/images/spring.jpg" alt="" width="608" height="51" /> --->
    <!--- hiding search box until later date <div id="go">
        <input class="inp-1" type="text" />
        <a href="#"><img class="go-button" src="/images/go.jpg" alt="" border="0" /></a> </div> --->
  </div>
  <div id="header-right">
    <h1><a href="http://business.nd.edu">notre</a></h1>
  </div>
</div>
<!--header ends here-->
