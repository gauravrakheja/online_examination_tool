var displayOptions = function(){
	$('.objective:checked').each(function(){
		$(this).parents('.nested-fields').find('.options-for-questions').slideDown();
		$(this).parents('.nested-fields').find('.correct-option-field').slideDown();
	});
	$('.subjective:checked').each(function(){
		$(this).parents('.nested-fields').find('.options-for-questions').slideUp();
		$(this).parents('.nested-fields').find('.correct-option-field').slideUp();
	});
};

$(document).on("change", function(){
	displayOptions();
});