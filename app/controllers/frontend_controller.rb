# -*- encoding : utf-8 -*-
class FrontendController < ApplicationController

  skip_before_action :check_login, :check_accept

  before_action :check_student, except: [:welcome, :login]

  layout 'plain'

  def welcome
    if params.has_key?(:page)
      render params[:page], :layout => 'bareStudent'
    else
      render 'welcome', layout: 'bareStudent'
    end
  end

  #Check logincode and redirect to next page
  def login
    s = Student.find_by_login(params[:login])
    if s != nil&& s.group.user.account_type != -1
      session[:student_id] = s.id
      session[:user_id] = nil
      @login_user = nil
      redirect_to '/frontend'
    else
      redirect_to '/schueler', notice: "Der Code ist falsch! Bitte prüfe genau, ob du alles richtig eingegeben hast."
    end
  end

  #Logout student
  def logout
    if(!session[:student_id].nil?)
      session[:student_id] = nil
      @login_student = nil
    end
    redirect_to '/schueler'
  end

  #get all available measurements
  # #TODO-A: Das sollte dann evtl. Measurements index übernehmen! Ggf. umbennen
  def index
    @measurements = @student.get_open_measurements
  end

  #start Test
  def start
    @measurement = Measurement.find(params[:id])
    @test = @measurement.assessment.test
    @result = @student.getCurrentResult(@measurement.id)
    if (@test.student_access) #...ggf mehr Tests
      render "results/tests/#{@test.view_info}"
    else
      redirect_to '/schueler'
    end
  end

  private

  def check_student
    if session[:student_id].nil?
      redirect_to '/schueler', notice: "Bitte einloggen!"
    else
      @student = Student.find(session[:student_id])
    end
  end
end
