
<cfset modelNameSingular = consoleRequest.name>
<cfset modelNamePlural = scaffoldService.pluralize(consoleRequest.name)>

<cfset collectionTable = scaffoldService.tableFormat(modelNamePlural)>
<cfset primaryColumn =	scaffoldService.getPrimaryColumn(collectionTable)>

<cfsavecontent variable="Sort">
<cfoutput>

#chr(60)#!--- generated at #now()# by Consolation: Coldbox Code Generator // Delete once modified --->
	
<script type="text/javascript">

$(document).ready(function(){
	jQuery.ajaxSettings.traditional = true;
	$('div.item-list').sortable({ 
		items: 'div.item', 
		cursor: 'hand', 
		axis: 'y',
		handle: '.dragger-control',
		opacity:.3,
		update: function(event, ui) { 
			var result = $('div.item-list').sortable('toArray');
			 $.post('index.cfm/#consoleRequest.modelname#/saveOrder',
				{
					data:result}
				);
	 		}
		});
  });

</script>		



<style>
.item-list{float:left; width:600px}	
.item{float:left; width:100%;  margin-bottom:5px; border:thin solid ##ccc; background-color:##f2f2f2}
.dragger-control{float:left;padding:5px; background-color:##000066; color:##f2f2f2; width:50px; cursor:pointer}
.item-title{float:left;padding:5px; width:500px}
</style>	
	
	
	<div class="item-list">
		#chr(60)#cfoutput>
	
		#chr(60)#cfloop array="##rc.#modelNamePlural###" index="#modelNameSingular#" >
	     <div id="###modelNameSingular#.id##" class="item">
			<div class="dragger-control">Move</div>
			<div class="item-title">###modelNameSingular#.#primaryColumn###</div>
		</div>
		#chr(60)#/cfloop>
	    
		#chr(60)#/cfoutput>
	</div>
	

</cfoutput>
</cfsavecontent>