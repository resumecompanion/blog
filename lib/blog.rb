require "devise"
require "simple_form"
require "compass-rails"

require "blog/engine"
require "blog/generators/install_generator"

module Blog
  def self.setup
    yield self
  end
end
