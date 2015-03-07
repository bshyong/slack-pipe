class AddPublishedAtToMessageLogs < ActiveRecord::Migration
  def change
    add_column :message_logs, :published_at, :datetime
  end
end
