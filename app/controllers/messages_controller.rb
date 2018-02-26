class MessagesController < ApplicationController
  def create
    message = Message.new(message_params)
    message.user = current_user
    if message.save
      ActionCable.server.broadcast 'messages',
        message: message.content,
        role: message.user.role,
        user: message.user.name,
        id: message.room.id
      head :ok
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
