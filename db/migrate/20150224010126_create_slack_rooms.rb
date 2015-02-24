class CreateSlackRooms < ActiveRecord::Migration
  def change
    create_table :slack_rooms do |t|
      t.string :handle
      t.string :token
      t.string :name

      t.timestamps
    end
  end
end
