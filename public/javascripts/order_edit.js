onerror=handleErr;
function handleErr(msg,url,l) {
	alert("There was an error on this page.\n\nError: " + msg + "\nURL: " + url + "\nLine: " + l + "\n\nClick OK to continue.\n\n");
	return true;
}
function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/lines/new",
  		data:{ bar_code: $("#bar_code_field").val(), client_name: $('#clients_lookup').val(), order_type_id:$('#order_type_id').val()},
  		success: function(data){ 
  			var d = $('<div/>').append(data);
  			error=$('.error', d);
  			$('.error_line').slideUp('slow').replaceWith(error, d).slideDown('slow');
  			$('.line', d).appendTo('#lines').hide().slideDown('slow',select_serial);
				$(".serial:last").keydown(function(e){
					if (e.keyCode == 13) {
					 	 $('#bar_code_field').select(); 
						 return false;
					 }
				});
			},
		});
}
function select_serial() {
  $(".serial:last").select(); 
}
function DeleteHiddenLines(){
	$('.line:hidden').remove();
}
$(document).ready(function(){
	$('#add_new_line').hide();
	$('#bar_code_form').show();
	//Setup	date picker
	$.datepicker.regional['es']
	$(".datepicker").datepicker();
	// Prepare lookups
	$("#client_lookup").autocomplete("/clients.js"); 
	$("#vendor_lookup").autocomplete("/vendors.js"); 
	$("#bar_code_field").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
	$("#get_ajax").click(DoAjaxRequest);
});
