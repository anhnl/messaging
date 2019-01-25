class Apis::V1::ReceiverController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle_message
    response = MessageHandler.new(message_params).call
    render json: { response: response }
  end

  def update_status
    if updated_message.present?
      updated_message.update(message_status: Message.message_statuses[new_status])
    end
    render json: :ok
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
    when 'invalid' then 'invalid_number'
    end
  end

  def message_params
    params.permit(:to_number, :message)
  end
end