# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_login, except: [:welcome, :login, :signup]
  before_action :check_accept, except: [:welcome, :login, :signup, :accept, :static, :logout]

  def login
    u = User.find_by_email(params[:email])
    if u != nil && u.account_type!=-1
      if u.authenticate(params[:password])
        session[:user_id] = u.id
        session[:student_id] = nil
        @login_student = nil
        @login_user = u
        @user = u
        news = News.new_items(u)
        u.last_login = Time.now
        u.save
        #if u.complete?
          redirect_to user_groups_path(u), notice: news.empty? ? "Eingeloggt als #{u.email}" : news.join("<br/><br/>")
        #else
        #  redirect_to edit_user_path(u), notice: "Eingeloggt als #{u.email} <br/> Bitte vervollständigen Sie noch Ihre persönlichen Daten, Sie helfen uns damit bei der wissenschaftlichen Begleitung von Levumi!" +  (news.empty? ? "" : "<br/>" + news.join("<br/><br/>"))
        #end
      else
        redirect_to root_url, notice: 'Benutzername oder Passwort falsch!'
      end
    else
      redirect_to root_url, notice: 'Benutzername oder Passwort falsch!'
    end
  end

  def logout
    if(!session[:user_id].nil?)
      session[:user_id] = nil
      @login_user = nil
    end
    redirect_to root_url
  end

  def welcome
    if params.has_key?(:page)
      render params[:page], :layout => 'bare'
    else
      render 'welcome', :layout => 'bare'
    end
  end

  def signup
    if params["name"].blank? || params["email"].blank? || params["state"].blank?
      flash['notice'] = "Bitte füllen Sie alle Felder aus!"
      render 'signup', layout: 'bare' and return
    end
    if params["account_type"] == "0" && (params["school"].blank? || params["occupation"].blank?)
      flash['notice'] = "Bitte füllen Sie alle Felder aus!"
      render 'signup', layout: 'bare' and return
    end
    if params["account_type"] == "1" && (params["school"].blank?)
      flash['notice'] = "Bitte füllen Sie alle Felder aus!"
      render 'signup', layout: 'bare' and return
    end
    password = Digest::SHA1.hexdigest(rand(36**8).to_s(36))[1..6]
    u = User.find_by_email(params[:email])
    unless u.nil? || u.account_type != -1     #Versuch, sich mit einem alten Account erneut zu registrieren => alten Account löschen.
      u.destroy                               #TODO: Doch lieber "Fallback User" für Daten
    end
    @user = User.new(email: params[:email], name: params[:name], account_type: params[:account_type], password: password, password_confirmation: password)
    @user.school = params["school"] if params.has_key?("school")
    @user.occupation = params["occupation"] if params.has_key?("occupation")
    @user.state = params["state"] if params.has_key?("state")
    if @user.save
      UserMailer.registered(@user.email, @user.name, password).deliver_later
      render 'registered', layout: 'bare'
    else
      error = ''
      unless @user.errors['email'].blank?
        error = 'E-Mail Adresse ungültig oder bereits registriert!'
      end
      flash['notice'] = error
      render 'signup', layout: 'bare'
    end
  end

  def accept
    @login_user.tcaccept = DateTime.now
    @login_user.save
    redirect_to user_groups_path(@login_user), notice: 'Viel Spaß bei der Benutzung von Levumi!'
  end

  def static
    render params[:page]
  end

  def export
    unless !@login_user.nil? && @login_user.hasCapability?('export')
      redirect_to root_url
    end
    @tests = Test.all
    @users = User.all
  end

  private
  #check if user is logged in
  def check_login
    if session[:user_id].nil? && session[:student_id].nil?
      redirect_to root_url, notice: 'Bitte einloggen!'
    elsif !session[:student_id].nil?
      @login_student = Student.find(session[:student_id])
     else
      @login_user = User.find(session[:user_id])
    end
  end

  #check if user accepted the letter of agreement
  def check_accept
    if !@login_user.nil? && @login_user.tcaccept.nil?
      render 'accept'
    end
  end

end
