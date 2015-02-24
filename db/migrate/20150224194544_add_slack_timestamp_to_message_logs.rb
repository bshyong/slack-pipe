class AddSlackTimestampToMessageLogs < ActiveRecord::Migration
  def change
    add_column :message_logs, :timestamp, :float
  end
end
