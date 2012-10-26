<cfsavecontent variable="sortCode">	

<cfoutput>#chr(60)#cfset model = rc.model>



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
			 $.post('service.cfm?#consoleRequest.name#.saveSortOrder',
				{
					id:0,
					data:result, // the array of ids
					requestKey: '#chr(60)#cfoutput>##session.requestKey###chr(60)#/cfoutput>'}
				);
	 		}
		});
  });

</script>		

<cfset primaryField = scaffoldService.getPrimaryColumn(consoleRequest.table)>

<style>
.item-list{float:left; width:600px}	
.item{float:left; width:100%;  margin-bottom:5px; border:thin solid ##ccc; background-color:##f2f2f2}
.dragger-control{float:left;padding:5px; background-color:##666; color:##f2f2f2; width:50px; cursor:pointer}
.item-title{float:left;padding:5px; width:500px}
</style>	
	
	<div class="item-list">
	
		#chr(60)#cfoutput query="model">
	     <div id="##id##" class="item">
			<div class="dragger-control">Move</div>
			<div class="item-title">###primaryField###</div>
		</div>
	    #chr(60)#/cfoutput>
	
	</div>
	</cfoutput>
</cfsavecontent>