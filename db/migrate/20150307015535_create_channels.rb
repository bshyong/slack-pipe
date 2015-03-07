class CreateChannels < ActiveRecord::Migration
  def change
    create_table :slack_channels do |t|
      t.string :slack_channel_id
      t.string :channel_name
      t.references :slack_room

      t.timestamps
      t.index :slack_room_id
    end
  end
end
