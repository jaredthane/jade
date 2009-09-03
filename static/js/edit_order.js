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
  			AddEventsToLine($('.simple-line'),$('.detailed-line'));
  			IncrementFormCount();
  			$("#upc").select();
  			$('select[id$=-product]').hide();
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
function IncrementFormCount(){
		count=$("#id_line_set-TOTAL_FORMS");
		count.attr('value', parseInt(count.attr('value'))+1);
}
function AddDelete(e){
	e.click( function(e){
		$(this).closest(".simple-line").slideUp("slow");
		$('#tabs').find('#detailed-'+$(this).closest(".simple-line").attr('fff')).hide();
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
	AddDelete(simple.find('.delete_cell'));
	AddMarkDelivered(simple.find('.is_delivered'));
//	if (simple.find('.received').children(':first').attr('value')!=''){
//		simple.find('.is_delivered').attr('checked',true);
//	}
//	simple.find('.received').children(':first').datepicker();
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
//	$("#id_created_at").datepicker();
	$("#tabs").tabs();
	$('.line').each(function () {
		AddEventsToLine($(this));
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
