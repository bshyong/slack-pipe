class AddColumnsToSlackRoom < ActiveRecord::Migration
  def change
    add_column :slack_rooms, :publish_to_asm, :boolean, default: true
    add_column :slack_rooms, :publish_to_slack, :boolean, default: true
  end
end
