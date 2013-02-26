#!/usr/bin/env ruby
# encoding: utf-8

module ConfigTwitter extend self
  def client
    require 'twitter'

    @client ||= Twitter::Client.new(
      :consumer_key => '',
      :consumer_secret => '',
      :oauth_token => '',
      :oauth_token_secret => ''
    )
  end # def config_twitter
end # module ConfigTwitter extend self

def add_new_followers(followers, previous_followers)
  previous_followers_ids = previous_followers.map &:uid

  # this doesn't work (rate limit exceeded)
  #   followers = client.followers
  # XXX work around
  followers.each do |user|
    screen_name = user.attrs[:screen_name]
    uid = user.attrs[:id]
    unless previous_followers_ids.include? uid
      Follower.create do |f|
        f.uid = uid
        f.screen_name = screen_name
      end
    end
  end
end

def check_removers(followers, previous_followers)
  removers = []
  previous_followers.each do |follower|
    unless followers.find_index{|f| f.attrs[:id] == follower.uid }
      removers << follower
      new_remover = Remover.create do |r|
        r.uid = follower.uid
        r.screen_name = follower.screen_name
      end
      Follower.delete_all uid: follower.uid
    end
  end

  removers
end

def notify_with_direct_message(removers)
  msg = 'removed by: ' + removers.map{|r| "@#{r.screen_name}(#{r.uid})"}.join(' ')
  if msg.length > 140
    msg = 'removed by: ' + removers.map{|r| r.screen_name}.join(' ')
  end
  client.direct_message_create 'Linda_pp', msg
end

def check_removers_and_update_followers
  require 'active_record'
  require "#{File.dirname(__FILE__)}/../app/models"
  client = ConfigTwitter.client
  previous_followers = Follower.all
  followers = client.users(*client.follower_ids.attrs[:ids])

  add_new_followers followers, previous_followers

  removers = check_removers(followers, previous_followers)

  notify_with_direct_message removers unless removers.empty?

  removers
end
