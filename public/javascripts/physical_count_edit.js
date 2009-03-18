onerror=handleErr;
function handleErr(msg,url,l) {
	alert("There was an error on this page.\n\nError: " + msg + "\nURL: " + url + "\nLine: " + l + "\n\nClick OK to continue.\n\n");
	return true;
}
function post_count(){
	$('submit_type').value = "post"
	$('counts_form').submit();
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
	cost= parseFloat(e.parentNode.previousSibling.previousSibling.previousSibling.previousSibling.childNodes[1].value);
	count= parseFloat(e.value);
	//x = e.parentNode.nextSibling.nextSibling.childNodes[0].id
	//alert(x);
	e.parentNode.nextSibling.nextSibling.childNodes[0].value = '$'+((count-qty)*cost).toFixed(2)
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
function select_serial(){
	$$(".serial").last().select(); 
}
Event.addBehavior({
	'body' : function() {
		$('add_new_line').hide();
//		$('.applied').value='No';
//		if ($('bar_code_field').select())
//		if ($('order_type_field').value == 'sales' or $('order_type_field').value == 'internal') {
//			$("client_name").value='_cost_'
//		}
  },
  'form:keydown' : Event.delegate({
  	'#serial': function(e) {
       if ( disableEnterKey(e) ){
         return true;
       } else {
       	 $('bar_code_field').select(); 
	       return false;
       }
     }
	}),
	'#bar_code_form' : Remote.Form
});
