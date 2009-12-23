function DoAjaxRequest(){
	$.ajax({
		type: 'POST',
		url: "/posts/new",
		success: function(html){
			$("#posts").append(html).hide().slideDown('slow');
		}
	});
}
