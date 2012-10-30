(function($){$.fn.slideBox=function(params){var content=$(this).html();var defaults={width:"100%",height:"120%",position:"bottom"}
if(params)$.extend(defaults,params);var divPanel=$("<div class='slide-panel'>");var divContent=$("<div class='table-content'>");$(divContent).html(content);$(divPanel).addClass(defaults.position);$(divPanel).css("width",defaults.width);$(divPanel).css("left",(100-parseInt(defaults.width))/2+"%");if(defaults.position=="top")
$(divPanel).append($(divContent));$(divPanel).append("<div class='slide-button'>Table of Contents</div>");$(divPanel).append("<div style='display: none' id='close-button' class='slide-button'>Table of Contents</div>");if(defaults.position=="bottom")
$(divPanel).append($(divContent));$(this).replaceWith($(divPanel));$(".slide-button").click(function(){if($(this).attr("id")=="close-button")
$(divContent).animate({height:"0px"},1000);else
$(divContent).animate({height:defaults.height},1000);$(".slide-button").toggle();});};})(jQuery);