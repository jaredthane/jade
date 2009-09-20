function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/orders/new_line/",
  		data:{ upc: $("#upc").val(), num:$("#id_line_set-TOTAL_FORMS").val() },
  		success: function(data){ 
  			var d = $('<div/>').append(data)
  			$('.simple-line', d).appendTo('#simple-lines').hide().slideDown('slow');
  			$('.detailed-line', d).appendTo('#detailed-lines').hide().slideDown('slow');
//  			$('.lines').append(data);
//  			$('.table_row:last')
  			AddEventsToLine($('.simple-line:last'), $('.detailed-line:last'));
  			IncrementFormCount($("#id_line_set-TOTAL_FORMS"));
  			$("#upc").select();
  			$('select[id$=-product]').hide();
			},
  		error: function(){alert("An error has occurred. Please try again.");},
		});
}
function RequestSerial(e){
	e.preventDefault();
	var $el = $(e.target);
	$.ajax({
			type: 'POST',
  		url: "/orders/new_serial/",
  		// TODO - make this specific to the line
  		data:{num:$("#id_serialonline_set-TOTAL_FORMS").val()},
  		success: function(data){
  			var d = $('<div/>').append(data)
  			$('.table_row', d).appendTo($el.closest('.serial_list_with_link').find('.serial_numbers')).hide().slideDown('slow');
//  			$('.lines').append(data);
//  			$('.table_row:last')
//  		TODO add handler for deleting serial
//			AddEventsToLine($('.simple-line'), $('.detailed-line'));
  			IncrementFormCount($("#id_serialonline_set-TOTAL_FORMS"));
  			// TODO Leave the new serial number field selected
  			$("#upc").select();
			},
  		error: function(){alert("An error has occurred. Please try again.");},
		});
}
function  SetTimeOnReceived(received){
	$.ajax({
		url : "/get_time/",
			success : function (data) {
			received.attr('value', data);
		}
	});
}
function IncrementFormCount(obj){
		obj.attr('value', parseInt(obj.attr('value'))+1);
}
function AddDeleteLine(e){
	e.click( function(e){
		$(this).closest(".simple-line").slideUp("slow");
		$('#detailed-'+$(this).closest(".simple-line").attr('fff')).hide();
	});
}
function AddDeleteSerial(e){
	e.click( function(e){
		$(this).closest(".table_row").slideUp("slow");
	});
}
function AddMarkDelivered(e){
	e.click( function(){
		var other = $('#id_'+$(this).closest(".simple-line").attr('fff')+'-received')
		if ($(this).is(':checked')) {
			SetTimeOnReceived(other)
//			$(this).closest('.line').find('.received').children(':first').attr('value', '7')
		} else {
			other.attr('value', '')
		}
	});
}
function AddEventsToLine(simple, detailed){
	AddDeleteLine(simple.find('.delete_line_cell'));
	AddDeleteSerial(simple.find('.delete_serial_cell'));
	AddMarkDelivered(simple.find('.is_delivered'));
	if (detailed.find('.received-cell').children(':first').attr('value')!=''){
		simple.find('.is_delivered').attr('checked',true);
	}
	detailed.find('.received-cell').children(':first').datepicker();
	MakeShowHide(simple);
	simple.find("#add_serial").click(RequestSerial);
}
function MakeShowHide(div){

	div.find(".show_hide_serials").click(function(e){
		$(this).closest(".simple-line").find('.serial_list_with_link').slideToggle('slow');
		e.preventDefault();
		return false;
	});
}
// Replaced by thickbox
//////////////////////////////////////////////////////////////////////
//function AddDetails(element, form){
//	form.hide();
//	element.click(function(event,form){
//		last_details=$(this).parent().parent().prev()
//		dialog=last_details.clone().dialog({
//			
//   		close: function(event, ui) {
//   			last_details.html($(this).children().clone());
//   			$(this).dialog('destroy');
//   		}
//		});
//		
//		$("#id_created_at").removeClass('hasDatepicker');
//		dialog.find('.received').children(':first').datepicker();
//		event.preventDefault();
//	});
//}
$(document).ready(function(){
	$('select[id$=-product]').hide();
	$("#id_created_at").datepicker();
	$("#tabs").tabs();
	$('.simple-line').each(function () {
		AddEventsToLine($(this), $('#detailed-'+$(this).closest(".simple-line").attr('fff')));
	});
	
	$("#upc").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
	$("#get_ajax").click(DoAjaxRequest);
});
