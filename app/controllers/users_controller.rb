class UsersController < ApplicationController
  before_action :set_user,
                except: %i[
                  create
                  destroy_self
                  get_core_data
                  index
                  index_paginated
                  recover
                  register
                  search
                  show
                  statistics
                  get_classbook_info
                  recovery_notification
                  recovery_key_verification
                  delete_used_recovery_key
                ]

  skip_before_action :set_login,
                     only: %i[
                       create
                       register
                       recover
                       recovery_notification
                       recovery_key_verification
                       delete_used_recovery_key
                     ]

  #GET /start
  #GET /users/:id
  def show
    headers['Cache-Control'] = 'no-store, must-revalidate'
    respond_to do |format|
      format.text do
        send_file @login.as_zip,
                  filename: 'Levumi_Export_' + DateTime.now.strftime('%Y_%m_%d') + '.zip',
                  type: 'application/zip'
      end
      format.html {}
      format.json {}
    end
  end

  #GET /users/:id/edit
  def edit; end

  #PUT /users/:id
  def update
    # "Normales" Update
    res = @user.update(user_attributes)
    if !res
      render json: { message: 'Validation failed', errors: @user.errors }, status: 400
    else
      if (@login.id == @user.id)
        #Eigenes Update, ggf. keys Recodieren
        if (params.has_key?(:user) && params.has_key?(:keys) && !params[:keys].blank?)
          todo = JSON.parse(params[:keys]) || [] #Gesendet werden (key, value)-Paare der keys für GroupShare-Objekte.
          todo.each do |k, v|
            ga = GroupShare.where(user: @login, group_id: k).first
            unless ga.nil? || ga.key.nil? || ga.key.blank?
              ga.key = v
              ga.save
            end
          end
        end
        render json: @user # return user to update view
      else
        @users = User.all #Update für anderen Nutzer aus der Benutzerverwaltung => Tabelle wird neu gerendert
        head :ok
      end
    end
  end

  def user_mail
    if @login.has_capability?('admin')
      #Send mail to all users
      if params.has_key?('teacher')
        User
          .where(account_type: 0)
          .each { |u| UserMailer.with(user: u, body: params['text']).notify.deliver_later }
      end
      if params.has_key?('researcher')
        User
          .where(account_type: 1)
          .each { |u| UserMailer.with(user: u, body: params['text']).notify.deliver_later }
      end
      if params.has_key?('private')
        User
          .where(account_type: 2)
          .each { |u| UserMailer.with(user: u, body: params['text']).notify.deliver_later }
      end
    end
    if params.has_key?('support')
      UserMailer
        .with(
          user: @user,
          body: params['message'],
          subject: params['subject'],
          server_error: params['server_error']
        )
        .support
        .deliver_later
    end
    head :ok
  end

  #GET /users
  def index
    if params[:stats] && @login.has_capability?('stats')
      @userinfo = User.get_statistics
      @testinfo = Test.get_statistics
      render 'statistics'
    else
      @users = User.all
    end
  end

  def index_paginated
    page_number = params[:page_number].to_i.positive? ? params[:page_number].to_i : 1
    users_per_page = 20
    @users = User.limit(users_per_page).offset((page_number - 1) * users_per_page)
    @total_users = User.count
    render :index
  end

  def search
    head :forbidden and return if !@login.has_capability?('user')

    search_string = params[:search_term] || ''
    index = params[:index].to_i.positive? ? params[:index].to_i : 1
    page_size = params[:page_size].to_i.positive? ? params[:page_size].to_i : 20

    conditions = []
    conditions << ['LOWER(email) LIKE ?', "%#{search_string}%"] if search_string != ''

    if !params[:start_date_registration].nil? && !params[:end_date_registration].nil?
      start_date = Date.parse(params[:start_date_registration])
      end_date = Date.parse(params[:end_date_registration])
      conditions << ['created_at BETWEEN ? AND ?', start_date.beginning_of_day, end_date.end_of_day]
    end

    if !params[:start_date_login].nil? && !params[:end_date_login].nil?
      start_date = Date.parse(params[:start_date_login])
      end_date = Date.parse(params[:end_date_login])
      conditions << ['last_login BETWEEN ? AND ?', start_date.beginning_of_day, end_date.end_of_day]
    end

    users =
      User.where(conditions.map { |condition| condition.shift }.join(' AND '), *conditions.flatten)

    @users = users.limit(page_size).offset((index - 1) * page_size)
    @total_users = users.count
    render :index
  end

  def statistics
    if @login.has_capability?('stats')
      # legacy statistics
      #@userinfo = User.get_statistics
      #@testinfo = Test.get_statistics

      @monthly_results = User.get_monthly_results

      # @all_registrations_by_type_and_month = User.get_all_registrations_by_type_and_month

      # das sollte gut sein
      @active_users_by_month = User.get_active_users_by_month
      @registrations_by_month_and_state = User.get_registrations_by_time_and_state 'quarter'
    end
  end

  def get_classbook_info
    render json: @login.get_classbook_info
  end

  #DEL /users/:id
  def destroy
    if !@login.has_capability?('user')
      render json: {
               message: 'users_controller::destroy: insufficient permissions'
             },
             status: :forbidden
      return
    end

    if @user.id != @login.id
      #Nicht seinen eigenen Account löschen...
      @user.destroy
      head :forbidden
    end

    @users = User.all #Tabelle in der Benutzerverwaltung wird neu gerendert
    head :ok
  end

  def destroy_self
    head :forbidden and return if !@login.is_regular_user?

    @support_message =
      SupportMessage.new(
        {
          message: params['support_message']['message'],
          subject: "#{@login.email} hat seinen Account gelöscht.",
          sender: @login.email
        }
      )
    if @support_message.save
      UserMailer
        .with(
          email: @login.email,
          body: params['support_message']['message'],
          subject: "#{@login.email} hat seinen Account gelöscht.",
          support_addresses: User.where('capabilities LIKE ?', '%support%').pluck(:email)
        )
        .support
        .deliver_later
    end

    @login.destroy
    reset_session
    head :ok
  end

  def create #Kann vom Backend oder von der Registrierung ausgelöst werden. Falls Registrierung, gibt es keinen Login in der Session.
    # checks for bot registrations: comment can't be filled, and the user needs at least 5 seconds to fill in the form.
    if session.has_key?('user')
      #Session existiert
      user = User.find_by_id(session[:user])
    end
    if user.nil? || !user.has_capability?('user')
      if params[:user] &&
           (
             !params[:user].has_key?(:render_timestamp) || !params[:user].has_key?(:timestamp) ||
               params[:user][:render_timestamp].empty? || params[:user][:timestamp].empty?
           )
        render json: { message: 'Bot detected', error: '1' }, status: :forbidden and return
      end

      if params[:user] &&
           (
             (params[:user].has_key?(:comment) && !params[:user][:comment].empty?) ||
               !params[:user].has_key?(:comment)
           )
        render json: { message: 'Bot detected', error: '2' }, status: :forbidden and return
      end

      time1 = Time.parse(params[:user][:timestamp])
      time2 = Time.parse(params[:user][:render_timestamp])
      diff = (time1 - time2).abs
      if diff < 3
        render json: { message: 'Bot detected', error: '3' }, status: :forbidden and return
      end
    end

    #create user and password
    @user = User.new(user_attributes)
    pw = @user.generate_password
    @user.password = pw
    @user.password_confirmation = pw

    if (session.has_key?('user'))
      #TODO: Ggf. Masquerading prüfen, kann aber regulär nicht passieren...
      @login = User.find(session[:user]) #Login muss gesetzt werden, da before_action für create ausgelassen wird.
      unless @user.save
        render json: { message: 'Validation failed', errors: @user.errors }, status: 400
      else
        @users = User.all #Benötigt für Tabelle in der Benutzerverwaltung
        UserMailer.with(user: @user, password: pw).welcome.deliver_later
        head :ok
      end
    else
      #Anfrage kommt von der Registrierungsseite
      @user.intro_state = 1
      @user.tc_accepted = Time.now
      if @user.save
        UserMailer.with(user: @user, password: pw).welcome.deliver_later
        head :ok
      else
        render 'error', formats: :json, status: :bad_request
      end
    end
  end

  #GET /willkommen
  #POST /willkommen
  def register
    if session[:user].nil?
      redirect_to '/' and return #if @user.nil?
    else
      @user = User.find(session[:user]) #Login nicht gesetzt, da before action nicht ausgeführt.
    end

    #GET Anfrage standardmäßig nur am Anfang und Ende, oder bei Unterbrechung des Prozesses
    if request.get?
      ##############################################################################
      #this seems to be not used
      if @user.tc_accepted.nil? || @user.intro_state == 0
        render 'users/intro/terms_and_conditions', layout: 'minimal' and return
      elsif @user.intro_state < 3
        render 'users/intro/forms', layout: 'minimal' and return
        ##############################################################################
      else
        @login = @user
        render 'users/show' and return
      end
    end

    if request.patch?
      ################################################################
      #currently not used due to bot catching
      if params.has_key?('tc_accepted')
        @user.tc_accepted = Time.now
        @user.intro_state = 1 if @user.intro_state == 0 #Abfrage für spätere TC-Änderungen, dort kein Ändern von intro_state mehr!
        @user.save
        if @user.intro_state == 1
          head :ok and return
        else
          redirect_to @user
        end
      else
        ##############################################################
        case @user.intro_state
        ##############################################################
        #not used cause on creation the intro state is 1
        when 0
          #TC Accept hat noch nicht stattgefunden!
          @user.intro_state = 1
          @user.save
          head :ok and return
          ##############################################################
        when 1
          if @user.update(user_attributes)
            @user.intro_state = 3
            @user.save

            # don't create demo data after password reset
            if !@user.groups.exists?(demo: true)
              @user.create_demo(params[:key], params[:auth_token])
            end
            @login = @user
            head :ok and return
          end
          # intro_state 2 is currently unused
        when 3
          @user.intro_state = 4
          @user.save

          #redirect_to start_path(format: 'html'), status: 303
          head :ok and return
        else
          if params.has_key?(:classbook)
            @user.intro_state = 5
            @user.save
            head :ok and return
          end
        end
      end
    end
  end

  def get_core_data
    render 'users/core_data'
  end

  #GET /passwort
  #POST /passwort
  def recover
    headers['Cache-Control'] = 'no-store, must-revalidate'
    @user = User.find_by_email(params[:email]) if request.post?
    render 'recover', layout: 'minimal'
  end

  def recovery_notification
    @user = User.find_by_email(user_attributes[:email])
    if @user.nil?
      render json: { message: 'Diese E-Mail-Adresse ist nicht registriert!' }, status: :not_found
      return
    elsif @user.intro_state < 4
      render json: {
               message:
                 'Bitte schließen Sie zunächst die Registrierung mit dem Code aus der Registrierungsmail ab!'
             },
             status: :not_acceptable
      return
    end
    if @user.recovery_key.nil?
      @user.update(recovery_key: (0...9).map { ('a'..'z').to_a[rand(26)] }.join)
    end
    UserMailer.with(sender: 'noreply@levumi.de', user: @user).password_reset.deliver_later
    head :ok
  end

  def recovery_key_verification
    @user = User.find_by_email(user_attributes[:email])
    if @user.recovery_key == user_attributes[:recovery_key]
      respond_to do |format|
        format.html { render partial: 'users/recover/decrypt_password' and return }
        format.json { render json: @user and return }
      end
    else
      render json: { message: 'Der eingegebene Code ist falsch!' }, status: :forbidden
      return
    end
  end

  def delete_used_recovery_key
    @user = User.find_by_email(user_attributes[:email])
    @user.update(recovery_key: nil)
    head :ok and return
  end

  private

  def user_attributes
    temp =
      params
        .require(:user)
        .except(:comment, :timestamp, :render_timestamp)
        .permit(
          :account_type,
          :email,
          :focus,
          :institution,
          :intro_state,
          :password_confirmation,
          :password,
          :school_type,
          :security_digest,
          :settings,
          :state,
          :town,
          :server_error,
          :recovery_key
        )
        .reject { |_, v| v.blank? }
    if temp.has_key?(:password) && !temp.has_key?(:password_confirmation)
      temp[:password_confirmation] = ''
    end
    temp
  end

  #Nutzernummer aus Parametern holen und User laden
  def set_user
    @user = User.find(params[:id])
    unless @user != nil && (@user.id == @login.id || @login.has_capability?('user'))
      #Entweder es ist der eigene Nutzer oder die entsprechende Berechtigung ist vorhanden
      redirect_to '/'
    end
  end
end
