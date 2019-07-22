# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_login, except: [:welcome, :login, :signup]
  before_action :check_accept, except: [:welcome, :login, :signup, :accept, :static, :logout]

  def login
    u = User.find_by_email(params[:email])
    if u != nil && u.account_type!=-1
      if u.authenticate(params[:password])
        session[:user_id] = u.id
        session[:student_id] = nil
        @login_student = nil
        @login_user = u
        @user = u
        news = News.new_items(u)
        u.last_login = Time.now
        u.save
        #if u.complete?
          redirect_to user_groups_path(u), notice: news.empty? ? "Eingeloggt als #{u.email}" : news.join("<br/><br/>")
        #else
        #  redirect_to edit_user_path(u), notice: "Eingeloggt als #{u.email} <br/> Bitte vervollständigen Sie noch Ihre persönlichen Daten, Sie helfen uns damit bei der wissenschaftlichen Begleitung von Levumi!" +  (news.empty? ? "" : "<br/>" + news.join("<br/><br/>"))
        #end
      else
        redirect_to root_url, notice: 'Benutzername oder Passwort falsch!'
      end
    else
      redirect_to root_url, notice: 'Benutzername oder Passwort falsch!'
    end
  end

  def logout
    if(!session[:user_id].nil?)
      session[:user_id] = nil
      @login_user = nil
    end
    redirect_to root_url
  end

  def welcome
    if params.has_key?(:page)
      render params[:page], :layout => 'bare'
    else
      render 'welcome', :layout => 'bare'
    end
  end

  def signup
    if params["name"].blank? || params["email"].blank? || params["state"].blank?
      flash['notice'] = "Bitte füllen Sie alle Felder aus!"
      render 'signup', layout: 'bare' and return
    end
    if params["account_type"] == "0" && (params["school"].blank? || params["occupation"].blank?)
      flash['notice'] = "Bitte füllen Sie alle Felder aus!"
      render 'signup', layout: 'bare' and return
    end
    if params["account_type"] == "1" && (params["school"].blank?)
      flash['notice'] = "Bitte füllen Sie alle Felder aus!"
      render 'signup', layout: 'bare' and return
    end
    password = Digest::SHA1.hexdigest(rand(36**8).to_s(36))[1..6]
    u = User.find_by_email(params[:email])
    unless u.nil? || u.account_type != -1     #Versuch, sich mit einem alten Account erneut zu registrieren => alten Account löschen.
      u.destroy                               #TODO: Doch lieber "Fallback User" für Daten
    end
    @user = User.new(email: params[:email], name: params[:name], account_type: params[:account_type], password: password, password_confirmation: password)
    @user.school = params["school"] if params.has_key?("school")
    @user.occupation = params["occupation"] if params.has_key?("occupation")
    @user.state = params["state"] if params.has_key?("state")
    if @user.save
      UserMailer.registered(@user.email, @user.name, password).deliver_later
      render 'registered', layout: 'bare'
    else
      error = ''
      unless @user.errors['email'].blank?
        error = 'E-Mail Adresse ungültig oder bereits registriert!'
      end
      flash['notice'] = error
      render 'signup', layout: 'bare'
    end
  end

  def accept
    @login_user.tcaccept = DateTime.now
    @login_user.save
    redirect_to user_groups_path(@login_user), notice: 'Viel Spaß bei der Benutzung von Levumi!'
  end

  def static
    render params[:page]
  end

  def export
    unless !@login_user.nil? && @login_user.hasCapability?('export')
      redirect_to root_url
    end
    @tests = Test.all
    @users = User.all
  end

  def transfer_data
    client_data = JSON.parse(params[:data])
    data_to_transfer = {}

    #prepare user for tranfer
    user_transfer =  {id: @login_user.id, email: @login_user.email, password_digest: @login_user.password_digest,
                      institution: @login_user.school, capabilities: @login_user.capabilities,
                      account_type: @login_user.account_type, state: @login_user.state}
    data_to_transfer[:user] = user_transfer

    #prepare groups for tranfer
    groups_transfer = {}
    students_transfer = {}
    assessments_transfer = {}
    groups = @login_user.groups
    groups.each do |g|
      if !g.demo
        groups_transfer[g.id] = {label: g.name, archive: g.archive, key: client_data[g.id.to_s]['key'], auth_token: client_data[g.id.to_s]['token']}
        students_transfer[g.id] = {}
        assessments_transfer[g.id] = {}
      end
    end
    data_to_transfer[:groups] = groups_transfer


    students = Student.where(group_id:groups)
    #prepare students for transfer
    students.each do |s|
      if s.specific_needs.nil?
        sen = nil
      elsif s.specific_needs == 0
        sen = 0
      elsif s.specific_needs == 1
        sen = 1
      elsif s.specific_needs == 2
        sen = 2
      elsif s.specific_needs == 3
        sen = 0
      else
        sen = 4
      end
      students_transfer[s.id]= {group_id: s.group_id, name: client_data[s.group_id.to_s]['students'][s.id.to_s], login: s.login,
                                     gender: (s.gender.nil? ? nil : (s.gender ? 1 : 0)), birthmonth: s.birthdate,
                                     migration: (s.migration.nil? ? nil : (s.migration ? 1 : 0)), sen: sen}
    end
    data_to_transfer[:students] = students_transfer
    #prepare assessments for transfer and merge relevant data from test
    assessments = Assessment.where(group_id:groups)
    test = Test.all.pluck(:id, :shorthand)
    test_transfer = {}
    items_test = {}
    test.each do |t|
      test_transfer[t[0]] = {shorthand:t[1]}
      items = Item.where(test_id: t[0]).pluck(:id, :difficulty, :shorthand)
      count = 1
      items.each do |i|
        items_test[i[0]] = {id: "I" + count.to_s, group: i[1], itemtext: i[2]}
        count += 1
      end
    end
    measurements = Measurement.where(assessment_id: assessments).pluck(:id, :assessment_id)
    measurements_transfer = {}
    measurements.each do |m|
      if measurements_transfer[m[1]].nil?
        measurements_transfer[m[1]] = [m[0]]
      else
        measurements_transfer[m[1]] = measurements_transfer[m[1]] + [m[0]]
      end
    end
    assessments.each do |a|
      assessments_transfer[a.id] = {test_id: a.test_id,group_id: a.group_id, shorthand: test_transfer[a.test_id][:shorthand], measurement_ids: measurements_transfer[a.id]}
    end
    data_to_transfer[:assessments] = assessments_transfer

    #prepare results for transfer
    results = Result.where(student_id: students)
    results_transfer = []
    results.each do |r|
      prior_result = r.getPriorResult()
      if prior_result == -1 || r.total == prior_result
        total = 0
      elsif r.total > prior_result
        total  = 1
      else
        total = -1
      end
      data = []
      p r
      r.items.each_with_index do |item, index|
        if r.response[0].nil?
        else
          if r.extra_data['answers'].nil?
            if r.extra_data['times'][index].nil?
              data += [{item: items_test[item][:id], group: items_test[item][:group], time: 'NA'}]
            else
              data += [{item: items_test[item][:id], group: items_test[item][:group], time: r.extra_data['times'][index]}]
            end
          else
            if r.extra_data['times'][index].nil?
              data += [{item: items_test[item][:id], group: items_test[item][:group], answer: 'NA', time: 'NA'}]
            else
              data += [{item: items_test[item][:id], group: items_test[item][:group], answer: r.extra_data['answers'][index] ,time: r.extra_data['times'][index]}]
            end
          end

          #TODO: positive, negativ und data füllen
          results_transfer = results_transfer + [{student_id: r.student_id, measurement_id: r.measurement_id, test_date: r.created_at,
                                                  results:{Übersicht: r.total}, report:{total: total, positive:"1", negative:"1" },
                                                  data:[{item:"i1",time:"2", answers:"1"},{item:"i2",time:"2", answers:"1"}], created_at: r.created_at}]
        end
      end
    end
    data_to_transfer[:results] = results_transfer


    #send data to new Levumi
=begin
    uri = URI.parse('http://localhost:4000/recieve')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

    data_to_send = {data: data_to_transfer}
    request.body = data_to_send.to_json

    request["Content-Type"] = "application/json"
    request["Data-Type"] = 'json'
    response = JSON.parse(http.request(request).body)
=end
    response = {}
    response['status']=false
    if response['status']
      @login_user.transferred = true
      @login_user.save

      flash[:notice] = 'Ihre Daten wurden erfolgreich übertragen. Viel Spaß bei der Benutzung von Levumi 2.0!'
      respond_to do |format|
        format.js   {}
      end
    end
  end

  private
  #check if user is logged in
  def check_login
    if session[:user_id].nil? && session[:student_id].nil?
      redirect_to root_url, notice: 'Bitte einloggen!'
    elsif !session[:student_id].nil?
      @login_student = Student.find(session[:student_id])
     else
      @login_user = User.find(session[:user_id])
    end
  end

  #check if user accepted the letter of agreement
  def check_accept
    if !@login_user.nil? && @login_user.tcaccept.nil?
      render 'accept'
    end
  end

end
