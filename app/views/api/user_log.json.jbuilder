json.users @logs do |log|
  json.id log.id
  json.user_id log.user.id
  json.name log.user.name
  json.email log.user.email
  if !log.timein.nil?
    json.time_in log.timein.in_time_zone.strftime('%H:%M ')
  end
  if !log.timeout.nil?
    json.time_out log.timeout.in_time_zone.strftime('%H:%M ')
  end

end
