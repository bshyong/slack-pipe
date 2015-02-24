class PageController < ApplicationController

  def index
    render json: [MessageLog.joins(:slack_room)
                           .group('slack_rooms.name')
                           .count
                           .merge({last_message_at: MessageLog.maximum(:created_at)})] 
  end
end
