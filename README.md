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

## Configuration

To use BetterFx with the last amount of code, just set the environment variable
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
    # Defaults to [:production]
    c.supported_environments = [:local, :prod]
    # The current environment
    # Defaults to :production
    c.current_environment = :local
end
```