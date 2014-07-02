load File.expand_path("../production.rb", __FILE__)

Rails.application.configure do

  config.loglevel = :debug

  # config.airbrake_api_key = 'AIRBRAKE_KEY'

  # used by message model to create links (outside of a controller / mailer)
  Rails.application.routes.default_url_options[:host] = 'APP_NAME.integ.tworedkites.com'

  # config.action_mailer.delivery_method = :mail_gate
  # config.action_mailer.mail_gate_settings = {
  #     :whitelist => /VALIDATE_EMAIL_REGEX/,
  #     :subject_prefix   => '[INTEG] ',
  #     :delivery_method => :smtp,
  #     :smtp_settings => {
  #         :address => 'smtp.example.com'
  #     }
  # }
end
