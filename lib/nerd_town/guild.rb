require 'ostruct'

module NerdTown
  class Guild
    attr_reader :realm, :name, :http_connection
    def initialize(options)
      @realm = options.fetch(:realm)
      @name = options.fetch(:name)
      @http_connection = options.fetch(:http_connection, NerdTown.configuration.http_connection)
    end

    def members
      response      = fetch('members')
      rough_members = response['members']

      parse_members(rough_members)
    end

    def basic_info
      response = fetch

      response.body
    end

    def fetch(options= '')
      response = http_connection.get("guild/#{realm.name}/#{name}?fields=#{options}") 

      response.body
    end

    private

    def parse_members(rough_members)
      MemberCollectionParser.new(rough_members).parse
    end

    class MemberCollectionParser
      attr_reader :raw_collection, :collection
      def initialize(raw_collection)
        @raw_collection = raw_collection
        @collection = MemberCollection.new
      end

      def parse
        raw_collection.each do |raw_member|
          char_attrs = raw_member["character"]
          member = GuildMember.new(name: char_attrs["name"],
                                   realm: char_attrs["realm"],
                                   thumbnail: char_attrs["thumbnail"],
                                   class: char_attrs["class"],
                                   rank: raw_member["rank"],
                                   race: char_attrs["race"])

          collection.push(member)
        end

        collection
      end

      private

      class GuildMember
        attr_reader :name, :realm, :thumbnail, :class, :rank, :race
        def initialize(options)
          @name      = options.fetch(:name)
          @realm     = options.fetch(:realm)
          @thumbnail = options.fetch(:thumbnail)
          @class     = options.fetch(:class)
          @rank      = options.fetch(:rank)
          @race      = options.fetch(:race)
        end
      end

      class MemberCollection
        include Enumerable
        attr_reader :collection

        def initialize
          @collection = []
        end

        def each(&block)
          collection.each do |member|
            block.call(member)
          end
        end

        def push(member)
          collection.push(member)
        end
      end
    end
  end
end
