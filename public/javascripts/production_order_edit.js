function DoAjaxRequest(is_output){
	if (is_output==0){
		lines_div='consumption_lines'
		errors_div='consumption_lines_errors'
		bar_code_field='consumption_bar_code'
	} else {
		lines_div='production_lines'
		errors_div='production_lines_errors'
		bar_code_field='production_bar_code'
	}
	$.ajax({
			type: 'POST',
  		url: "/production_orders/new_line",
  		data:{ bar_code: $("#" + bar_code_field).val(), is_output:is_output},
  		success: function(data){ 
  			var d = $('<div/>').append(data);
  			error=$('.error', d);
  			if (error.length>0){
  				$('#' + errors_div +':visible').slideUp('slow', function(){$(this).slideDown('slow')});
  				$('#' + errors_div +':hidden').append(error).slideDown('slow');
  			} else {
  				$('#' + errors_div +':visible').slideUp('slow',delete_errors);
//  				$('.line', d).appendTo('#' + lines_div).hide().slideDown('slow',select_serial);
					var new_task_id = "new_" + new Date().getTime();
  				$('.line', d).html($('.line', d).html().replace(/\[0\]/gi, "["+new_task_id+"]"));
  				$('.line', d).html($('.line', d).html().replace(/_0_/gi, "_"+new_task_id+"_"));
  				$('.line', d).appendTo('#' + lines_div).hide().slideDown('slow',select_serial);
  				$('#' + bar_code_field).select();
  			}
			},
		});
}
function delete_errors(){
	$('.error').remove();
}
function select_serial() {
  $(".serial:last").select(); 
	//  Must fix above line ot go to the correct serial since might no always be the last
}
function check_box(e) {
  e.prev(":check_box").attr( "checked", "true" );
  e.closest(".line").slideUp("slow");
}
$(document).ready(function(){
	//Setup	date picker
	$.datepicker.regional['es']
	$(".datepicker").datepicker();
	$("#consumption_bar_code").autocomplete("/products.js",{matchSubset:0, autoFill:1}); 
	$("#production_bar_code").autocomplete("/products.js",{matchSubset:0, autoFill:1}); 
	$("#consumption_bar_code").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest(0);
			e.preventDefault();
			return false;
		}
	});
	$("#production_bar_code").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest(1);
			e.preventDefault();
			return false;
		}
	});
});
