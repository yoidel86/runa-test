json.report do
  json.date @report.date
  json.desde @report.from
  json.hasta @report.to
end
json.logs @logs do |log|
  json.date log.date
  if !log.timein.nil?
    json.time_in log.timein.in_time_zone.strftime('%H:%M ')
  end
  if !log.timeout.nil?
    json.time_out log.timeout.in_time_zone.strftime('%H:%M ')
  end
end
