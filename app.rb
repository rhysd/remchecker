# encoding: utf-8

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader' if development?
require 'active_record'

require './lib/helper'

# establish connection to db
if development?
  db_config = YAML::load_file(File.dirname(__FILE__)+'/config/database.yml')['development']
  ActiveRecord::Base::establish_connection db_config
else
  require 'erb'
  db_config = YAML::load(ERB.new(File.read('config/database.yml')).result)
  ActiveRecord::Base.establish_connection db_config['production']
end

get '/' do
  <<-EOS
  <html>
    <h1>
      "ｲﾇｩ…"
    </h1>
  </html>
  EOS
end # get '/' do

get '/update_followers_and_notify_removers' do
  removedby = check_removers_and_update_followers
  unless removedby.empty?
    html = "<html>\n"
    html += removedby.map{|r| "<a href=\"https://twitter.com/#{r.screen_name}\">#{r.screen_name}(#{r.uid})</a>"}.join("\n")
    html += "</html>"
    html
  else
    ""
  end
end # get '/update_follower_data_and_notify_remove' do

get '/removers' do
  table_html = Remover.all.inject("") do |html, remover|
    html += <<-EOS.gsub(/^\s\+/, '')
      <tr>
        <td>#{remover.screen_name}</td>
        <td>#{remover.uid}</td>
        <td>#{remover.created_at}</td>
      </tr>
    EOS
  end
  <<-EOS
<html>
  <table>
    #{table_html}
  </table>
</html>
  EOS
end # get '/history_of_removers' do
