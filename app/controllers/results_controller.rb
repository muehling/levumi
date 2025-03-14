class ResultsController < ApplicationController
  before_action :set_student, except: %i[start_demo]
  before_action :set_group, only: %i[new]

  before_action :check_login, only: %i[create new]
  skip_before_action :set_login, only: %i[create new]

  #GET /students/:student_id/results/new
  def new
    headers['Cache-Control'] = 'no-store, must-revalidate'
    if params.has_key?(:test_id)
      #Eigentlich "new" Action => Kein Objekt anlegen, Testseite rendern
      @test = Test.find(params[:test_id])
      unless @test.nil?
        @assessment =
          Assessment.where(group_id: @student.group_id, test_id: @test.id).pluck(:id).first #Assessment aus student_id und test_id bestimmen
        @last_result = @student.results.where(assessment_id: @assessment).order(:test_week).last #Letztes Ergebnis aus der Datenbank
        if @test.student_test &&
             (@last_result.nil? || @last_result.test_date < Time.current.beginning_of_week)
          #Reicht das immer aus?
          @redirect = '/testen'
        else
          if params.has_key? :student
            @redirect = student_path(@student)
          else
            @redirect = "/diagnostik/#{@student.group.id}/testdetails/#{@test.id}"
          end
        end
        if @last_result.nil? || @last_result.created_at < Time.current.beginning_of_week
          render 'edit', layout: 'testing'
        else
          @redirect = "/testen_login?login=#{@student.login}"
          redirect_to @redirect
        end
      end
    else
      head 304
    end
  end

  def start_demo
    if (params.has_key?(:test_id))
      @test = Test.find(params[:test_id])
      render 'edit', layout: 'testing'
    else
      render json: { message: 'results_controller::start_demo: test not found' }, status: :not_found
    end
  end

  #POST /students/:student_id/results
  def create
    if params.has_key?(:assessment_id)
      @last_result =
        @student.results.where(assessment_id: params[:assessment_id]).order(:test_week).last #Letztes Ergebnis aus der Datenbank
      if !@last_result.nil? && @last_result.test_week == Time.current.beginning_of_week
        head 409
      else
        @result = @student.results.build(assessment_id: params[:assessment_id])
        @result.views = JSON.parse(params[:views])
        @result.report = JSON.parse(params[:report])
        @result.data = JSON.parse(params[:data])
        @result.test_date = DateTime.now
        if @result.save
          head :ok
          return
        else
          render json: @result.errors, status: :unprocessable_entity
        end
      end
    end
  end

  #DEL /students/:student_id/results/:id
  def destroy
    if @student.group.owner == @login
      @result = Result.find(params[:id])
      unless @result.nil? || @result.student != @student
        assessment = Assessment.find(@result.assessment_id)
        @result.destroy
        render json: assessment.get_data
      else
        render json: {
                 message: "results_controller::destroy: result couldn't be found"
               },
               status: :forbidden
      end
    else
      render json: {
               message: 'results_controller::destroy: insufficient permissions'
             },
             status: :forbidden
    end
  end

  private

  #Kind id aus Parametern holen und laden
  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_group
    @group = @student.group
  end

  def check_login
    #Fall 1: User Login
    if session.has_key?(:user)
      #Entweder die eigene Klasse, oder eine geteilte Klasse mit entsprechender Berechtigung
      if @student.group.owner.id == session[:user] ||
           GroupShare.exists?(user: session[:user], group: @student.group, read_only: false)
        return true
      end
    end

    #Fall 2: Schüler Login
    if session.has_key?(:student)
      return true if session[:student] == @student.id
    end
    render json: {
             message: 'results_controller::check_login: insufficient permissions'
           },
           status: :forbidden
  end
end
