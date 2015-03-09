class AddActiveToMessageLogs < ActiveRecord::Migration
  def change
    add_column :message_logs, :active, :boolean, default: false
  end
end
