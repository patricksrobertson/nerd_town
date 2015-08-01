# NerdTown

quick and dirty HTTP Wrapper around the WoW community API.

## Installation

Add this line to your application's Gemfile:

    gem 'nerd_town'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nerd_town

## Usage

Configure:

```rb
NerdTown.configure {|config| config.api_key = 'API KEY'}
```

Use:
```rb
realm = OpenStruct.new(name: 'Anub\'Arak')
guild = NerdTown::Guild.new(realm: realm, name: 'Serenity')

guild_members = guild.members
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nerd_town/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
