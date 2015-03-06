class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :real_name
      t.string :slack_handle
      t.string :email
      t.string :image_url
      t.string :slack_user_id
      t.references :slack_room

      t.timestamps
    end
  end
end
