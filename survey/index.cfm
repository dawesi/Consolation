<cfinclude template="/includes/bizmag/analytics.cfm">
<link rel="stylesheet" type="text/css" href="/styles/form.css"/>
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.2.min.js" type="text/javascript"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.8.1/jquery.validate.min.js" type="text/javascript"></script>
<script src="/survey/validate_form.js" type="text/javascript"></script>
<cfquery datasource="#application.dsn#" name="getcountries">
SELECT     country
FROM         talisma_countries
ORDER BY country
</cfquery>
<cfquery datasource="#application.dsn#" name="getstates">
SELECT     state, usstate, province
FROM         talisma_states
WHERE     (province <> 1)
ORDER BY usstate DESC, state
</cfquery>
<cfquery datasource="#application.dsn#" name="getprovinces">
SELECT     state
FROM         talisma_states
WHERE province = 1
ORDER BY state
</cfquery>
<script type="text/javascript" src="/mba/get_in_touch/request_information/js/request_info.js"></script>

<div id="stylized" class="myform">
<form id="surveyform" name="surveyform" method="post" action="act_index.cfm">
<h1>Notre Dame Tackles the Unemployment Problem</h1>
<p><strong>Rules for Notre Dame Tackles the Unemployment Problem</strong><br /><br />
Deadline for entry is Oct. 7, 2011<br /><br />
All submissions become property of the Mendoza College of Business and may be published in print or on the Mendoza website.<br /><br />
If your submission is selected for publication, you may be required to submit a head-and-shoulders digital photo suitable for printing. Photos may appear in the magazine and/or at the Mendoza website.<br /><br />
The magazine's editors reserve the right to edit for clarity and brevity.<br /><br />
Members of the Notre Dame Business magazine staff are not eligible to enter.<br /><br />
<p><strong>Selection Process</strong><br /><br />
A committee of Mendoza College of Business faculty and staff will select the 25 best ideas. Consideration will be given to representing the range of ideas submitted in terms of source, type, philosophy and subject matter.<br /><br />
Individuals selected will each receive a $25 gift card for the Hammes Notre Dame Bookstore. The selected submissions will be published in the Winter 2012 issue of Notre Dame Business magazine.</p>
<div class="formrow">
<label>First Name*
</label>
<input type="text" name="firstname" id="firstname" />
</div><div class="formrow">
<label>Last Name*
</label>
<input type="text" name="lastname" id="lastname" />
</div><div class="formrow">
<label>Email Address*
<span class="small">Add a valid address</span>
</label>
<input type="text" name="email" id="email" />
</div>
<!--- address --->
<fieldset>
            <legend><span>Address*</span></legend>
            <!--- radio button --->
<label>Domestic Address
</label>
<input type="radio" name="domestic"  value="1" class="radio"/>
<label>International Address
</label>
<input type="radio" name="domestic" value="0" class="radio" />
<div style="clear:both">
<div id="errorbox"></div></div>
            <!--- end radio button --->
            <div id="parent1">
            <div class="formrow">
                <label for="address1" class="required">Address*</label>
                <input type="text" class="text required" name="address" id="address" />
                </div>
              <div class="formrow">
                <label for="address2">Address 2</label>
                <input type="text" class="text" name="address2" id="address2" />
              </div>
              <div class="formrow">
                <label for="city" class="required">* City</label>
                <input type="text" class="text required" name="city" id="city" />
              </div>
              <div class="formrow floatwrapper" id="statelabel">
                <label for="state" class="required">* State</label>
                <cfoutput>
                <select name="state" id="state" >
                  <option value="" selected="selected"> (Select One) </option>
                  <cfloop query="getstates">
                  <option value="#getstates.state#" >#getstates.state#</option>
                  </cfloop>
                </select>
                </cfoutput>
              </div>
              <div class="formrow">
                <label for="postalcode" class="required" id="ziplabel">* ZIP / Postal Code</label>
                <input type="text" class="text required" name="zip" id="zip" />
              </div>
              <div class="formrow" id="countrylabel">
                <label for="country" class="required" >* Country (outside US)</label>
                <!---               <input type="text" class="text" name="country" id="country" /> --->
                <cfoutput>
                <select name="country" id="country" >
                  <option value="" selected="selected"> (Select One) </option>
                  <cfloop query="getcountries">
                  <option value="#getcountries.country#" >#getcountries.country#</option>
                  </cfloop>
                </select>
                </cfoutput>
              </div>
              <div class="formrow" id="provincelabel">
                <label for="province" class="required">* Province</label>
                <!---               <input type="text" class="text required" name="state" id="state" /> --->
                <cfoutput>
                <select name="province" id="province" >
                  <option value="" selected="selected"> (Select One) </option>
                  <cfloop query="getprovinces">
                  <option value="#getprovinces.state#" >#getprovinces.state#</option>
                  </cfloop>
                </select>
                </cfoutput>
              </div>
            </div>
          </fieldset>
<!--- end address --->
<!--- <label>Address
<span class="small">Add your contact address</span>
</label>
<input type="text" name="email" id="email" />

<label>City</label>
<input type="text" name="city" id="city" />

<label>State</label>
<input type="text" name="state" id="state" />

<label>Zip</label>
<input type="text" name="postalcode" id="postalcode" /> --->
<div class="formrow">
<label>Phone Number*
<span class="small">Home or Mobile Number</span>
</label>
<input type="text" name="phonenumber" id="phonenumber" />
</div><div class="formrow">
<label>Graduation Info*:
<span class="small">e.g (MBA '89)</span>
</label>
<input type="text" name="gradinfo" id="gradinfo" />
</div><div class="formrow">
<label>Current Employer:
<span class="small">Add your company name</span>
</label>
<input type="text" name="company" id="company" />
</div><div class="formrow">
<label>Current Title:
<span class="small">Add your job title</span>
</label>
<input type="text" name="company" id="company" />
</div><div class="formrow">
<label>Here's my best idea on how to reduce unemployment in the United States:
<span class="small">TIPS:  We're looking for ideas that show insight and imagination. If you can speak from personal experience or special knowledge, do so. In order to make your comments part of a meaningful dialogue, please discuss an answer, not a problem, and avoid political commentary. (50-150 words)</span>
</label>
<textarea name="ideatext" id="ideatext" ></textarea>
</div>
<div class="formrow"></div>
<button type="submit">Submit</button>
<div class="spacer"></div>
<p>* Required</p>
</form>
</div>
