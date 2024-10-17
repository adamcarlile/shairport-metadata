module ShairportMetadata
  class Configuration

    attr_accessor :mqtt

    def attach_player(name:, topic:)
      players << ShairportMetadata::Player.new(name, topic)
    end

    def player(identifier)
      players.find { |player| player.identify?(identifier) }
    end

    def players
      @players ||= []
    end

  end
end
