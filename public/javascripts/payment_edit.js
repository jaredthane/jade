function calculate_total() {
	$("#total_paid").val((parseFloat($("#presented_field").val()) - parseFloat($("#returned_field").val())).toFixed(2));
	$("#returned_field").val((parseFloat($("#presented_field").val())-parseFloat($("#total_price").val()) + parseFloat($("#other_payments").val())).toFixed(2));
}



