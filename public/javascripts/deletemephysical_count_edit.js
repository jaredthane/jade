onerror=handleErr;
function handleErr(msg,url,l) {
	alert("There was an error on this page.\n\nError: " + msg + "\nURL: " + url + "\nLine: " + l + "\n\nClick OK to continue.\n\n");
	return true;
}
function post_count(){
	$('#submit_type').val("post")
  $('#counts_form').submit();
}
function set_client_name(value){
		$("client_name").value=value
}
function calc_dif(e) {
	// $("this").previous           <--- qty
	// $("this").previous.previous  <--- cost
	// $("this")										<--- count
	//test = (parseFloat(e.value) - parseFloat(e.previousSibling.previousSibling.value)) * parseFloat(e.previousSibling.previousSibling..previousSibling.previousSibling).toFixed(2);
	qty= parseFloat(e.parentNode.previousSibling.previousSibling.childNodes[1].value);
	cost= parseFloat(e.parentNode.previousSibling.previousSibling.previousSibling.previousSibling.value);
	count= parseFloat(e.value);
	//x = e.parentNode.nextSibling.nextSibling.childNodes[0].id
	//alert(x);
	e.parentNode.nextSibling.nextSibling.nextSibling.nextSibling.childNodes[0].value = '$'+((count-qty)*cost).toFixed(2)
}
//function disableEnterKey(e){
//     var key;
//     if(window.event)
//          key = window.event.keyCode;     //IE
//     else
//          key = e.which;     //firefox
//     if(key == 13) {
//         
//         //alert("caught enter");
//        return false;
//     } else {
//        return true;
//     }
//}
//function select_serial(){
//  $$(".serial").last().select(); 
//}
//Event.addBehavior({
//  'body' : function() {
//    $('add_new_line').hide();
//  },
//  'form:keydown' : Event.delegate({
//    '#serial': function(e) {
//       if ( disableEnterKey(e) ){
//         return true;
//       } else {
//          $('bar_code_field').select();
//         return false;
//       }
//     }
//  }),
//  '#bar_code_form' : Remote.Form
//});
function DoAjaxRequest(){
  $.ajax({
      type: 'POST',
      url: "/lines/new",
      data:{ bar_code: $("#bar_code_field").val(), client_name: $('#clients_lookup').val(), order_type_id:5},
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
function check_box(e) {
  e.prev(":check_box").attr( "checked", "true" );
  e.closest(".line").slideUp("slow");
}
function DeleteHiddenLines(){
  $('.line:hidden').remove();
}
$(document).ready(function(){
  $('#add_new_line').hide();
  //Setup  date picker
  $.datepicker.regional['es']
  $(".datepicker").datepicker();
  $("#bar_code_field").keydown(function(e){
    if (e.keyCode == 13) {
      DoAjaxRequest();
      e.preventDefault();
      return false;
    }
  });
});
