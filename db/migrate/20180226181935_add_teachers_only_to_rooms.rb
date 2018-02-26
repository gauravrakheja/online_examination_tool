class AddTeachersOnlyToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :teachers_only, :boolean
  end
end
