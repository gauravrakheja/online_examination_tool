$(document).on("turbolinks:load",function(){
	if(/attemps\/new/.test(window.location.href)){
		var x = setInterval(function() { showTimer(); }, 100);
	};
});

function showTimer(){
  // Get date and time
  var date = $('#time').attr('value')
  var countDownDate = new Date(date).getTime();
  var now = new Date().getTime();
  // Find the distance between now an the count down date
  var distance = countDownDate - now;
  // Time calculations for days, hours, minutes and seconds
  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((distance % (1000 * 60)) / 1000);
  document.getElementById("demo").innerHTML = days + "d " + hours + "h "
  + minutes + "m " + seconds + "s ";
  //do something when time is up
  if (distance < 0) {
    clearInterval(x);
    document.getElementById("demo").innerHTML = "Time is Over";
    submitAttempt();
  };
};


function submitAttempt() {
	$('#new_attempt').submit();
    alert("Thank You For Your Attempt");
}

// Update the count down every 1 second
