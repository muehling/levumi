class UsersController < ApplicationController
  before_action :set_user,
                except: %i[index show create register recover get_core_data statistics destroy_self]

  skip_before_action :set_login, only: %i[create register recover]

  #GET /start
  #GET /users/:id
  def show
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
        .with(user: @user, body: params['text'], subject: params['subject'])
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

  def statistics
    if @login.has_capability?('stats')
      @userinfo = User.get_statistics
      @testinfo = Test.get_statistics
    end
  end

  #DEL /users/:id
  def destroy
    if !@login.has_capability?('admin')
      head :forbidden
      return
    end

    if @user.id != @login.id
      #Nicht seinen eigenen Account löschen...
      @user.destroy
    end

    @users = User.all #Tabelle in der Benutzerverwaltung wird neu gerendert
    head :ok
  end

  def destroy_self
    @login.destroy
    reset_session
    head :ok
  end

  def create #Kann vom Backend oder von der Registrierung ausgelöst werden. Falls Registrierung, gibt es keinen Login in der Session.
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
    @user = User.find(session[:user]) #Login nicht gesetzt, da before action nicht ausgeführt.
    redirect_to '/' if @user.nil?

    #GET Anfrage standardmäßig nur am Anfang und Ende, oder bei Unterbrechung des Prozesses
    if request.get?
      if @user.tc_accepted.nil? || @user.intro_state == 0
        render 'users/intro/terms_and_conditions', layout: 'minimal' and return
      elsif @user.intro_state < 3
        render 'users/intro/forms', layout: 'minimal' and return
      else
        @login = @user
        render 'users/show' and return
      end
    end

    if request.patch?
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
        case @user.intro_state
        when 0
          #TC Accept hat noch nicht stattgefunden!
          @user.intro_state = 1
          @user.save
          head :ok and return
        when 1
          if @user.update(user_attributes)
            @user.intro_state = 3
            @user.save
            @user.create_demo(params[:key], params[:auth_token])
            @login = @user
            head :ok and return
          end

          ##TODO not sure about the intro states - password_form and extra_data are now in one form, so 3 should be correct
          #when 1
          #  #TC Accept => Passwort/Sicherheitsfrage wird angezeigt
          #  if @user.update(user_attributes)
          #    @user.intro_state = 2
          #    @user.save
          #  end
          #  head :ok and return #Hier entweder zurück wegen Fehler, oder weiter
          #when 2
          #  #TC Accept + erste Form => Zweite Form wird geschickt
          #  @user.update(user_attributes) if params.has_key?(:user) #Unkritische Attribute, deswegen kein Fehlercheck, if ist nötig für Privat-Accounts, dort wird nichts mitgeschickt (require schlägt dann fehl)
          #  @user.create_demo(params[:key], params[:auth_token])
          #  @user.intro_state = 3
          #  @user.save
          #  @login = @user
          #
          #  #render 'users/show' and return
          #  head :ok and return
        when 3
          @user.intro_state = 4
          @user.save

          #redirect_to start_path(format: 'html'), status: 303
          head :ok and return
        else
          if params.has_key?(:classbook)
            @user.intro_state = 5
            @user.save
            head 200 and return
          end
        end
      end
    end
  end

  def get_core_data
    @groups_object = [Group.new] + @login.get_classbook_info

    @shares_object = {}
    @login.group_shares.map { |c| @shares_object[c.group_id] = c.key }

    render 'users/core_data'
  end

  #GET /passwort
  #POST /passwort
  def recover
    if request.post?
      @user = User.find_by_email(params[:email])
    else
      render 'recover', layout: 'minimal'
    end
  end

  private

  def user_attributes
    temp =
      params
        .require(:user)
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
          :state,
          :town
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
