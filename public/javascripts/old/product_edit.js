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
	'form:keydown' : Event.delegate({
  	'#upc': function(e) {
       var el = e.element();
       return disableEnterKey(e);
     }
	})
});