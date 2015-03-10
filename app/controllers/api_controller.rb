class ApiController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :verify_auth

  def receive
    # send down the product slug
    payload = SlackPayload.prepare(params[:message])
    Slack::PublishMessage.perform_async(payload) unless payload.empty?

    render json: "success", status: :ok
  end

  def verify_auth
    auth = params.delete(:auth)
    payload = params[:message]
    body = Hash[payload.sort_by(&:first)].to_json

    timestamp = auth[:timestamp]
    prehash = "#{timestamp}#{body}"
    secret = Base64.decode64(ENV['SLACKPIPE_SECRET'])
    hash = OpenSSL::HMAC.digest('sha256', secret, prehash)
    signature = Base64.encode64(hash)

    if auth.nil? || ((Time.now.to_i - auth[:timestamp].to_i) > 30) || signature != auth[:signature]
      render json: {error: 'invalid auth'}, status: 401 and return
    end
  end

end

