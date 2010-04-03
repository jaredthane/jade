onerror=handleErr;
function handleErr(msg,url,l) {
	alert("There was an error on this page.\n\nError: " + msg + "\nURL: " + url + "\nLine: " + l + "\n\nClick OK to continue.\n\n");
	return true;
}
function check_box(e) {
  e.prev(":check_box").attr( "checked", "true" );
  e.closest(".line").slideUp("slow");
}
function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/lines/new",
  		data:{ bar_code: $("#bar_code_field").val(), client_name: $('#clients_lookup').val(), order_type_id:$('#order_type_id').val()},
  		success: function(data){
  			var d = $('<div/>').append(data);
  			error=$('.error', d);
  			if (error.length>0){
  				$('#lines_errors:visible').slideUp('slow', function(){$(this).slideDown('slow')});
  				$('#lines_errors:hidden').append(error).slideDown('slow');
  			} else {
  				$('#lines_errors:visible').slideUp('slow',delete_errors);
  			}
  			$('.line', d).appendTo('#lines').hide().slideDown('slow',select_serial);
	        $(".datepicker:last").datepicker();
//				$(".serial:last").keydown(function(e){
//					if (e.keyCode == 13) {
//					 	 $('#bar_code_field').select(); 
//						 return false;
//					 }
//				});
			},
		});
}
function delete_errors(){
	$('.error').remove();
}
function select_serial() {
  $(".serial:last").select(); 
}
//function DeleteHiddenLines(){
//	$('.line:hidden').remove();
//}
$(document).ready(function(){
	$('#add_new_line').hide();
	
	$('#bar_code_form').show();
	$('#lines_errors').hide();
	//Setup	date picker
	$.datepicker.regional['es']
	$(".datepicker").datepicker();
//	$(document).bind('keydown', '6', submit('order_form'));
//	jQuery(document).bind('keydown', 'Ctrl+return',function (evt){submit('order_form'); return false; }); 
	jQuery(document).bind('keydown', 'esc',function (evt){window.location = $('#cancel_url').val(); return false; }); 
	// Prepare lookups
	$("#client_lookup").autocomplete("/clients.js",{matchSubset:0, autoFill:1}); 
	$("#vendor_lookup").autocomplete("/vendors.js",{matchSubset:0, autoFill:1}); 
	$(".site_lookup").autocomplete("/sites.js",{matchSubset:0, autoFill:1}); 
	$("#bar_code_field").autocomplete("/products.js",{matchSubset:0, autoFill:1}); 
	$("#bar_code_field").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
	$('#vendor_lookup').select();
	$('#client_lookup').select();
});
