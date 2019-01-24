class Apis::V1::ReceiverController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle_message
    response = save_and_send_to_provider
    render json: { response: response }
  end

  def update_status
    if updated_message.present?
      updated_message.update(message_status: Message.message_statuses[new_status])
    end
  end

  private

  def updated_message
    @_updated_message ||= Message.find_by(provider_message_id: params[:message_id])
  end

  def received_status
    @_received_status ||= params[:status]
  end

  def new_status
    case received_status
    when 'delivered' then 'delivered'
    when 'failed' then 'failed'
    when 'invalid' then 'invalid_message'
    end
  end

  def save_and_send_to_provider
    msg = Message.new(message_params.merge(message_status: Message.message_statuses['created']))
    response = {}

    if msg.save
      payload = JSON.parse(HTTParty.post(ENV['provider_1'], body: {
        to_number: to_number,
        message: message,
        callback_url: callback_url,
      }).body).symbolize_keys

      if payload.has_key?(:message_id)
        msg.update!(provider_message_id: payload[:message_id])
        response = { success: payload[:message_id] }
      else
        response = { error: payload[:message] }
      end
    else
      response = { error: msg.errors.full_messages }
    end

    response
  end

  def message_params
    params.permit(:to_number, :message)
  end

  def message
    @_message ||= params[:message]
  end

  def to_number
    @_to_number ||= params[:to_number]
  end

  def callback_url
    root_url = "http://d26d12cd.ngrok.io/apis/v1"
    "#{root_url}/update_status/"
  end
end