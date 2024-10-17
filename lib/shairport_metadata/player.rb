module ShairportMetadata
  class Player
    include Wisper::Publisher
    attr_accessor :volume, :stream_type, :client_ip, :server_ip, :dacp_id, :active_remote_id
    attr_reader :name, :topic

    def initialize(name, topic)
      @name = name
      @topic = topic
      @playing = false
      @active = false

      subscribe(ShairportMetadata::Player::EventHandler.new(self))
    end

    def identify?(identifier)
      @name == identifier || identifier.start_with?(@topic.delete("#"))
    end

    def call(attribute, value)
      broadcast(attribute, value)
      called!(attribute, value)
    end

    def playing?
      @playing
    end

    def active?
      @active
    end

    def play!
      @playing = true
      broadcast(:playing, self)
    end

    def stop!
      @playing = false
      broadcast(:stopped, self)
    end

    def activate!
      @active = true
      broadcast(:activated, self)
    end

    def deactivate!
      @active = false
      broadcast(:deactivated, self)
    end

    def now_playing
      @now_playing ||= ShairportMetadata::Track.new(player: self)
    end

    def now_playing?(track_id)
      track_id == now_playing.track_id
    end

    def next_track!(track_id)
      return if now_playing?(track_id)
      @now_playing = ShairportMetadata::Track.new(track_id: track_id, player: self)
      broadcast(:track_changed, self)
    end

    private

    def called!(attribute, value)
      broadcast(:message_recieved, attribute, value)
      now_playing.broadcast_change!
    end

  end
end