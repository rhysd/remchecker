require './app'
require 'sinatra/activerecord/rake'

# namespace :db do

  # desc 'Load the seed from db/seeds.rb'
  # task :seed 
# end # namespace :db do

namespace :cron do
  desc "check removers and update followers list"
  task :update_followers do
    require "#{File.dirname(__FILE__)}/lib/helper"
    removers = check_removers_and_update_followers
    removers_str = removers.map(&:screen_name).join ' '
    puts "removed by: #{removers_str}"
  end
end
