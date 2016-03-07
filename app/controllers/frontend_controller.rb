class FrontendController < ApplicationController
  layout 'bare'

  skip_before_filter :check_login, :check_accept

  before_filter :check_student, except: [:welcome, :login]

  def welcome
  end

  def login
    s = Student.find_by_login(params[:login])
    if (s != nil)
      session[:student_id] = s.id
      redirect_to '/frontend'
    else
      redirect_to '/student', notice: "Der eingegebene Code ist nicht gültig!"
    end
  end

  def index
    @measurements = @student.get_open_measurements
  end

  def start
    @measurement = Measurement.find(params[:id])
    @test = @measurement.assessment.test
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
