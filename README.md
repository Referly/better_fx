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

## OO functionality

Usually you'll be reporting the same measurement over and over and the gauge syntax is a bit
 too functional
 
In the following example we have an imaginary worker that is invoked like so:

```ruby
TelemetricWorker.new.run
```

It's implementation is ...

```ruby
class TelemetricWorker
  include BetterFx::Measurement
  attr_accessor :filename
  
  measurement :file_size do |worker|
    File.size worker.filename
  end
  
  def step_gets_file
    # get file from s3
  end
  
  def step_does_other_thing
    # use your imagination
  end
  
  def run
    step_gets_file
    measure :file_size
    step_does_other_thing
  end
end
```

This way everytime `#run` is executed the file_size measurement is sent to SignalFx. Note this functionality is 
currently available for measurements (gauges) only.

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