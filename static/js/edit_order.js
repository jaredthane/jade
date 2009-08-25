function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/orders/line/new/",
  		upc: $("#upc").val(),
  		data:{ upc: $("#upc").val() },
  		success: function(data){ $('.lines').append(data); $('.line:last').hide().slideDown('slow');MakeDelete();},
  		error: function(){alert("An error has occurred. Please try again.");},
		});
}
function MakeDelete(){
	$('.delete:last').click( function(){
		$(this).closest(".line").slideUp("slow", function(){$(this).closest(".line").remove()});
	});
}
$(document).ready(function(){
	MakeDelete();
	$("#upc").keydown(function(e){
		if (e.keyCode == 13) { 
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
	$("#get_ajax").click(DoAjaxRequest);
});
