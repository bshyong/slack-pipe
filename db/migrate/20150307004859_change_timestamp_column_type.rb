class ChangeTimestampColumnType < ActiveRecord::Migration
  def change
    change_column :message_logs, :timestamp, :bigint
  end
end
