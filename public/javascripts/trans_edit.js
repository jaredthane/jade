function DoAjaxRequest(){
	$.ajax({
		type: 'POST',
		data: {account_search: $("#account_search").val()},
		url: "/posts/new",
		success: function(html){
			$("#posts").append(html).hide().slideDown('slow');
		}
	});
}
$(document).ready(function(){
		//Setup	date picker
	$.datepicker.regional['es']
	$(".datepicker").datepicker();
});
