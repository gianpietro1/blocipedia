if Rails.env.development?
 $redis = Redis.new(:host => 'localhost', :port => 6379)
elsif Rails.env.production?
 $redis = Redis.new(:url => ENV['REDISTOGO_URL'])
end