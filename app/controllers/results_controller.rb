# -*- encoding : utf-8 -*-
class ResultsController < ApplicationController
  before_action :set_measurement
  before_action :set_assessment
  before_action :set_user
  before_action :set_group
  before_action :set_result, only: :update
  before_action :is_allowed

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
      if results.is_a?(String)   #Update comes from online testing
        parts = results.split("#")
        labels = parts[0].split(",")
        unless @result.nil?
          @result.parse_csv(parts[1])
          @result.parse_data(labels[1, labels.length-1], parts[2, parts.length-1]) if parts.length > 2
          head 200
        end
      else
        if results.has_key?("students")       #Update comes from editing form
          @measurement.update_students(results["students"])
        else
          results.each do |id, val|
            r = @measurement.results.find_by_student_id(id)
            unless r.nil?
              if val.is_a?(String)
                r.parse_csv(val)
                stay = false
              else
                r.parse_Hash(val)
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
      results = result_params
      unless results.nil?
        if results.is_a?(String)
          parts = results.split("#")
          @result = @measurement.results.find(parts[0].to_i)
        end
      end
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
      #check if user is allowed
      #@result exists only before update => student can only update a result
      unless !@login_user.nil? &&@login_user.account_type!=-1&& (@login_user.hasCapability?("admin") || params.has_key?(:user_id) &&
          (@login_user.id == params[:user_id].to_i)) || !@login_student.nil? && @login_student.group.user.account_type!=-1 && (@login_student.id == @result.student.id)
        redirect_to root_url
      end
    end
end
