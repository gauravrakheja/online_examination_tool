Turbolinks.setProgressBarDelay(1);

var hideStudentFields = function(){
    if ($('#user_role').val() == "student"){
        $('#user_roll_number').parent().slideDown();
        $('#user_course').parent().slideDown();
        $('#user_semester').parent().slideDown();
    }
    else{
        $('#user_roll_number').parent().slideUp();
        $('#user_course').parent().slideUp();
        $('#user_semester').parent().slideUp();
    }
};

$(document).on("turbolinks:load", function(){
	hideStudentFields();
	$('#new_user').on("change", function(){
		hideStudentFields();
	});
});