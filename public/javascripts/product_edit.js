$(document).ready(function(){
	$("#upc").keydown(function(e){
		if (e.keyCode == 13) {
			e.preventDefault();
			return false;
		}
	});
	$("#vendor_lookup").autocomplete("/vendors.js"); 
	$("#unit_lookup").autocomplete("/units.js"); 
});

