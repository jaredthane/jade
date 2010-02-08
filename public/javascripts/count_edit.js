onerror=handleErr;
function handleErr(msg,url,l) {
	alert("There was an error on this page.\n\nError: " + msg + "\nURL: " + url + "\nLine: " + l + "\n\nClick OK to continue.\n\n");
	return true;
}
function check_box(e) {
  e.prev(":check_box").attr( "checked", "true" );
  e.closest(".line").slideUp("slow");
}
function submit(form_name){
	$("#"+form_name).submit();
}
function post_count(){
	$('#submit_type').val("post")
  $('#counts_form').submit();
}
function calc_dif(e) {
	// $(this).parent().prev().children(':first')           <--- qty
//	$(this).prev('#qty')
//	// $("this").prev().prev()  <--- cost
//	$(this).prev('#cost')
//	// $("this")										<--- count
//	$(this)
	//test = (parseFloat(e.value) - parseFloat(e.previousSibling.previousSibling.value)) * parseFloat(e.previousSibling.previousSibling..previousSibling.previousSibling).toFixed(2);
	qty= parseFloat(e.parent().prev().children(':first').val());
	cost= parseFloat(e.parent().prev().prev().val());
	count= parseFloat(e.val());
	//x = e.parentNode.nextSibling.nextSibling.childNodes[0].id
	//alert(x);
	if (qty){
		e.parent().next().next().children(':first').val('$'+((count-qty)*cost).toFixed(2))
	}
}

function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/lines/new",
  		data:{ bar_code: $("#bar_code_field").val(), client_name: $('#clients_lookup').val(), order_type_id:$('#order_type_id').val(), order_type_id:5},
  		success: function(data){ 
  			var d = $('<div/>').append(data);
  			error=$('.error', d);
  			if (error.length>0){
  				$('#lines_errors:visible').slideUp('slow', function(){$(this).slideDown('slow')});
  				$('#lines_errors:hidden').append(error).slideDown('slow');
  			} else {
  				$('#lines_errors:visible').slideUp('slow',delete_errors);
  			}
  			$('.line', d).appendTo('#lines').hide().slideDown('slow',select_serial);
				$(".serial:last").keydown(function(e){
					if (e.keyCode == 13) {
					 	 $('#bar_code_field').select(); 
						 return false;
					 }
				});
			},
		});
}
function delete_errors(){
	$('.error').remove();
}
function select_serial() {
  $(".serial:last").select(); 
}
//function DeleteHiddenLines(){
//	$('.line:hidden').remove();
//}
$(document).ready(function(){
	$('#add_new_line').hide();
	$('#bar_code_form').show();
	$('#lines_errors').hide();
	//Setup	date picker
	$.datepicker.regional['es']
	$(".datepicker").datepicker();
	// Prepare lookups
	$("#client_lookup").autocomplete("/clients.js",{matchSubset:0, autoFill:1}); 
	$("#vendor_lookup").autocomplete("/vendors.js",{matchSubset:0, autoFill:1}); 
	$("#bar_code_field").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
});
