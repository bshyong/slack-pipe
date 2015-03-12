class CreateChatRooms < ActiveRecord::Migration
  def change
    # TODO refactor to use chat rooms instead of slackrooms
    create_table :chat_rooms do |t|
      t.integer :slack_room_id
      t.string :channel
      t.string :name

      t.timestamps
    end
  end
end
