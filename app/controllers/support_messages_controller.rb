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

  def search
    head :forbidden and return if !@login.has_capability?('user')
    conditions = []

    search_string = params[:search_term] || ''
    index = params[:index].to_i.positive? ? params[:index].to_i : 1
    page_size = params[:page_size].to_i.positive? ? params[:page_size].to_i : 20
    conditions << ['LOWER(sender) LIKE ?', "%#{search_string}%"] if search_string != ''

    search_string_by_help_desk = params[:search_term_by_help_desk] || ''
    index = params[:index].to_i.positive? ? params[:index].to_i : 1
    page_size = params[:page_size].to_i.positive? ? params[:page_size].to_i : 20

    if search_string_by_help_desk != ''
      conditions << ['LOWER(updated_by) LIKE ?', "%#{search_string_by_help_desk}%"]
    end

    if !params[:start_date_registration].nil? && !params[:end_date_registration].nil?
      start_date = Date.parse(params[:start_date_registration])
      end_date = Date.parse(params[:end_date_registration])
      conditions << ['created_at BETWEEN ? AND ?', start_date.beginning_of_day, end_date.end_of_day]
    end

    if !params[:start_date_login].nil? && !params[:end_date_login].nil?
      start_date = Date.parse(params[:start_date_login])
      end_date = Date.parse(params[:end_date_login])
      conditions << [
        'updated_at BETWEEN ? AND ?',
        start_updated_at_date.beginning_of_day,
        end_updated_at_date.end_of_day
      ]
    end

    support_messages =
      SupportMessage.where(
        conditions.map { |condition| condition.shift }.join(' AND '),
        *conditions.flatten
      )

    @support_messages = support_messages.limit(page_size).offset((index - 1) * page_size)
    @total_messages = SupportMessage.count
    render :index
  end

  private

  def support_message_attributes
    params
      .require(:support_message)
      .permit(:id, :date, :subject, :message, :comment, :sender, :status, :updated_by, :user_id)
  end
end
