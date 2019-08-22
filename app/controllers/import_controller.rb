class RecieveController < ApplicationController
skip_before_action :verify_authenticity_token
skip_before_action :set_login
before_action :recieve_params, only: :recieve
  #PUT /students/:student_id/results/:id
  def import
    user = params[:data][:user]
    groups = params[:data][:groups]
    students = params[:data][:students]
    assessments = params[:data][:assessments]
    results =params[:data][:results]

    #Importieren des Nutzers
    u = User.find_by(email: user[:email])
    if u.nil?
      u = User.create(email: user[:email], password_digest: user[:password_digest], institution: user[:institution],
                      capabilities: user[:capabilities], account_type: user[:account_type], state: user[:state])
    end


    map_old_meas_to_new_ass = {}
    map_old_group_to_new_group = {}
    map_old_stu_to_new_stu = {}
    #Importieren der Gruppen, der GroupShare-Objekte und mappen der alten GroupIDs auf die neuen GroupIDs
    groups.each do |key, valueG|
      #Erstellen Group, GroupShare, Assessments und Studens
      g = Group.create(label: valueG[:label], archive: false, demo: false, auth_token: valueG[:auth_token])
      GroupShare.create(group_id:g.id, user_id: u.id, owner: true, read_only: false, key: valueG[:key])
      map_old_group_to_new_group[key] = g.id
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
      s = Student.create(group_id: map_old_group_to_new_group[valueS[:group_id].to_s], name: valueS[:name], login: valueS[:login], gender: valueS[:gender],
                         birthmonth: valueS[:birthmonth], sen: valueS[:sen], migration: valueS[:migration])
      map_old_stu_to_new_stu[keyS] = s.id
    end

    #Erstellen der Result-Objekte
    results.each do |r|
      result = {Übersicht: r[:results][:Übersicht]}
      report_params = r.require(:report).permit(:total, :positive =>[], :negative => [])
      report = {total:report_params[:total], positive: report_params[:positive], negative: report_params[:negative] }

      data = []
      data_params  = r[:data]
      data_params.each do |data_obj|
        data += [data_obj.permit(:item, :group, :answer, :time).to_h]
      end

      res = Result.create(student_id: map_old_stu_to_new_stu[r[:student_id].to_s], assessment_id: map_old_meas_to_new_ass[r[:measurement_id]],
                    test_date:r[:test_date], results: result, report: report, data: data, created_at: r[:created_at])
    end
    render json: {status: true}, status: 200
  end

private
def recieve_params
  params.require(:data).permit(:user, :groups, :students, :assessments, :results)
end
end
