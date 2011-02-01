ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",  
    :port                 => 587,  
    :domain               => "obri.chosun.ac.kr",  
    :user_name            => "chosunobri",  
    :password             => "whtjsobri",  
    :authentication       => "plain",  
    :enable_starttls_auto => true  
}