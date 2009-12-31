function calculate_change() {
	change = (parseFloat($("#presented_field").val())-parseFloat($("#total_price").val()) + parseFloat($("#other_payments").val())).toFixed(2)
	if (change < 0) {
	$("#returned_field").val(0);
	}else {
	$("#returned_field").val(change);
	}
	calculate_total();
}
function calculate_total() {
	$("#total_paid").val((parseFloat($("#presented_field").val()) - parseFloat($("#returned_field").val())).toFixed(2));
}
