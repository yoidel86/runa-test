# default class to manage mail on application
class ApplicationMailer < ActionMailer::Base
  default from: 'admin@runa.com'
  layout 'mailer'
end
