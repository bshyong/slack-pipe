class PublishToAsm < FaradayClient
  include Sidekiq::Worker

  def connection
    Faraday.new(url: ENV['ASM_ENDPOINT']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  :net_http
    end
  end

  # generate HMAC headers here, for every request before posting

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


