function showRequest() {
  $('#busy').val('Loading...');
}
function showResponse() {
  $('#busy').val('Done.');
}
$(document).ready(function(){
	$('#uploadForm input').change(function(){
		$(this).parent().ajaxSubmit({
			beforeSubmit: function(a,f,o) {
				o.dataType = 'json';
			},
			complete: function(XMLHttpRequest, textStatus) {
				// XMLHttpRequest.responseText will contain the URL of the uploaded image.
				// Put it in an image element you create, or do with it what you will.
				// For example, if you have an image elemtn with id "my_image", then
				//  $('#my_image').attr('src', XMLHttpRequest.responseText);
				// Will set that image tag to display the uploaded image.
			},
		});
	});
//	var options = { 
//        target:        '#uploadOutput',   // target element(s) to be updated with server response 
//        beforeSubmit:  showRequest,  // pre-submit callback 
//        success:       showResponse  // post-submit callback 
// 
//        // other available options: 
//        //url:       url         // override for form's 'action' attribute 
//        //type:      type        // 'get' or 'post', override for form's 'method' attribute 
//        //dataType:  null        // 'xml', 'script', or 'json' (expected server response type) 
//        //clearForm: true        // clear all form fields after successful submit 
//        //resetForm: true        // reset the form after successful submit 
// 
//        // $.ajax options can be used here too, for example: 
//        //timeout:   3000 
//    }; 
//  
//	$('#test').submit(function() { 
//        // inside event callbacks 'this' is the DOM element so we first 
//        // wrap it in a jQuery object and then invoke ajaxSubmit 
//        $(this).ajaxSubmit(options); 
// 
//        // !!! Important !!! 
//        // always return false to prevent standard browser submit and page navigation 
//        return false; 
//    }); 


});





