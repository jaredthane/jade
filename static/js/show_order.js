$(document).ready(function(){
	$(".show_hide_serials").click(function(e){
			$(this).closest(".simple-line").find('.serial_numbers').slideToggle( 'slow');
			e.preventDefault();
			return false;
	});
});
