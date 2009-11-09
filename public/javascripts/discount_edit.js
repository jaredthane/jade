//Event.addBehavior({
//	'body' : function() {
//		$('add_new_requirement').hide();
//  },
//	'#bar_code_form' : Remote.Form
//});
$(document).ajaxSend(function(event, request, settings) {
	if (typeof(window.AUTH_TOKEN) == "undefined") return;
	// IE6 fix for http://dev.jquery.com/ticket/3155
	if (settings.type == 'GET' || settings.type == 'get') return;
 
	settings.data = settings.data || "";
	settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
});

function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/requirements/new",
  		data:{ bar_code: $("#bar_code_field").val()},
  		success: function(data){ 
  			var d = $('<div/>').append(data);
  			error=$('.error', d);
  			if (error.length>0){
  				$('#requirements_errors:visible').slideUp('slow', function(){$(this).slideDown('slow')});
  				$('#requirements_errors:hidden').append(error).slideDown('slow');
  			} else {
  				$('#requirements_errors:visible').slideUp('slow',delete_errors);
  			}
  			$('.requirement', d).appendTo('#requirements').hide().slideDown('slow',select_serial);
				$(".serial:last").keydown(function(e){
					if (e.keyCode == 13) {
					 	 $('#bar_code_field').select(); 
						 return false;
					 }
				});
			},
		});
}
function delete_errors(){
	$('.error').remove();
}
function select_serial() {
  $(".serial:last").select(); 
}
function DeleteHiddenLines(){
	$('.line:hidden').remove();
}
$(document).ready(function(){
	$('#add_new_requirement').hide();
	$('#requirements_errors').hide();
	$('#bar_code_form').show();
	$("#category_lookup").autocomplete("/categories.js"); 
	$("#bar_code_field").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
});
