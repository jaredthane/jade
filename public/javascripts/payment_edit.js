function calculate_total() {
	$("total_paid").value=$("presented_field").value-$("returned_field").value;
	$("debt_field").value=$("total_price").value-$("presented_field").value+$("returned_field").value;
	if ($("presented_field").value-$("total_price").value < 0){
		$("change_div").hide();
		$("debt_div").show();
	} else {
		$("change_div").show();
		$("debt_div").hide();
	}
	$("recommended_change").value=$("presented_field").value-$("total_price").value;
}
