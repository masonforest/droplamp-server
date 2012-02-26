require 'sinatra'
require 'open-uri'
require 'pp'
require 'pp'
require 'uri'
db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/droplamp')
require 'active_record'
require 'uri'

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)




require 'action_dispatch'
require './site.rb'
require './user.rb'
#$stdout.sync = true
#set :lock, true

get '/*' do
  uri = URI(request.url)
  uri.path= "/index.html" if uri.path == "/"
  content_type Mime::Type.lookup_by_extension(File.extname(uri.path[1..-1])[1..-1]).to_s

  puts uri.path
  key = "./tmp/cache/#{uri.host}#{uri.path}"
  if File.exists?(key)
    puts "cache!"
    response=IO.read(key) 
  else
    puts uri.path
    response = Site.first.get(uri.path)
    FileUtils.mkdir_p(Pathname.new(key).dirname)
    File.open(key, 'w') {|f| f.write(response) }  
  end
  
  response
end



