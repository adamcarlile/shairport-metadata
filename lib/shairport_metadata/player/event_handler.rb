module ShairportMetadata
  class Player
    class EventHandler

      def initialize(player)
        @player = player
      end

      # If the track_id is sent then we should hand that back to the player, as it could indicate a change of track
      def track_id(track_id)
        @player.next_track!(track_id)
      end

      def active_start(*)
        @player.activate!
      end

      def active_end(*)
        @player.deactivate!
      end

      def play_start(*)
        @player.play!
      end

      def play_end(*)
        @player.stop!
      end

      # Player Attribute assignment
      [:volume, :stream_type, :client_ip, :server_ip, :dacp_id, :active_remote_id].each do |attribute|
        define_method(attribute) do |value|
          @player.send("#{attribute}=", value)
        end
      end

      # Track Attribute assignment
      [:album, :artist, :title, :genre].each do |attribute|
        define_method(attribute) do |value|
          @player.now_playing.send("#{attribute}=", value.force_encoding("UTF-8"))
        end
      end

      def cover(data)
        return if data == "--"
        @player.now_playing.cover = data
      end

    end
  end
end
