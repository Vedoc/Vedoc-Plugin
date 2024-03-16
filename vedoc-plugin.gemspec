$LOAD_PATH.push File.expand_path( 'lib', __dir__ )

# Maintain your gem's version:
require 'vedoc/plugin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do | spec |
  spec.name        = 'vedoc-plugin'
  spec.version     = Vedoc::Plugin::VERSION
  spec.authors     = [ 'MaxShend' ]
  spec.email       = [ 'maxshen95@gmail.com' ]
  spec.homepage    = 'https://vedoc.com'
  spec.summary     = 'Vedoc Models.'
  spec.description = 'Vedoc Models.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?( :metadata )
    spec.metadata[ 'allowed_push_host' ] = 'http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir[ '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md' ]

  # spec.add_dependency 'rails', '~> 5.2.1'
  spec.add_dependency 'rails', '>= 5.2.1', '< 6.0.0.beta1'


  spec.add_development_dependency 'sqlite3'
end
