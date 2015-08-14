require './lib/envme/version'

Gem::Specification.new "envme", Envme::VERSION do |spec|
  spec.authors       = ["Reppard Walker "]
  spec.email         = ["reppardwalker@gmail.com"]
  spec.description   = spec.summary = "Envme is a Ruby wrapper for envconsul with a few extras."
  spec.homepage      = "https://github.com/reppard/envme"
  spec.license       = "MIT"

  spec.files         = `git ls-files lib README.md spec`.split($/)

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "gem-release", "~> 0.7"
end
