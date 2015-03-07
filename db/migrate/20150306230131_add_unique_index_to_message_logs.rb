class AddUniqueIndexToMessageLogs < ActiveRecord::Migration
  def change
    add_index :message_logs, [:timestamp, :channel], :unique => true
  end
end
