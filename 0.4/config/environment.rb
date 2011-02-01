# Load the rails application
ENV['RAILS_ENV'] ||= 'production'
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Obri::Application.initialize!

ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",  
    :port                 => 587,  
    :domain               => "obri.chosun.ac.kr",  
    :user_name            => "chosunobri",  
    :password             => "whtjsobri",  
    :authentication       => "plain",  
    :enable_starttls_auto => true  
}

ActionMailer::Base.default_content_type = "text/html"
