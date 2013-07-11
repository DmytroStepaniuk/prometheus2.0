# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "awesome_nested_set"
  s.version = "2.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brandon Keepers", "Daniel Morrison", "Philip Arndt"]
  s.date = "2013-07-10"
  s.description = "An awesome nested set implementation for Active Record"
  s.email = "info@collectiveidea.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["lib/awesome_nested_set", "lib/awesome_nested_set/version.rb", "lib/awesome_nested_set/helper.rb", "lib/awesome_nested_set/iterator.rb", "lib/awesome_nested_set/model.rb", "lib/awesome_nested_set/set_validator.rb", "lib/awesome_nested_set/move.rb", "lib/awesome_nested_set/tree.rb", "lib/awesome_nested_set/awesome_nested_set.rb", "lib/awesome_nested_set/model", "lib/awesome_nested_set/model/validatable.rb", "lib/awesome_nested_set/model/prunable.rb", "lib/awesome_nested_set/model/movable.rb", "lib/awesome_nested_set/model/transactable.rb", "lib/awesome_nested_set/model/relatable.rb", "lib/awesome_nested_set/model/rebuildable.rb", "lib/awesome_nested_set/columns.rb", "lib/awesome_nested_set.rb", "MIT-LICENSE", "README.rdoc", "CHANGELOG"]
  s.homepage = "http://github.com/collectiveidea/awesome_nested_set"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "An awesome nested set implementation for Active Record"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 4.0.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.12"])
      s.add_development_dependency(%q<rake>, ["~> 10"])
      s.add_development_dependency(%q<combustion>, [">= 0.3.3"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, ["~> 4.0.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.12"])
      s.add_dependency(%q<rake>, ["~> 10"])
      s.add_dependency(%q<combustion>, [">= 0.3.3"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 4.0.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.12"])
    s.add_dependency(%q<rake>, ["~> 10"])
    s.add_dependency(%q<combustion>, [">= 0.3.3"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
  end
end