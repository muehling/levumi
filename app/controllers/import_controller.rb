#TEMPCODE
class ImportController < ApplicationController

  skip_before_action :set_login
  skip_before_action :verify_authenticity_token
  before_action :import_params, only: :import

  #PUT /students/:student_id/results/:id
  def import
    user = params[:data][:user]
    groups = params[:data][:groups]
    students = params[:data][:students]
    assessments = params[:data][:assessments]
    results = params[:data][:results]

    #Importieren des Nutzers
    u = User.find_by(email: user[:email])
    create_test_class = false
    if u.nil?
      create_test_class = true
      u = User.create(email: user[:email], password_digest: user[:password_digest], institution: user[:institution], account_type: user[:account_type], state: user[:state], intro_state: 3)
    end
    if u.intro_state < 3
      create_test_class = true
      u.intro_state = 3
      u.save
    end

    map_old_meas_to_new_ass = {}
    map_old_group_to_new_group = {}
    map_old_stu_to_new_stu = {}
    #Importieren der Gruppen, der GroupShare-Objekte und mappen der alten GroupIDs auf die neuen GroupIDs
    groups.each do |key, valueG|
      if key == '-1'
        if create_test_class
          #Erstellen Group, GroupShare, Assessments und Studens
          g = Group.create(label: valueG[:label], demo: true, auth_token: valueG[:auth_token])
          GroupShare.create(group_id:g.id, user_id: u.id, owner: true, read_only: false, key: valueG[:key])
          map_old_group_to_new_group[key] = g.id
        end
      else
        #Erstellen Group, GroupShare, Assessments und Studens
        g = Group.create(label: valueG[:label], auth_token: valueG[:auth_token])
        GroupShare.create(group_id:g.id, user_id: u.id, owner: true, read_only: false, key: valueG[:key])
        map_old_group_to_new_group[key] = g.id
      end
    end

    #Erstellen der Assessments und mappen der alten MesurementIDs auf die neuen AssessmentIDs
    new_test = Test.all.pluck(:id, :shorthand)
    assessments.each do |keyA, valueA|
      test = new_test.find{|t| t[1] == valueA[:shorthand]}
      if test.nil?
      else
        a = Assessment.create(group_id: map_old_group_to_new_group[valueA[:group_id].to_s], test_id:test[0] )
        #Mappen der IDs (Verbindung zu alten Resultobjekten)
        valueA[:measurement_ids].each{|m| map_old_meas_to_new_ass[m] = a.id} unless valueA[:measurement_ids].nil?
      end
    end

    #Erstellen der Students
    students.each do |keyS, valueS|
      if valueS[:migration]

        s = Student.create(group_id: map_old_group_to_new_group[valueS[:group_id].to_s], name: valueS[:name], login: valueS[:login].upcase, gender: valueS[:gender],
                           birthmonth: valueS[:birthmonth], sen: valueS[:sen], tags: ['Migrationshintergrund'].to_json)
      else
        s = Student.create(group_id: map_old_group_to_new_group[valueS[:group_id].to_s], name: valueS[:name], login: valueS[:login].upcase, gender: valueS[:gender],
                           birthmonth: valueS[:birthmonth], sen: valueS[:sen], tags: [].to_json)
      end

      map_old_stu_to_new_stu[keyS] = s.id
    end

    #Erstellen der Result-Objekte
    results.each do |r|
      detail = r.require(:results).permit(:V1, :V2=>{}, :V3=>{})
      puts detail
      result = {}
      if detail.key?('V3')
        result = {'V1': detail[:V1], 'V2':detail[:V2].to_h , 'V3':detail[:V3].to_h }
      elsif detail.key?('V2')
        result = {'V1': detail[:V1], 'V2':detail[:V2].to_h}
      else
        result = {'V1': detail[:V1]}
      end
      report_params = r.require(:report).permit(:total, :positive =>[], :negative => [])
      report = {total:report_params[:total], positive: report_params[:positive], negative: report_params[:negative] }

      data = []
      data_params  = r[:data]
      data_params.each do |data_obj|
        data += [data_obj.permit(:item, :group, :answer, :time).to_h]
      end

      res = Result.create(student_id: map_old_stu_to_new_stu[r[:student_id].to_s], assessment_id: map_old_meas_to_new_ass[r[:measurement_id]],
                    test_date:r[:test_date], views: result, report: report, data: data, created_at: r[:created_at])
    end
    render json: {status: true}, status: 200
  end

private
  def import_params
    params.require(:data).permit(:user, :groups, :students, :assessments, :results)
  end
end
