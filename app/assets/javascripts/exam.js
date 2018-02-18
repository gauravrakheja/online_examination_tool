var displayOptions = function(){
	$('.objective:checked').each(function(){
		$(this).parents('.nested-fields').find('.options-for-questions').slideDown();
	});
	$('.subjective:checked').each(function(){
		$(this).parents('.nested-fields').find('.options-for-questions').slideUp();
	});
};

$(document).on("change", function(){
	displayOptions();
});