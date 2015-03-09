class ApiController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def test
    # send down the product slug
    payload = SlackPayload.prepare(params[:message])
    Slack::PublishMessage.perform_async(payload)

    render json: "success", status: :ok
  end
end

