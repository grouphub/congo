# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'templates', 'admin')

Rails.application.config.assets.precompile += [
  'glyphicons-halflings-regular.eot',
  'glyphicons-halflings-regular.woff',
  'glyphicons-halflings-regular.ttf',
  'fontawesome-webfont.eot',
  'fontawesome-webfont.woff',
  'fontawesome-webfont.ttf',
  'fontawesome-webfont.svg'
]
