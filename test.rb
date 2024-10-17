require_relative "lib/shairport_metadata"
require 'pry'

ShairportMetadata.configure do |config|
  config.mqtt = {
    host: "hydra.home.adamcarlile.com",
    port: 1883
  }
  
  config.attach_player(name: 'Dining Room', topic: "audio/shairport-sync/dining-room/#")
end

class Listener

  def track_metadata_completed(track, player)
    puts "Track Change for #{player.inspect}: #{track.inspect}"
    puts "Cover Colours: #{track.cover_colours}"
  end

  def track_updated(track)
    puts "Track Updated: #{track.inspect}"
  end

  def stopped_playing(player)
    puts "Stopped Playing: #{player.inspect}"
  end

  def started_playing(player, track)
    puts "Started Playing: #{player.inspect} - #{track.inspect}"
  end

end

Wisper.subscribe(Listener.new)

ShairportMetadata.connect!
