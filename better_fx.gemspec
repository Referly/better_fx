Gem::Specification.new do |s|
  s.name        = "better_fx"
  s.version     = "0.1.0"
  s.license     = "MIT"
  s.date        = "2016-05-17"
  s.summary     = "A more idiomatic interface to SignalFx."
  s.description = "A convenient gem for developers to interact with SignalFx with a trivial amount of effort"
  s.authors     = ["Courtland Caldwell"]
  s.email       = "engineering@mattermark.com"
  s.files         = `git ls-files`.split("\n") - %w(Gemfile Gemfile.lock)
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.homepage =
    "https://github.com/Referly/better_fx"
  s.add_runtime_dependency "signalfx", "~> 0.1"                         # Apache2 - @link https://github.com/signalfx/signalfx-ruby
  s.add_development_dependency "rspec", "~> 3.2"                        # MIT - @link https://github.com/rspec/rspec/blob/master/License.txt
  s.add_development_dependency "byebug", "~> 3.5"                       # BSD (content is BSD) https://github.com/deivid-rodriguez/byebug/blob/master/LICENSE
  s.add_development_dependency "simplecov", "~> 0.10"                   # MIT - @link https://github.com/colszowka/simplecov/blob/master/MIT-LICENSE
  s.add_development_dependency "rubocop", "~> 0.31"                     # Create Commons Attribution-NonCommerical https://github.com/bbatsov/rubocop/blob/master/LICENSE.txt
  s.add_development_dependency "rspec_junit_formatter", "~> 0.2"        # MIT https://github.com/sj26/rspec_junit_formatter/blob/master/LICENSE
end
