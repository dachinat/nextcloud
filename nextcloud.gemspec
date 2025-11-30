lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nextcloud/version/nextcloud"

Gem::Specification.new do |spec|
  spec.name          = "nextcloud"
  spec.version       = Nextcloud::Version::VERSION
  spec.authors       = ["Dachi Natsvlishvili"]
  spec.email         = ["dachinat@gmail.com"]
  spec.summary       = "Nextcloud API in Ruby"
  spec.description   = "Nextcloud OCS and WebDAV API endpoints wrapper in Ruby for user provisioning, file and directory
                        management, sharing (including Federated Cloud Sharing), group and application operations."
  spec.homepage      = "https://github.com/dachinat/nextcloud"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1.3"
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["yard.run"] = "yri"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", ">= 5.0", "< 8.1"
  spec.add_runtime_dependency "json", "~> 2.7.1"
  spec.add_runtime_dependency "nokogiri", "~> 1.15"
  spec.add_runtime_dependency "net-http-report", "~> 0.3"

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 13.1" #
  spec.add_development_dependency "rspec", "~> 3.12.0"
  spec.add_development_dependency "rubocop", "~> 1.59"
  spec.add_development_dependency "vcr", "~> 6.2"
  spec.add_development_dependency "webmock", "~> 3.19"
end
