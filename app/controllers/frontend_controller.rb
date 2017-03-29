# -*- encoding : utf-8 -*-
class FrontendController < ActionController::Base
  #Festlegen des Allgemeinen Layout: siehe view/layouts/*
  layout 'bareStudent'

  skip_before_filter :check_login, :check_accept

  before_filter :check_student, except: [:welcome, :login]

  def welcome
    if params.has_key?(:page)
      render params[:page], :layout => 'bareStudent'
    else
      render 'welcome', :layout => 'bareStudent'
    end
  end
  #Check logincode and redirect to next page
  def login
    #Avoiding login code for programming, id= 1 should be ok
    #s = Student.find_by_id(params[:login])
    s = Student.find_by_login(params[:login])
    if s != nil
#check password, when needed
=begin
      if s.password_digest == params[:password]
=end
      session[:student_id] = s.id
      redirect_to '/frontend'
      self.class.layout 'plain'
    else
      redirect_to '/student', notice: "Benutzername oder Password falsch!"
    end
  end

  #Logout student
  def logout
    session[:student_id] = nil
    @login = nil
    redirect_to '/student'
  end
  #get all available measurements
  def index
    @measurements = @student.get_open_measurements
  end

  #start Test
  def start
    @measurement = Measurement.find(params[:id])
    @test = @measurement.assessment.test
    @result = @student.getCurrentResult(@measurement.id)
    if (@test.student_access) #...ggf mehr Tests
      render "results/tests/#{@test.view_info}_student"
    else
      redirect_to '/student'
    end
  end

  private

  def check_student
    if session[:student_id].nil?
      redirect_to '/student', notice: "Bitte einloggen!"
    else
      @student = Student.find(session[:student_id])
    end
  end
end
