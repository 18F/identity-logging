# identity-logging


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'identity-logging', github: '18F/identity-logging'
```

## Usage

**The Railtie for logging (which sets up `lograge`) must be loaded explicitly**

In your `application.rb`, add:

```ruby
require 'identity/logging/railtie'
```

The gem adds some keys to the log payload, and removes ones that often contain sensitive values
like `headers` and `params`, see [railtie.rb](lib/identity/logging/railtie.rb) for the specifis.

### Recommended: Update `production.rb`

Rails defaults to a few options in `production.rb` that take precedence over changes from this gem.
Remove these lines to get logs as intended:

```diff
# config/environments/production.rb
-  # Use the lowest log level to ensure availability of diagnostic information
-  # when problems arise.
-  config.log_level = :debug
+  config.log_level = :info

-  # Prepend all log lines with the following tags.
-  config.log_tags = [:request_id]

-  # Use default logging formatter so that PID and timestamp are not suppressed.
-  config.log_formatter = ::Logger::Formatter.new
```

### Recommended: User Data

For apps that have user data, we recommend adding that into to the payload. lograge will
automatically call `ApplicationController#append_info_to_payload` if it exists. Here's an example:

```ruby
# application_controller.rb

# for lograge
def append_info_to_payload(payload)
  payload[:user_id] = user.id # this depends on your application's user model
end
```

### Recommended: Ignore Action

To filter events out of logging if they're noisy, use `ignore_actions` like this:

```ruby
# config/environments/development.rb

config.lograge.ignore_actions = ['Users::SessionsController#active']
```