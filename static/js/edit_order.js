function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/orders/new_line/",
  		data:{ upc: $("#upc").val(), num:$("#id_line_set-TOTAL_FORMS").val() },
  		success: function(data){ 
  			$('.lines').append(data);
				f=$(".details_form:last").dialog({ autoOpen: false });
  			$('.table_row:last').slideDown('slow');
  			AddEventsToLastLine();
  			IncrementFormCount();
  			$("#upc").select();
  			$('select[id$=-product]').hide();
				AddDetails($('.details:last'), f);
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
			SetTimeOnReceived($(this).next())
		} else {
			$(this).next().attr('value', '')
		}
	});
}
function AddEventsToLastLine(){
	AddDelete($('.table_cell > *'));
	AddMarkDelivered($('.is_delivered:last'));
}
function AddDetails(element, form){
	element.click(function(event){
    form.dialog('open');
		event.preventDefault();
	});
}
$(document).ready(function(){
	$('select[id$=-product]').hide();
	$("#id_created_at").datepicker();
	AddDelete($('.table_cell > *'));
	AddDetails($('.details'));
//	$(".details_form").dialog({ autoOpen: false, show: 'fade' });
	AddMarkDelivered($('.is_delivered'));
	$("#upc").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
	$("#get_ajax").click(DoAjaxRequest);
});
