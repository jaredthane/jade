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
Event.addBehavior({
	'body' : function() {
		$('add_new_line').hide();
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
