# -*- encoding : utf-8 -*-
class FrontendController < ActionController::Base
  #Festlegen des Allgemeinen Layout: siehe view/layouts/*
  layout 'bareStudent'

  skip_before_filter :check_login, :check_accept    #TODO: Logik überprüfen?

  before_filter :check_student, except: [:welcome, :login]

  def welcome
    if params.has_key?(:page)
      render params[:page]
    else
      render 'welcome'
    end
  end

  #Check logincode and redirect to next page
  def login
    s = Student.find_by_login(params[:login])
    if s != nil
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
  # #TODO: Das sollte dann evtl. Measurements index übernehmen! Ggf. umbennen
  def index
    @measurements = @student.get_open_measurements
  end

  #start Test
  def start
    @measurement = Measurement.find(params[:id])
    @test = @measurement.assessment.test
    @result = @student.getCurrentResult(@measurement.id)
    if (@test.student_access) #...ggf mehr Tests
      render "results/tests/#{@test.view_info}_student"  #TODO: Als Teil von view_info
    else
      redirect_to '/student'
    end
  end

  private

  #TODO: Kann wahrscheinlich raus?
  def check_student
    if session[:student_id].nil?
      redirect_to '/student', notice: "Bitte einloggen!"
    else
      @student = Student.find(session[:student_id])
    end
  end
end
