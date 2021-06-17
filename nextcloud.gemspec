# -*- encoding: utf-8 -*-
# stub: nextcloud 1.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "nextcloud".freeze
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "yard.run" => "yri" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dachi Natsvlishvili".freeze, "Robin Fournier".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-06-08"
  s.description = "Nextcloud OCS and WebDAV API endpoints wrapper in Ruby for user provisioning, file and directory\n                        management, sharing (including Federated Cloud Sharing), group and application operations.".freeze
  s.email = ["dachinat@gmail.com".freeze]
  s.files = [".gitignore".freeze, ".rspec".freeze, ".rubocop.yml".freeze, ".ruby-version".freeze, ".travis.yml".freeze, "CODE_OF_CONDUCT.md".freeze, "Gemfile".freeze, "Gemfile.lock".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "lib/nextcloud.rb".freeze, "lib/nextcloud/api.rb".freeze, "lib/nextcloud/errors/nextcloud.rb".freeze, "lib/nextcloud/helpers/nextcloud.rb".freeze, "lib/nextcloud/helpers/properties.rb".freeze, "lib/nextcloud/models/directory.rb".freeze, "lib/nextcloud/models/user.rb".freeze, "lib/nextcloud/ocs/app.rb".freeze, "lib/nextcloud/ocs/file_sharing_api.rb".freeze, "lib/nextcloud/ocs/group.rb".freeze, "lib/nextcloud/ocs/group_folder.rb".freeze, "lib/nextcloud/ocs/user.rb".freeze, "lib/nextcloud/ocs_api.rb".freeze, "lib/nextcloud/version/nextcloud.rb".freeze, "lib/nextcloud/webdav/directory.rb".freeze, "lib/nextcloud/webdav_api.rb".freeze, "nextcloud.gemspec".freeze]
  s.homepage = "https://github.com/dachinat/nextcloud".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.4".freeze
  s.summary = "Nextcloud API in Ruby".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<json>.freeze, ["~> 2.1"])
    s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.8"])
    s.add_runtime_dependency(%q<net-http-report>.freeze, ["~> 0.1"])
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.51"])
    s.add_development_dependency(%q<vcr>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<webmock>.freeze, ["~> 3.1"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<json>.freeze, ["~> 2.1"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.8"])
    s.add_dependency(%q<net-http-report>.freeze, ["~> 0.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.51"])
    s.add_dependency(%q<vcr>.freeze, ["~> 3.0"])
    s.add_dependency(%q<webmock>.freeze, ["~> 3.1"])
  end
end
