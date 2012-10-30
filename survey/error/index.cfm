<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>Mendoza College of Business: Survey Error</title>
<meta name="description" content="Mendoza College of Business: Survey Error" />
<meta name="keywords" content="" />
<cfparam name="attributes.message" default="The form cannot be processed">
<cfparam name="attributes.firstnameerror" default="0" />
<cfparam name="attributes.lastnameerror" default="0" />
<cfparam name="attributes.dateIDerror" default="0" />
<cfparam name="attributes.companyerror" default="0" />
<cfparam name="attributes.programerror" default="0" />
<cfparam name="attributes.addressline1error" default="0" />
<cfparam name="attributes.phoneerror" default="0" />
<cfparam name="attributes.cityerror" default="0" />
<cfparam name="attributes.stateerror" default="0" />
<cfparam name="attributes.ziperror" default="0" />
<cfparam name="attributes.confirmemailerror" default="0" />
<cfparam name="attributes.emailerror" default="0" />
</head>
<body>
      <div id="content"><cfoutput>
          <h3>#attributes.message#</h3>
          <ul class="arrowlist">
<cfif attributes.firstnameerror><li><h4>Please enter a firstname</h4></li></cfif>
<cfif attributes.lastnameerror><li><h4>Please enter a lastname</h4></li></cfif>
<cfif attributes.dateIDerror><li><h4>Please enter a dateID</h4></li></cfif>
<cfif attributes.companyerror><li><h4>Please enter a company</h4></li></cfif>
<cfif attributes.programerror><li><h4>Please enter a program</h4></li></cfif>
<cfif attributes.addressline1error><li><h4>Please enter a addressline1</h4></li></cfif>
<cfif attributes.phoneerror><li><h4>Please enter a phone</h4></li></cfif>
<cfif attributes.cityerror><li><h4>Please enter a city</h4></li></cfif>
<cfif attributes.stateerror><li><h4>Please enter a state</h4></li></cfif>
<cfif attributes.ziperror><li><h4>Please enter a zip</h4></li></cfif>
<cfif attributes.confirmemailerror><li><h4>Please enter a confirm email</h4></li></cfif>
<cfif attributes.emailerror><li><h4>Please enter a email</h4></li></cfif>
          </ul>
          <p class="frontHeadlineCopy"><a href="javascript: window.history.go(-1)" title="Back">Back</a></p>
        </cfoutput> </div>
</body>
</html>
