# BetterFx
Making it _easier_ for you to quickly interact with SignalFx in an idiomatic fashion.

## Usage

Usually you just want to indicate that something occurred

```ruby
require "better_fx"
bfx = BetterFx::Client.new
# This will send the value 1 to the SignalFx counter metric named "beans" 
#with the current unix timestamp and vanilla metadata dimensions
bfx.increment_counter :beans
```

Or you might want to report the value of a measurement you've taken

```ruby
require "better_fx"
bfx = BetterFx::Client.new
# This will send the value 11 to the SignalFx gauge metric named
#  "soccer_ball_air_pressure" with the current unix timestamp and vanilla
#  metadata dimensions
bfx.gauge :soccer_ball_air_pressure, value: 11
```

## Configuration

To use BetterFx with the least amount of code, just set the environment variable
`SIGNALFX_API_TOKEN` equal to your token.

If you want to configure it imperatively then

```ruby
require "better_fx"
BetterFx.configure do |c|
    # The SignalFx api token you want to use when transmitting to SignalFx
    c.signalfx_api_token = "ABCD12345"
    # The list of environments for which you want to allow transmission of data to 
    # SignalFx (if the current environment is not in this list then transmissions are
    # skipped).
    # Defaults to `[:production, :prod, "production", "prod"]`
    c.supported_environments = [:local, :prod]
    # The current environment
    # Defaults to `ENV["APP_ENV"] || :production`
    c.current_environment = :local
end
```