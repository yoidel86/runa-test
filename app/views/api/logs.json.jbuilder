json.users @logs do |log|
  json.date log.date
  json.time_in log.timein
  json.time_out log.timeout
end
