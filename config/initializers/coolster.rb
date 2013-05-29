if Rails.env == 'development'
  COOLSTER_URL = "localhost:9292"
elsif Rails.env == 'production'
  COOLSTER_URL = ""
end