desc "check removers and update followers list"
task :update => :environment do
  require "#{File.dirname(__FILE__)}/../helper"
  check_removers_and_update_follwers
end
