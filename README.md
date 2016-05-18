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
