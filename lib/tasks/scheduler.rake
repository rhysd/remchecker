desc "check removers and update followers list"
task :update => :environment do
  require "#{File.dirname(__FILE__)}/../helper"
  removers = check_removers_and_update_follwers
  removers_str = removers.map(&:screen_name).join ' '
  puts "removed by: #{removers_str}"
end
