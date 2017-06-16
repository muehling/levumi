# -*- encoding : utf-8 -*-
class ResultsController < ApplicationController
  before_action :set_measurement
  before_action :set_assessment
  before_action :set_user
  before_action :set_group
  before_action :set_result, only: :update
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
        unless @result.nil?
          @result.parse_csv(parts[1])
          @result.add_times(parts[2])
          @result.add_answer(parts[3]) if parts.length > 3               #Possible hack: Will this always be the case?
          render nothing: true
        end
      else
        #TODO wofür ist das hier drin? ist das für den PDF ausdruck, wenn ja, warum braucht man da denn eine update Funktion?
        # Da muss man sich doch nur die Daten holen und will keine verändern. Und dann auch nur um sich die Result-IDs rauszuziehen?
        #Das wird in der aktuellen Version von mir/uns eh schon immer vor update gemacht, wenn die result_params ein String sind
        #Desweiteren wird r nie benutzt, vllt doch ein Artefakt/falsch gemergt? macht hier auf jeden fall keinen Sinn
        results = result_params
        unless results.nil?
          if results.is_a?(String)
            parts = results.split("#")
            r = @measurement.results.find(parts[0].to_i)
          end
        end
        if results.has_key?("students")       #Update comes from editing form
          @measurement.update_students(results["students"])
        else
          results.each do |id, val|
            r = @measurement.results.find_by_student_id(id)
            unless r.nil?
              if val.is_a?(Hash)
                r.parse_Hash(val)
              else
                #TODO Die Methode parse_csv verhindet das bearbeiten/updaten der Response-Wert (Durch NoMethodError). Ich meine, dass war in meiner Version noch nicht so, sondern kam erst mit dem Merge rein...
                #Ich bin mir aber gerade ziemlich unsicher, obwohl ich es getestet hatte, sonst hätte ich das nie so gepusht.
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
      unless (@login.instance_of?(User) && @login.hasCapability?("admin")) || (@login.instance_of?(User) && params.has_key?(:user_id) &&
          (@login.id == params[:user_id].to_i)) ||((@login.id == @result.student.id) && @login.instance_of?(Student))
        redirect_to root_url
      end
    end
end
