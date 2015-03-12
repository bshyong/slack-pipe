class CreateChatRooms < ActiveRecord::Migration
  def change
    # TODO refactor to use chat rooms instead of slackrooms
    create_table :chat_rooms do |t|
      t.integer :slack_room_id
      t.string :channel
      t.string :name

      t.timestamps
    end

    add_column :message_logs, :chat_room_id, :integer
    add_index :message_logs, :chat_room_id

    SlackRoom.each do |sr|
      # create chat rooms for each channel
      chat_room = sr.chat_rooms.create(channel: sr.general_channel, name: sr.name)
      # associate message logs with chat rooms
      sr.message_logs.each do |m|
        m.update_column :chat_room_id, chat_room.id
      end
    end
  end
end
