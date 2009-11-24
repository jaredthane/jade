function calculate_total() {
	$("#total_paid").val((parseFloat($("#presented_field").val()) - parseFloat($("#returned_field").val())).toFixed(2));
	$("#debt_field").val((parseFloat($("#total_price").val())     - parseFloat($("#presented_field").val()) + parseFloat($("returned_field").val()) - parseFloat($("paid").val())).toFixed(2));       
	if ($("#debt_field").val() > 0){
		$("#change_div").hide();
		$("#debt_div").show();
	} else {
		$("#change_div").show();
		$("#debt_div").hide();
	}
	$("#recommended_change").val((parseFloat($("#presented_field").val())-parseFloat($("#total_price").val()) + parseFloat($("#paid").val())).toFixed(2));
}
