json.dashboard do
  json.total @total_logs
  json.in_not_out @logs_in_not_out
  json.in_with_out @logs_in_and_out
  json.total_by_user @logs_by_user
  json.today @logs_today.to_f
end
