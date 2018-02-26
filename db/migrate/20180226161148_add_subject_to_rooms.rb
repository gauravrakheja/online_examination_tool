class AddSubjectToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :subject, :string
  end
end
