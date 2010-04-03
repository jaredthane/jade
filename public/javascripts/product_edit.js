function check_box(e) {
  e.prev(":check_box").attr( "checked", "true" );
  e.closest(".warranty").slideUp("slow");
}
$(document).ready(function(){
	$('#name').select();
});
