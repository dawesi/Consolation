
$(document).ready(function(){
	
	
	
$('.clear').click(function(){		
	if ( $('.status').html().length == 0 ){					
		$('.log').html('');				
	} 
	$('.status').html('');
});



	$('.execute').click(function(){
		execute();
	});
	
	function execute(){				
		var newText = $('.console').val();	
		var oldText = $('.log').html();
		$('.log').html(oldText + '<p>' + newText + '</p>');
		
		var oldStatusText = $('.status').html();
		$('.status').html('<p align="center">Executing Request...<br /> <img src="images/loader3.gif">');
		
		$.post(
	  		'index.cfm/consolation:Runner',
	  		{
				
				command:$('.console').val()
				},
	  			function(r){
				$('.status').html('<p>Status: ' + r + '</p>');		
				console.log(r);
				}
			  	);	
		
		var oldText = $('.log').html();
		$('.console').val('').focus();
		
	};
	
$('.console').keydown(function(){
	if ($(this).val() == 'drop'){
		$(this).css('color', '#cc0000');
	}
	
	if ($(this).val().length == 0) {
		$(this).css('color', '#000000');
	}
	
})
	

$('.log p').live('click', function(){
	
	$('.console').val($(this).text());
	$('.console').focus();
});

$('.model-prop').live('click', function(){
	
	var currentText = $('.console').val();
	var newText = currentText + ' ' + $(this).text()+':required,';
	$('.console').val(newText);
	$('.console').focus();
});

$('.model-name').live('click', function(){
	var newText = 'scaffold all ' + $(this).text()+' ( ';
	$('.console').val(newText);
	$('.console').focus();
});



});