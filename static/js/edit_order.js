function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/orders/new_line/",
  		upc: $("#upc").val(),
  		data:{ upc: $("#upc").val(), num:$("#id_line_set-TOTAL_FORMS").val() },
  		success: function(data){ $('.lines').append(data); $('.line:last').hide().slideDown('slow');AddEventsToLastLine();IncrementFormCount();},
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
		$(this).prev().attr('checked', true)
		$(this).closest(".line").slideUp("slow");
		e.preventDefault();
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
	AddDelete($('.delete:last'));
	AddMarkDelivered($('.is_delivered:last'));
}
$(document).ready(function(){
	AddDelete($('.delete'));
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








