function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/orders/new_line/",
  		data:{ upc: $("#upc").val(), num:$("#id_line_set-TOTAL_FORMS").val() },
  		success: function(data){ 
  			$('.lines').append(data);
  			$('.table_row:last').slideDown('slow');
  			AddEventsToLine($('.line:last'));
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
		$(this).closest(".line").slideUp("slow");
	});
}
function AddMarkDelivered(e){
	e.click( function(){
		if ($(this).is(':checked')) {
			SetTimeOnReceived($(this).closest('.line').find('.received').children(':first'))
//			$(this).closest('.line').find('.received').children(':first').attr('value', '7')
		} else {
			$(this).closest('.line').find('.received').children(':first').attr('value', '')
		}
	});
}
function AddEventsToLine(line){
	AddDelete(line.find('.table_cell'));
	AddMarkDelivered(line.find('.is_delivered'));
	AddDetails(line.find('.details'), line.find('.details_form'));
	if (line.find('.received').children(':first').attr('value')!=''){
		line.find('.is_delivered').attr('checked',true);
	}
}
function AddDetails(element, form){
	form.hide();
	element.click(function(event,form){
		last_details=$(this).parent().parent().prev()
		dialog=last_details.clone().dialog({
   		close: function(event, ui) {
   			last_details.html($(this).children().clone());
   			$(this).dialog('destroy');
   		}
		});
		
		dialog.find('.received').children(':first').datepicker();
		event.preventDefault();
	});
}
$(document).ready(function(){
	$('select[id$=-product]').hide();
	$("#id_created_at").datepicker();
	$('.line').each(function () {
		AddEventsToLine($(this));
	});
//	AddDelete($('.table_cell > *'));
//	AddDetails($('.details'));
//	$(".details_form").dialog({ autoOpen: false, show: 'fade' });
//	AddMarkDelivered($('.is_delivered'));
	$("#upc").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
	$("#get_ajax").click(DoAjaxRequest);
});
