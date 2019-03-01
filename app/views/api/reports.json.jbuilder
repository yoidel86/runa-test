json.reports @reports do |report|
  json.from report.from
  json.id report.id
  json.to report.to
  json.date report.date
  json.result report.result
  json.user_id report.user.id
  json.user_name report.user.name
  json.user_email report.user.email
end