json.users @users do |user|
  json.name user.name
  json.email user.email
  json.logs user.logs.all.size
end
