class RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      respond_to do |format|
        format.html { redirect_to @room }
        format.js
      end
    else
      respond_to do |format|
        flash[:notice] = {error: ["a room with this title already exists"]}
        format.html { redirect_to new_room_path }
        format.js { render template: 'rooms/room_error.js.erb'} 
      end
    end
  end

  def index
    @q = Room.ransack(params[:q])
    @rooms = @q.result.order(created_at: :desc)
  end

  def show
    @room = Room.find(params[:id])
    @message = Message.new
  end

  private

  def room_params
    params.require(:room).permit(:title, :subject, :name)
  end
end