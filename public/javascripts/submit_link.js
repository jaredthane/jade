function submit(form_name){
	$("#"+form_name).submit();
}
function submit_class(form_name){
	$("."+form_name).submit();
}
function submit_report(form_name){
	$("#pdf").val(1);
	$("#"+form_name).submit();
}
function submit_index(form_name){
	$("#pdf").val(0);
	$("#"+form_name).submit();
}
function generate_orders(){
	$("#generate").val(1);
	$("#inventory_form").submit();
}
function AjaxPrint(url, data){
	$.ajax({
			type: 'POST',
  		url: url,
  		data: data,
  		success: function(data){ 
  			data.print();
			},
		});
}
