module Slack
  class PublishMessage < Slack::Worker
    include Sidekiq::Worker

    # icon_url (display image)
    # username (display handle)


    def perform(payload)
      payload = {
        text: "this is a test &amp; #{Time.now}",
        channel: "C03TTCR5P",
        token: "xoxp-2170858457-2731791470-3818967378-dc1f57"
      }
      post('chat.postMessage', payload)
    end
  end
end
