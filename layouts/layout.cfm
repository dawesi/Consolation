<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

	<base href="<cfoutput>#getSetting('htmlBaseURL')#</cfoutput>">

	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js"></script>
	
	<link href="/css/custom-theme/jquery-ui-1.8.12.custom.css" rel="stylesheet" type="text/css" />
	<link href="/css/layout.css" rel="stylesheet" type="text/css" />
	<link href="/css/consolation.css" rel="stylesheet" type="text/css" />
	
<!---	<script src="modules/consolation/js/console.default.js" type="text/javascript"></script>--->
	
	
	<script language="JavaScript">
	<cfinclude template="../js/console.default.js" >
	</script>	

	
</head>
<body>


	<div class="shell">
	<div align="center">



		<div class="header">
			<div class="header-image">
				<img src="includes/images/nd-logo.gif">		
			</div>
			
			<div class="header-text">
				<h1>Consolation</h1>
			</div>			
		</div>

<div class="container">	
		<div class="content">
			
			<div class="content-body">
				
			<!--- Render The View. This is set wherever you want to render the view in your layouts. --->
			<cfoutput>#renderView()#</cfoutput>
			</div>
			
		</div>
		
		<div class="footer">
			<p>Copyright © 2011 University of Notre Dame Notre Dame, Indiana 46556</p>
		</div>
		
	</div>
	</div>
	</div>


</body>
</html>







