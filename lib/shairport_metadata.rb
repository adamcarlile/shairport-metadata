# frozen_string_literal: true
require 'mqtt'
require 'miro'
require 'wisper'
require 'base64'

require_relative "shairport_metadata/configuration"
require_relative "shairport_metadata/player/event_handler"
require_relative "shairport_metadata/track"
require_relative "shairport_metadata/player"
require_relative "shairport_metadata/version"

module ShairportMetadata
  class Error < StandardError; end

  module_function
  
  def config
    @config ||= ShairportMetadata::Configuration.new
  end

  def configure(&block)
    yield(config)
  end

  def client
    @client ||= MQTT::Client.new(config.mqtt)
  end

  def connect!
    client.connect do |c|
      c.subscribe(config.players.map { |player| player.topic })
      c.get do |topic, message|
        config.player(topic).call(topic.split('/').last, message)
      end
    end
  end

end



