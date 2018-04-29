$(document).on("ready", function() {
    $('#calendar').fullCalendar({
        events: '/exams',
        theme: "bootstrap4",
        eventColor: "#36a580",
        eventTextColor: "white",
        eventRender: function(eventObj, $el) {
            $el.popover({
                title: eventObj.title,
                content: getGetOrdinal(eventObj.semester) + " sem " + eventObj.course,
                trigger: 'hover',
                placement: 'top',
                container: 'body'
            });
        }
    });
});

function getGetOrdinal(n) {
    var s=["th","st","nd","rd"],
        v=n%100;
    return n+(s[(v-20)%10]||s[v]||s[0]);
}
