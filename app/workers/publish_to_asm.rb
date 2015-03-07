class PublishToAsm < FaradayClient
  include Sidekiq::Worker

  def connection
    Faraday.new(url: 'http://localhost:5000/api/sb') do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  :net_http
    end
  end

  # payload = {
  #   message: SlackPipe message log
  #   user: SlackPipe user
  #   product: assembly product slug
  # }
  def perform(payload)

    post('', payload)
    # send the text, user email, product slug, slack user handle
  end
end


