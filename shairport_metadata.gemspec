# frozen_string_literal: true

require_relative "lib/shairport_metadata/version"

Gem::Specification.new do |spec|
  spec.name = "shairport_metadata"
  spec.version = ShairportMetadata::VERSION
  spec.authors = ["Adam Carlile"]
  spec.email = ["hello@adamcarlile.com"]

  spec.summary = "Consume metadata from Shairport Syncs MQTT output"
  spec.homepage = "https://github.com/adamcarlile/shairport_metadata"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/adamcarlile/shairport_metadata"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  
  spec.add_dependency "mqtt"
  spec.add_dependency "miro"
  spec.add_dependency 'wisper'
  
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
