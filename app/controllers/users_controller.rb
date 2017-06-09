# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :is_allowed, except: [:show]

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
        unless @login.instance_of?(User) && @login.hasCapability?("user") || (@user.id == @login.id)
          redirect_to root_url
        end
      }
      format.xml {
        unless @login.instance_of?(User) && @login.hasCapability?("export")
          redirect_to root_url
        end
        send_file @user.export, filename: @user.name + " - Export.xls", type: "text/csv"
      }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
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
      if @user.update(user_params)
        format.html {
          if @login.id != @user.id
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

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Benutzer wurde gelöscht.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :school, :password, :password_confirmation)
    end

  def is_allowed
    unless @login.instance_of?(User) && @login.hasCapability?("user") ||@login.instance_of?(User) && (params.has_key?(:id) && (@login.id == params[:id].to_i))
      redirect_to root_url
    end
  end

end
