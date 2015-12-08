# -*- encoding : utf-8 -*-
class StudentsController < ApplicationController
  before_action :set_user
  before_action :set_group
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @results = @student.getResults
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new
    if student_params.has_key?(:file)
      begin
        success = true
        Student.import(student_params[:file], @group)
        flash.now[:notice] = "Schülerdaten erfolgreich importiert."
      rescue
        success = false
        flash.now[:notice] = "Fehler beim Importieren der Schülerdaten!"
      end
    else
      @student = @group.students.new(student_params)
      success = @student.save
      unless success
        @student.destroy
        @group.reload
      end
    end

    respond_to do |format|
      if success
        format.html { redirect_to user_group_students_path(@user, @group), notice: flash.now[:notice] }
        format.js {
          @student = Student.new
        }
      else
        format.js { render :new }
        format.html { redirect_to user_group_students_path(@user, @group), notice: flash.now[:notice] }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end


    def set_user
      @user = User.find(params[:user_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :birthdate, :gender, :specific_needs, :migration, :file)
    end
end
