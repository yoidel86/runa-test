json.users @logs do |log|
  json.id log.id
  json.user_id log.user.id
  json.name log.user.name
  json.email log.user.email
end
