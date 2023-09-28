json.user do
  if @user
    json.security_digest @user.security_digest
  else
    json.security_digest ''
  end
end
