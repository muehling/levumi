class StudentsController < ApplicationController
  before_action :set_student, except: %i[create move_students]

  #GET /students
  def index
    render json: @login.students
  end

  #POST /students
  def create #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    group = Group.find(params[:group])
    unless group.nil? || group.read_only(@login)
      s = group.students.new(student_attributes)
      if s.save
        render json: s
      else
        head 304
      end
    else
      head 304
    end
  end

  def show
    respond_to do |format|
      format.json do #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung => Schüleransicht
        unless @student.nil?
          render json: @student.get_assessments
        else
          head 304
        end
      end
      format.html do #Anzeige als eigene Seite => Lehrkraft-Ansicht
        render :show, layout: 'minimal' unless @student.nil?
      end
    end
  end

  #PUT /students/:id
  def update #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    unless @student.nil? || @student.group.read_only(@login) || !@student.update(student_attributes)
      render json: @student
    else
      head 304
    end
  end

  #DEL /students/:id
  def destroy
    @student.destroy unless @student.nil? || @student.group.read_only(@login)
    head :ok #200 als Rückmeldung an Vue-Component
  end

  def move_students
    student_ids = params[:students].map { |student| student['id'] }
    students = Student.where(id: student_ids)
    old_group = Group.find(params[:source_group_id])
    new_group = Group.find(params[:target_group_id])
    new_group_student_ids = Student.where(group_id: params[:target_group_id]).pluck(:id)

    head :no_content and return if old_group.nil? || new_group.nil? || students.empty?

    params[:students].each do |student_data|
      student = students.where(id: student_data[:id]).first
      student.update(group_id: params[:target_group_id], name: student_data[:name])

      source_assessments = Assessment.where(group_id: params[:source_group_id])

      source_assessments.each do |source_assessment|
        target_assessment =
          Assessment.where(test_id: source_assessment.test_id, group_id: params[:target_group_id])
            .first
        has_results_for_student =
          Result.where(student_id: student_data[:id], assessment_id: source_assessment.id).exists?
        if target_assessment.nil? && has_results_for_student
          target_assessment = source_assessment.dup
          target_assessment.group_id = params[:target_group_id]
          target_assessment.save
          if (!target_assessment.test.archive && target_assessment.test.student_test)
            target_assessment.update(excludes: new_group_student_ids)
          end
        end
        if (!target_assessment.nil?)
          Result
            .where(student_id: student[:id], assessment_id: source_assessment[:id])
            .update(assessment_id: target_assessment[:id].to_i)
        end
      end
    end
    result = []
    result += [old_group.as_hash(@login)]
    result += [new_group.as_hash(@login)]
    render json: result
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_attributes
    params
      .require(:student)
      .permit(:name, :gender, :birthmonth, :sen, :tags, settings: %i[font_family font_size])
  end
end
