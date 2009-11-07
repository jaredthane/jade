onerror=handleErr;
function handleErr(msg,url,l) {
	alert("There was an error on this page.\n\nError: " + msg + "\nURL: " + url + "\nLine: " + l + "\n\nClick OK to continue.\n\n");
	return true;
}
function set_client_name(value){
		$("client_name").value=value
}
function disableEnterKey(e){
     var key;
     if(window.event)
          key = window.event.keyCode;     //IE
     else
          key = e.which;     //firefox
     if(key == 13) {
     		
     		//alert("caught enter");
        return false;
     } else {
      	return true;
     }
}
function findValue(li) {
if( li == null ) return alert("No match!");

var sValue = li.selectValue;

//alert("The value you selected was: " + sValue);
}
function selectItem(li) {
findValue(li);
}

function formatItem(row) {
return row[0];
}

function lookupVendor(){
var oSuggest = $("#vendor_lookup")[0].autocompleter;
oSuggest.findValue();
return false;
}
function lookupClient(){
var oSuggest = $("#client_lookup")[0].autocompleter;
oSuggest.findValue();
return false;
}
function select_serial(){
	$$(".serial").last().select(); 
}
function DoAjaxRequest(){
	$.ajax({
			type: 'POST',
  		url: "/lines/new",
  		data:{ bar_code: $("#bar_code_field").val(), client_name: $('#clients_lookup').val(), order_type_id:$('#order_type_id').val()},
  		success: function(data){ 
  			var d = $('<div/>').append(data);
//  			$('.error', d).replaceAll('.error_line').slideUp('slow').slideDown('slow');
  			error=$('.error', d);
  			$('.error_line').slideUp('slow').replaceWith(error, d).slideDown('slow');
//  			$('.error', d).replaceAll('.error_line').slideUp('slow').slideDown('slow');
  			$('.line', d).appendTo('#lines').hide().slideDown('slow',select_serial);
  			
  			
//  			$("#lines").append(data);
//  			AddEventsToLine($('.simple-line:last'), $('.detailed-line:last'));
  			
			},
//  		error: function(){alert("An error has occurred. Please try again.");},
		});
}
function select_serial() {
  $(".serial:last").select(); 
}
function AddDeleteLine(e){
	e.click( function(e){
		$(this).closest(".line").slideUp("slow").remove();
	});
}

function AddEventsToLine(line){
	AddDeleteLine(line.find('.delete_line_cell'));
}
function DeleteHiddenLines(){
	$('.line:hidden').remove();
}
$(document).ready(function(){
	$('#add_new_line').hide();
	$('#bar_code_form').show();
	
	$("#datepicker").datepicker();
	$("#clients_lookup").autocomplete("/clients.js"); 
	$("#vendor_lookup").autocomplete("/vendors.js"); 
	$('line').each(function () {
		AddEventsToLine($(this), $('#detailed-'+$(this).closest(".simple-line").attr('fff')));
	});
	
	$("#serial").keydown(function(e){
		if ( disableEnterKey(e) ){
       return true;
     } else {
     	 $('bar_code_field').select(); 
       return false;
     }
	});
	$("#bar_code_field").keydown(function(e){
		if (e.keyCode == 13) {
			DoAjaxRequest();
			e.preventDefault();
			return false;
		}
	});
	$("#get_ajax").click(DoAjaxRequest);
});
//Event.addBehavior({
//	'body' : function() {
//		$('add_new_line').hide();
////		if ($('order_type_field').value == 'sales' or $('order_type_field').value == 'internal') {
////			$("client_name").value='_cost_'
////		}
//  },
//  'form:keydown' : Event.delegate({
//  	'#serial': function(e) {
//       if ( disableEnterKey(e) ){
//         return true;
//       } else {
//       	 $('bar_code_field').select(); 
//	       return false;
//       }
//     }
//	}),
//	'#bar_code_form' : Remote.Form
//});
