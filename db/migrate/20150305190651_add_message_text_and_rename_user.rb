class AddMessageTextAndRenameUser < ActiveRecord::Migration
  def change
    rename_column :message_logs, :user, :user_id
    add_column :message_logs, :msg_text, :text
    add_column :slack_rooms, :general_channel, :string
  end
end
