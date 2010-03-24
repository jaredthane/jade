function calculate_total() {
	$("total_paid").value=(parseFloat($("presented_field").value) - parseFloat($("returned_field").value)).toFixed(2);
	$("debt_field").value=(parseFloat($("total_price").value)     - parseFloat($("presented_field").value) + parseFloat($("returned_field").value) - parseFloat($("paid").value)).toFixed(2);       
	if ($("debt_field").value > 0){
		$("change_div").hide();
		$("debt_div").show();
	} else {
		$("change_div").show();
		$("debt_div").hide();
	}
	$("recommended_change").value=(parseFloat($("presented_field").value)-parseFloat($("total_price").value) + parseFloat($("paid").value)).toFixed(2);
}
