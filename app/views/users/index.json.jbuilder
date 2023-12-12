json.users @users.sort_by { |u| u[:id] }
json.total_users User.count
