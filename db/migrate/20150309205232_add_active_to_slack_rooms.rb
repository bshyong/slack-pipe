class AddActiveToSlackRooms < ActiveRecord::Migration
  def change
    add_column :slack_rooms, :active, :boolean, default: false
  end
end
