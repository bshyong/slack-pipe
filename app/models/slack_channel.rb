class SlackChannel < ActiveRecord::Base
  belongs_to :slack_room

end
