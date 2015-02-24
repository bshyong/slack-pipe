class CreateMessageLogs < ActiveRecord::Migration
  def change
    create_table :message_logs do |t|
      t.string :user
      t.string :channel
      t.string :msg_type
      t.string :msg_subtype
      t.references :slack_room

      t.timestamps
    end
  end
end
