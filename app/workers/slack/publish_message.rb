module Slack
  class PublishMessage < Slack::Worker
    include Sidekiq::Worker

    def perform(payload)
      post('chat.postMessage', payload)
    end
  end
end
