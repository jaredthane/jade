function DoAjaxPayOff(row, order){
	url='/orders/' + order + '/pay_off';
	row.slideUp("slow");
	$.ajax({
		type: 'POST',
  	url: url,
	});
}
function ProcessSubscription(sub){
	url='/subscription/' + sub + '/process';
	$.ajax({
		type: 'POST',
  	url: url,
  	success: function(data){ 
  			var d = $('<div/>').append(data);
  			error=$('.error', d);
  			$('.line', d).appendTo('#lines').hide().slideDown('slow',select_serial);
  	},
	});
}
