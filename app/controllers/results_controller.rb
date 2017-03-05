# -*- encoding : utf-8 -*-
class ResultsController < ApplicationController
  before_action :set_measurement
  before_action :set_assessment
  before_action :set_user
  before_action :set_group
  before_filter :is_allowed

  # GET /results
  # GET /results.json
  def index
    @results = Result.all
  end

  # GET /results/1
  # GET /results/1.json
  def show
  end

  # GET /results/new
  def new
    @test = @measurement.assessment.test

    respond_to do |format|
     format.html {@format = "html"}
     format.text {@format = "plain"}
    end

    render 'new', :formats => [:js], content_type: 'text/javascript'
  end

  # GET /results/1/edit
  def edit
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    results = result_params
    unless results.nil?
      stay = true
      if results.is_a?(String)                #Update comes from online testing
        parts = results.split("#")
        r = @measurement.results.find(parts[0].to_i)
        unless r.nil?
          r.parse_csv(parts[1])
          r.add_times(parts[2]) if parts.length > 2               #Possible hack: Will this always be the case?
          render nothing: true
        end
      else
        if results.has_key?("students")       #Update comes from editing form
          @measurement.update_students(results["students"])
        else
          results.each do |id, val|
            r = @measurement.results.find_by_student_id(id)
            unless r.nil?
              if val.is_a?(Hash)
                r.parse_Hash(val)
              else
                r.parse_csv(val)
                stay = false
              end
            end
          end
        end
        respond_to do |format|
          format.js {
            unless stay
              render 'assessments/show'
            else
              render :edit
            end
          }
        end
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      #Methode funktioniert leider nicht da keine result.id mitgegeben wird. Hack:Herrausziehen aus dem abgabestring
      @result = Result.find(params[:id])
    end

    def set_measurement
      @measurement = Measurement.find(params[:measurement_id])
    end

    def set_assessment
      @assessment = Assessment.find(params[:assessment_id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params[:results]
    end

    def is_allowed
      #Holen des Resultobjektes anhand des übergebenen Strings
      if @login.instance_of?(Student)
        results = result_params
        unless results.nil?
          if results.is_a?(String)
            parts = results.split("#")
            r = @measurement.results.find(parts[0].to_i)
          end
        end
      end
      unless (@login.instance_of?(User) && @login.hasCapability?("admin")) || (@login.instance_of?(User) && params.has_key?(:user_id) &&
          (@login.id == params[:user_id].to_i)) ||((@login.id == r.student.id) && @login.instance_of?(Student))
        redirect_to root_url
      end
    end
end
