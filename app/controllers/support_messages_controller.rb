class SupportMessagesController < ApplicationController
  def index
    if !@login.has_capability?('support')
      render json: {
               message: 'support_messages_controller::index: not allowed'
             },
             status: :forbidden
    else
      render json: {
               messages: SupportMessage.all.order(created_at: :desc),
               users: User.where('capabilities LIKE ?', '%support%').pluck(:email)
             }
    end
  end

  def create
    @support_message = SupportMessage.new(support_message_attributes)
    if @support_message.save
      UserMailer
        .with(
          email: @login.email,
          body: support_message_attributes['message'],
          subject: "#{support_message_attributes['subject']} von #{@login.email}",
          support_addresses: User.where('capabilities LIKE ?', '%support%').pluck(:email)
        )
        .support
        .deliver_later

      render json: @support_message
    else
      render json: {
               message: "support_message_controller::create: record couldn't be created"
             },
             status: :unprocessable_entity
    end
  end

  def update
    message = SupportMessage.find(params[:id])
    if !message.nil? && message.update(support_message_attributes)
      render json: { message: message }
    else
      head 304
    end
  end

  def destroy; end

  def edit; end

  private

  def support_message_attributes
    params
      .require(:support_message)
      .permit(:id, :date, :subject, :message, :comment, :sender, :status, :updated_by, :user_id)
  end
end
