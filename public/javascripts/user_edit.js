function DoAjaxRequest(){
	$.post({
  		url: "/users/new_role",
  		data:{ role_id: $("#" + bar_code_field).val(), is_output:is_output},
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
$(document).ready(function(){


});
