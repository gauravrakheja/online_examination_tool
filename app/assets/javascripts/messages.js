App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    $('#message_content').val('');
    var id = '#messages_' + data.id;
    console.log(id);
    return $(id).prepend(this.renderMessage(data));
  },
  renderMessage: function(data) {
  	return "<div class='card'><h5 class='card-header'>" + 
  	  	data.user  + "("+ data.role + ")</h5>" +
  	  	"<div class='card-body'>" + 
  	    	"<h5 class='card-title'>" + data.message + "</h5>" +
  	  	"</div></div>"
  }
});