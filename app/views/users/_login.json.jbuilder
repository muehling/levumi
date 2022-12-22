json.login do
  json.(
    @login,
    :account_type,
    :capabilities,
    :created_at,
    :email,
    :focus,
    :id,
    :institution,
    :intro_state,
    :last_login,
    :password_digest,
    :school_type,
    :security_digest,
    :state,
    :tc_accepted,
    :town,
    :updated_at
  )
  json.has_tested_students @login.has_tested_students
  json.is_masquerading session[:masquerading]
end
