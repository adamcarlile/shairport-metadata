module ShairportMetadata
  class Track
    include Wisper::Publisher

    attr_accessor :track_id, :album, :artist, :title, :genre
    attr_reader :player, :cover

    def initialize(track_id: nil, album: nil, artist: nil, title: nil, genre: nil, player:)
      @track_id = track_id
      @album = album
      @artist = artist
      @title = title
      @genre = genre
      @player = player
      @broadcast = false
    end

    def cover=(data)
      @cover = Base64.encode64(data)
    end

    def cover_colours
      return [] unless cover
      @cover_colours ||= begin
        file = Tempfile.new(track_id, binmode: true)
        file.write(Base64.decode64(cover))
        colours = Miro::DominantColors.new(file.path).to_hex
        file.close && file.unlink
        colours
      end
    end

    def complete_metadata?
      [track_id, album, artist, title, cover].all?
    end

    def broadcast_change!
      return unless complete_metadata? and !broadcast?
      broadcast(:track_metadata_completed, self, player)  
      @broadcast = true
    end

    def broadcast?
      @broadcast
    end

  end
end
