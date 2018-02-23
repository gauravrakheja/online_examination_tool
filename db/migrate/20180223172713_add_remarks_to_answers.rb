class AddRemarksToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :remarks, :string
  end
end
