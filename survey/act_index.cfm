<cfdump var="#attributes#" label="Attributes" expand="yes">
<cfdump var="#variables#" label="Form" expand="no">
<cfdump var="#FORM#" label="Form" expand="no">
<cfdump var="#URL#" label="URL" expand="no">
<cfdump var="#SESSION#" label="Session" expand="no">
<cfdump var="#APPLICATION#" label="Application" expand="no">
<cfdump var="#CGI#" label="CGI" expand="no">
<cfdump var="#CLIENT#" label="Client" expand="no">
<cfdump var="#REQUEST#" label="Request" expand="no">
<cfdump var="#SERVER#" label="Server" expand="no">

<!--- 
By: Matt Chupp 
Created on  9.9.2011
Description: Bizmag action page
Added: 
 --->
 
<cfparam name="attributes.firstname" default="" >
<cfparam name="attributes.lastname" default="" >
<cfparam name="attributes.email" default="" >
<cfparam name="attributes.domestic" default="0" >
<cfparam name="attributes.address" default="" >
<cfparam name="attributes.address2" default="" >
<cfparam name="attributes.city" default="" >
<cfparam name="attributes.state" default="" >
<cfparam name="attributes.zip" default="" >
<cfparam name="attributes.country" default="" >
<cfparam name="attributes.province" default="" >
<cfparam name="attributes.phonenumber" default="" >
<cfparam name="attributes.gradinfo" default="" >
<cfparam name="attributes.company" default="" >
<cfparam name="attributes.ideatext" default="" >
<cfparam name="attributes.live" default="0" >

<cfset variables.concentrationlist = "" />
<cfset variables.financelist = "" />
<!--- ERROR CHECKING --->
            
<cfset variables.formerrorlist = "" />
<cfset variables.errorflag = 0 />
<cfif trim(attributes.firstname) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "firstnameerror")>
</cfif>
<cfif trim(attributes.lastname) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "lastnameerror")>
</cfif>
<cfif trim(attributes.address) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "addresserror")>
</cfif>
<cfif trim(attributes.ideatext) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "ideatexterror")>
</cfif>
<cfif trim(attributes.phonenumber) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "phonenumbererror")>
</cfif>
<cfif trim(attributes.gradinfo) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "gradinfoerror")>
</cfif>
<cfif trim(attributes.zip) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "ziperror")>
</cfif>
<cfif trim(attributes.email) eq ''>
  <cfset variables.errorflag = 1 />
  <cfset variables.formerrorlist =  listAppend(variables.formerrorlist, "ziperror")>
</cfif>



<cfif variables.errorflag>
  <cfset variables.querystring = "">
  <cfloop list="#variables.formerrorlist#" index="item">
  <cfset variables.querystring = #trim(variables.querystring)# & #item#& "=1&">
  </cfloop>
  <cfset variables.querystring = #left(variables.querystring, len(variables.querystring)-1)# >
  <cflocation url="/mba/becomingirish/course_selection_1yr/error/?#variables.querystring#" addtoken="No">
</cfif>
<!--- END ERROR CHECKING --->

<cfif attributes.email neq ''>
<!--- insert form contents into database --->
<!--- <cftry>  --->
  <cfquery datasource="#application.dsn#" name="insertcourses" > 
   INSERT into bizmag_ideassurvey
   (
firstname,
lastname,
email,
domestic,
address,
address2,
city,
state,
zip,
country,
province,
phonenumber,
gradinfo,
company,
ideatext,
live,
submitdate
   )
   VALUES
		(
<cfqueryPARAM value = "#trim(attributes.firstname)#" cfsqltype='cf_sql_varchar' maxlength='150' />,
<cfqueryPARAM value = "#trim(attributes.lastname)#" cfsqltype='cf_sql_varchar' maxlength='150' />,
<cfqueryPARAM value = "#trim(attributes.email)#" cfsqltype='cf_sql_varchar' maxlength='150' />,
<cfqueryPARAM value = "#trim(attributes.domestic)#" cfsqltype='cf_sql_tinyint'  />,
<cfqueryPARAM value = "#trim(attributes.address)#" cfsqltype='cf_sql_varchar' maxlength='255' />,
<cfqueryPARAM value = "#trim(attributes.address2)#" cfsqltype='cf_sql_varchar' maxlength='255' />,
<cfqueryPARAM value = "#trim(attributes.city)#" cfsqltype='cf_sql_varchar' maxlength='150' />,
<cfqueryPARAM value = "#trim(attributes.state)#" cfsqltype='cf_sql_varchar' maxlength='50' />,
<cfqueryPARAM value = "#trim(attributes.zip)#" cfsqltype='cf_sql_varchar' maxlength='150' />,
<cfqueryPARAM value = "#trim(attributes.country)#" cfsqltype='cf_sql_varchar' maxlength='150' />,
<cfqueryPARAM value = "#trim(attributes.province)#" cfsqltype='cf_sql_varchar' maxlength='50' />,
<cfqueryPARAM value = "#trim(attributes.phonenumber)#" cfsqltype='cf_sql_varchar' maxlength='150' />,
<cfqueryPARAM value = "#trim(attributes.gradinfo)#" cfsqltype='cf_sql_varchar' maxlength='255' />,
<cfqueryPARAM value = "#trim(attributes.company)#" cfsqltype='cf_sql_varchar' maxlength='255' />,
<cfqueryPARAM value = "#trim(attributes.ideatext)#" cfsqltype='cf_sql_longvarchar'  />,
         1,
         '#dateformat(now(),"mm/dd/yyyy")# #timeformat(now(), "hh:mm tt")#'
         )
  </cfquery>
<cfset variables.thissubject = "Ideas Survey Response Submitted" />
<cfset variables.emailto = "Edward.G.Cohen.8@nd.edu" />
<cfset variables.bccfield = "#application.adminemail#" />


    <!---   bcc="#application.adminemail#"  --->
    
  <cfmail from="mmwg@nd.edu"
    to="#variables.emailto#"
    bcc="#variables.bccfield#"
    subject="#variables.thissubject#"
    type="html">
    <style type="text/css">

.text {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
}
.textBold {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}

</style>
    <table width="80%" border="0" cellpadding="3" cellspacing="1" bgcolor="##CCCCCC">
      <tr bgcolor="##EEEEEE">
        <td colspan="2"><span class="text">Business Magazine - Ideas Survey</span></td>
      </tr>
      <tr>
        <td colspan="2"align="right" bgcolor="##FFFFFF" class="text">#DateFormat(Now(),"mmmm dd, yyyy")# #TimeFormat(Now(),"h:mm tt")#</td>
      </tr>
      <tr>
        <td bgcolor="##FFFFFF" colspan="2">&nbsp;</td>
      </tr>
      
<tr><td bgcolor="##EEEEEE" class="text">firstname</td><td bgcolor="##FFFFFF" class="text">#attributes.firstname#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">lastname</td><td bgcolor="##FFFFFF" class="text">#attributes.lastname#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">email</td><td bgcolor="##FFFFFF" class="text">#attributes.email#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">domestic</td><td bgcolor="##FFFFFF" class="text">#attributes.domestic#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">address</td><td bgcolor="##FFFFFF" class="text">#attributes.address#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">address2</td><td bgcolor="##FFFFFF" class="text">#attributes.address2#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">city</td><td bgcolor="##FFFFFF" class="text">#attributes.city#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">state</td><td bgcolor="##FFFFFF" class="text">#attributes.state#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">zip</td><td bgcolor="##FFFFFF" class="text">#attributes.zip#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">country</td><td bgcolor="##FFFFFF" class="text">#attributes.country#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">province</td><td bgcolor="##FFFFFF" class="text">#attributes.province#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">phonenumber</td><td bgcolor="##FFFFFF" class="text">#attributes.phonenumber#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">gradinfo</td><td bgcolor="##FFFFFF" class="text">#attributes.gradinfo#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">company</td><td bgcolor="##FFFFFF" class="text">#attributes.company#</td></tr>
<tr><td bgcolor="##EEEEEE" class="text">ideatext</td><td bgcolor="##FFFFFF" class="text">#attributes.ideatext#</td></tr>
    </table> 
</cfmail>
</cfif>
<cflocation url="/survey/thank_you/" addtoken="no">
