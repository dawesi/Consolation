// JavaScript Document
jQuery().ready(function() {
	// validate the comment form when it is submitted
	 $("#parent1").css("display","none");
        $(".radio").click(function(){
    	if ($('input[name=domestic]:checked').val() == "1" ) {
		//domestic student
			$("#country").val('');
  			$("#country").removeClass('required');		
            $("#statelabel").show("slow");	//Slide Up Effect
     		$("#countrylabel").hide();	//Slide Up Effect
			$("#provincelabel").hide();	//Slide Up Effect
   			$("#state").addClass('required');			
			$("#province").removeClass('required');	
            $("#parent1").slideDown("slow"); //Slide Down Effect
        } else {
   			$("#country").addClass('required');			
  			$("#state").removeClass('required');		
            $("#state").val('');
  			$("#state").removeClass('required');			
            $("#provincelabel").hide();	//Slide Up Effect
    		$("#countrylabel").show("slow");	//Slide Up Effect
			$("#statelabel").hide();
            $("#parent1").slideDown("slow"); //Slide Down Effect
        }
     });
	 $('#country').change(function() {
	var foo = $('#country').val();
  if (foo == 'Canada')
  {
  $("#province").addClass('required');	
  $("#provincelabel").show("slow");	
  }
  else 
  {
$("#province").removeClass('required');	
$("#provincelabel").hide("slow");
  }
});
	//jQuery("#reception_form").validate();
	$("#surveyform").validate({
		rules: {
            firstname: "required",
			lastname: "required",
			domestic: "required",
			address: "required",
			ideatext: "required",
			phone: "required",
			phonenumber: "required",
			gradinfo: "required",
			zip: "required",
			email: {
				required: true,
				email: true
			}
			
		},
		messages: {
			firstname: "Please enter your first name",
			lastname: "Please enter your last name",
			domestic: "Please enter your address type",
			gradinfo: "Please enter the program and year of your graduation",
	        ideatext: "Please enter your idea",
			phonenumber: "Please enter a contact number",
			address: "Please enter an address",
			phone: "Please enter a telephone number",
			city: "Please enter a city",
			state: "Please enter a state",
			zip: "Please enter a postal code",
			email: "Please enter a valid email address."
		},
		errorPlacement: function(error, element){
    if(element.attr("name") == "domestic"){
        error.appendTo($('#errorbox'));
        $('#errorbox').show();
       }
	else{
        error.appendTo( element.parent() );
        }
     }

	});
});