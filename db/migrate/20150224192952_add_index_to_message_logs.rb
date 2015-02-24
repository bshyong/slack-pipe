class AddIndexToMessageLogs < ActiveRecord::Migration
  def change
    add_index :message_logs, :slack_room_id
  end
end
