module Slack
  class InitializeRoom < Slack::Worker
    # fetches user list and sets name of general channel
    def perform(slack_room_id)
      room = SlackRoom.find(slack_room_id)
      channels = get('channels.list', {token: room.token}).fetch('channels')
      general_channel_id = channels.find{|c| c['is_general'] == true }['id']
      room.update general_channel: general_channel_id
      users = get('users.list', {token: room.token}).fetch('members', nil)

      if users
        users.each do |u|
          profile = u['profile']
          User.create(
              first_name:     profile['first_name'],
              last_name:      profile['last_name'],
              real_name:      profile['real_name'],
              slack_handle:   u['name'],
              email:          profile['email'],
              image_url:      profile['image_192'],
              slack_user_id:  u['id'],
              slack_room_id:  slack_room_id
            )
        end
      end
    end
  end
end
