$(document).on("turbolinks:load",function(){
	if(/attemps\/new/.test(window.location.href)){
		var duration = $('#duration').attr('value');
		duration = duration * 60000
		duration = parseInt(duration);
	    setTimeout(function() { submitAttempt(); },duration);
		var x = setInterval(function() {
		  // Get todays date and time
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
		  // Display the result in the element with id="demo"
		  document.getElementById("demo").innerHTML = days + "d " + hours + "h "
		  + minutes + "m " + seconds + "s ";
		  // If the count down is finished, write some text 
		  if (distance < 0) {
		    clearInterval(x);
		    document.getElementById("demo").innerHTML = "EXPIRED";
		  }
		}, 100);
	};
});

function submitAttempt() {
	$('#new_attempt').submit();
    alert("Thank You For Your Attempt");
}

// Update the count down every 1 second
