class User < ActiveRecord::Base
  belongs_to :slack_room

  validates :email, uniqueness: { scope: :slack_room_id,
                                  case_sensitive: false }

end
