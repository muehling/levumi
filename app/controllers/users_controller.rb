# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :multi_update]
  before_action :is_allowed, except: [:show]

  skip_before_action :check_accept, only: [:multi_update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html {
        if @login_user.nil? || (!@login_user.hasCapability?("user") && (@user.id != @login_user.id))
          redirect_to root_url
        end
      }
      format.xml {
        if @login_user.nil? || (!@login_user.hasCapability?("export") && (@user.id != @login_user.id))
          redirect_to root_url
        else
          send_file Result.to_xls(@user.id), filename: @user.name + " " + Time.now.to_date.strftime("%d-%m-%y") + ".xls", type: "application/vnd.ms-excel"
        end
      }
      format.text {
        if @login_user.nil? || (!@login_user.hasCapability?("export") && (@user.id != @login_user.id))
          redirect_to root_url
        else
          send_file Result.to_csv(nil, @user.id), filename: @user.name + " " + Time.now.to_date.strftime("%d-%m-%y") +  ".csv", type: "text/csv"
        end
      }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @groups = @user.groups
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'Benutzer wurde angelegt.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if params.has_key?('text') && @login_user.id == @user.id       #Send mail to all users
        format.html {
          if params.has_key?('teacher')
            User.where(account_type: 0).each do |u|
              UserMailer.notify(u.email, u.name, params['text']).deliver_later
            end
          end
          if params.has_key?('researcher')
            User.where(account_type: 1).each do |u|
              UserMailer.notify(u.email, u.name, params['text']).deliver_later
            end
          end
          if params.has_key?('other')
            User.where(account_type: 2).each do |u|
              UserMailer.notify(u.email, u.name, params['text']).deliver_later
            end
          end
          redirect_to users_url, notice: 'Nachricht wurde verschickt.'
        }
      else
        if @user.update(user_params)
          format.html {
            if @login_user.id != @user.id
              redirect_to users_path
            else
              redirect_to @user
            end
          }
        else
          format.html { render :edit }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    backend = true
    if (@user.account_type == -1) || (@user.id != session[:user_id])
      @user.destroy    #Löschen im Backend => Final löschen
    else
      @user.delete     #Löschen als User => Daten löschen, Einloggen verhindern
      backend = false
    end
    respond_to do |format|
      format.html {
        if backend
          redirect_to users_url, notice: 'Benutzer wurde gelöscht.'
        else
          if !session[:user_id].nil?
            session[:user_id] = nil
            @login_user = nil
          end
          redirect_to root_url, notice: 'Ihr Benutzer wurde erfolgreich gelöscht. Vielen Dank, dass Sie Levumi verwendet haben.'
        end
      }
    end
  end

  def multi_update                                     #TODO Gehört eigentlich in Student...
    if params.has_key?(:students)
      params[:students].each do |keyGroup, valueGroup|
        valueGroup.each do |keyStudent, valueStudent|
          s = Student.find(keyStudent)
          if s.group.user.id != @login_user.id
            if(!session[:user_id].nil?)
              session[:user_id] = nil
              @login_user = nil
            end
            redirect_to root_url
          else
            s.name = valueStudent
            s.save
          end
        end
      end
      head :ok
    else
      head :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :school, :password, :password_confirmation, :account_type, :state, :occupation)
    end

  def is_allowed
    unless !@login_user.nil? && @login_user.hasCapability?("user") ||!@login_user.nil? && (params.has_key?(:id) && (@login_user.id == params[:id].to_i))
      redirect_to root_url
    end
  end

end
