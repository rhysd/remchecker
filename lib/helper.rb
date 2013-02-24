#!/usr/bin/env ruby
# encoding: utf-8

def twitter_client
  require 'twitter'

  Twitter::Client.new(
    :consumer_key => '',
    :consumer_secret => '',
    :oauth_token => '',
    :oauth_token_secret => ''
  )
end

def check_removers_and_update_follwers
  require 'active_record'
  require "#{File.dirname(__FILE__)}/../app/models"
  client = twitter_client
  previous_followers = Follower.all
  previous_followers_ids = previous_followers.map &:uid

  # this doesn't work (rate limit exceeded)
  #   followers = client.followers
  # XXX work around
  followers = client.users(*client.follower_ids.attrs[:ids])

  # register new follwers to DB
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

  # check removers
  removers = []
  previous_followers.each do |follower|
    unless followers.find_index{|f| f.attrs[:id] == follower.uid }
      removers << follower
      new_remover = Remover.create do |r|
        r.uid = follwer.uid
        r.screen_name = follwer.screen_name
      end
      Follower.delete_all uid: follower.uid
    end
  end

  unless removers.empty?
    msg = 'removers: ' + join(removers.map{|r| "#{r.screen_name}(#{r.uid})"}, ' ')
    if msg.length > 140
      msg = 'removers: ' + join(removers.map{|r| r.screen_name}, ' ')
    end
    client.direct_message_create 'Linda_pp', msg
  end

  removers
end
