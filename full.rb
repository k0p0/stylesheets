run 'pgrep spring | xargs kill -9'

# GEMFILE
########################################
run 'rm Gemfile'
file 'Gemfile', <<-RUBY
source 'https://rubygems.org'
ruby '#{RUBY_VERSION}'

gem 'devise'
#gem 'figaro'
gem 'jbuilder', '~> 2.0'
gem 'pg', '~> 0.21'
#gem 'mysql2'
gem 'puma'
gem 'rails', '#{Rails.version}'
gem 'redis'
gem 'autoprefixer-rails'
#gem 'bootstrap-datepicker-rails'
gem 'font-awesome-sass', '~> 5.9.0'
gem 'sassc-rails'
gem 'simple_form'
gem 'uglifier'
gem 'webpacker'


# if Rails.version >= 5.2
gem 'bootsnap', require: false

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'dotenv-rails'
end
RUBY

# Ruby version
########################################
file '.ruby-version', RUBY_VERSION

# Procfile
########################################
file 'Procfile', <<-YAML
web: bundle exec puma -C config/puma.rb
YAML

# Assets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
run 'curl -L https://github.com/k0p0/rails-stylesheets/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/rails-stylesheets-master app/assets/stylesheets'
run 'curl -L https://raw.githubusercontent.com/k0p0/rails-template/master/logo.png > app/assets/images/logo.png'
run 'curl -L https://raw.githubusercontent.com/k0p0/rails-template/master/profil.png > app/assets/images/profil.png'
run 'curl -L https://raw.githubusercontent.com/k0p0/rails-template/master/home.jpg > app/assets/images/home.jpg'

run 'rm app/assets/javascripts/application.js'
file 'app/assets/javascripts/application.js', <<-JS
//= require rails-ujs
//= require_tree .
JS

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')

# Layout
########################################
run 'rm app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.erb', <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <!-- Add these line for detecting device width -->
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
</head>

    <title>MY COMPANY</title>
    <%= csrf_meta_tags %>
    <%= action_cable_meta_tag %>
    <%= stylesheet_link_tag 'application', media: 'all' %>
    <%#= stylesheet_pack_tag 'application', media: 'all' %> <!-- Uncomment if you import CSS in app/javascript/packs/application.js -->
  </head>
  <body>
    <%= render 'shared/navbar' %>
    <%= render 'shared/flashes' %>
          <%= yield %>
    <%= javascript_include_tag 'application' %>
    <%= javascript_pack_tag 'application' %>
    <%= render 'shared/footer' %>
  </body>
</html>
HTML

file 'app/views/shared/_flashes.html.erb', <<-HTML
<% if notice %>
  <div class="alert alert-info alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= notice %>
  </div>
<% end %>
<% if alert %>
  <div class="alert alert-warning alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= alert %>
  </div>
<% end %>
HTML

file 'app/views/shared/_navbar.html.erb', <<-HTML
<div class="navbar-classic">
  <!-- Logo -->
  <%= link_to root_path, class: "navbar-classic-brand" do %>
    <%= image_tag "logo.png" %>
  <% end %>

  <!-- Right Navigation -->
  <div class="navbar-classic-right hidden-xs hidden-sm">

    <% if user_signed_in? %>

      <!-- Links when logged in -->
      <%= link_to "Host", "#", class: "navbar-classic-item navbar-classic-link" %>
      <%= link_to "Trips", "#", class: "navbar-classic-item navbar-classic-link" %>
      <%= link_to "Messages", "#", class: "navbar-classic-item navbar-classic-link" %>

      <!-- Avatar with dropdown menu -->
      <div class="navbar-classic-item">
        <div class="dropdown">
          <%= image_tag "profil.png", class: "avatar dropdown-toggle", id: "navbar-classic-menu", "data-toggle" => "dropdown" %>
          <ul class="dropdown-menu dropdown-menu-right navbar-classic-dropdown-menu">
            <li>
              <%= link_to "#" do %>
                <i class="far fa-user"></i> <%= t(".profile", default: "Profile") %>
              <% end %>
            </li>
            <li>
              <%= link_to "#" do %>
                <i class="fas fa-home"></i>  <%= t(".profile", default: "Home") %>
              <% end %>
            </li>
            <li>
              <%= link_to destroy_user_session_path, method: :delete do %>
                <i class="fas fa-sign-out-alt"></i>  <%= t(".sign_out", default: "Log out") %>
              <% end %>
            </li>
          </ul>
        </div>
      </div>
    <% else %>
      <!-- Login link (when logged out) -->
      <%= link_to t(".sign_in", default: "Login"), new_user_session_path, class: "navbar-classic-item navbar-classic-link" %>
    <% end %>
  </div>

  <!-- Dropdown list appearing on mobile only -->
  <div class="navbar-classic-item hidden-md hidden-lg">
    <div class="dropdown">
      <i class="fas fa-bars dropdown-toggle" data-toggle="dropdown"></i>
      <ul class="dropdown-menu dropdown-menu-right navbar-classic-dropdown-menu">
        <li><a href="#">Some mobile link</a></li>
        <li><a href="#">Other one</a></li>
        <li><a href="#">Other one</a></li>
      </ul>
    </div>
  </div>
</div>
HTML

file 'app/views/shared/_footer.html.erb', <<-HTML
<div class="footer">
  <div class="footer-links">
    <ul class="list-inline text-center">
      <li class="list-inline-item"> <%= Date.today.year %>  <a href="#"><i class="far fa-copyright"></i>  My Company</a></li>
      <li class="list-inline-item">  |  </li>
      <li class="list-inline-item"> <a href="#"><i class="fas fa-university"></i>  Legal terms</a> </li>
      <li class="list-inline-item">  |  </li>
      <li class="list-inline-item"> <a href="#"><i class="fas fa-user-lock"></i>  Access</a> </li>
      <li class="list-inline-item">  |  </li>
      <li class="list-inline-item"> <a href="tel:+33000000000"><i class="fas fa-phone"></i>  +33000000000</a> </li>
      <li class="list-inline-item">  |  </li>
      <li class="list-inline-item"> <a href="mailto:contact@abc.xyz"><i class="fas fa-envelope"></i>  contact@abc.xyz</a> </li>
      <li class="list-inline-item">  |  </li>
      <li class="list-inline-item"> <a href="#"><i class="fas fa-map-marked-alt"></i>  Paris</a> </li>
      <li class="list-inline-item">  |  </li>
      <li class="list-inline-item"> <a href="#"><i class="fab fa-github"></i></a> </li>
      <li class="list-inline-item"> <a href="#"><i class="fab fa-linkedin-in"></i></a> </li>
      <li class="list-inline-item"> <a href="#"><i class="fab fa-facebook-f"></i></a> </li>
      <li class="list-inline-item"> <a href="#"><i class="fab fa-twitter"></i></a> </li>
    </ul>
  </div>
</div>
HTML

file 'app/views/pages/home.html.erb', <<-HTML
<div class="banner" style="background-image: linear-gradient(-225deg, rgba(0,101,168,0.6) 0%, rgba(0,36,61,0.6) 50%), url('/assets/home.jpg');">
  <div class="banner-content">
    <h1>My Company</h1>
    <p>Welcome on our web site</p>
    <a class="btn btn-primary btn-lg">Start now</a>
  </div>
</div>
HTML


# Generators
########################################
generators = <<-RUBY
config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework  :test_unit, fixture: false
    end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Generators: db + simple form + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  rails_command 'webpacker:install'
  generate('simple_form:install', '--bootstrap')
  generate(:controller, 'pages', 'home', '--skip-routes', '--no-test-framework')

  # Routes
  ########################################
  route "root to: 'pages#home'"

  # Git ignore
  ########################################
  run 'rm .gitignore'
  file '.gitignore', <<-TXT
.bundle
log/*.log
tmp/**/*
tmp/*
!log/.keep
!tmp/.keep
*.swp
.DS_Store
public/assets
public/packs
public/packs-test
node_modules
yarn-error.log
.byebug_history
.env*
TXT

  # Devise install + user
  ########################################
  generate('devise:install')
  generate('devise', 'User')

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<-RUBY
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
end
RUBY

  # migrate + devise views
  ########################################
  rails_command 'db:migrate'
  generate('devise:views')

  # Pages Controller
  ########################################
  run 'rm app/controllers/pages_controller.rb'
  file 'app/controllers/pages_controller.rb', <<-RUBY
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end
end
RUBY

  # Environments
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

    # Webpacker / Yarn
  ########################################
  run 'rm app/javascript/packs/application.js'
  run 'yarn add popper.js jquery bootstrap'
  file 'app/javascript/packs/application.js', <<-JS
import "bootstrap";
JS

  inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
<<-JS
const webpack = require('webpack')

// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules');

// Bootstrap 4 has a dependency over jQuery & Popper.js:
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

JS
  end
  # Dotenv
  ########################################
  run 'touch .env'
  # Rubocop
  ########################################
   file '.rubocop.yml', <<-TXT
AllCops:
  Exclude:
    - 'bin/**/*'
    - 'db/**/*'
    - 'config/**/*'
    - 'node_modules/**/*'
    - 'script/**/*'
    - 'support/**/*'
    - 'tmp/**/*'
    - 'test/**/*'

ConditionalAssignment:
  Enabled: false
StringLiterals:
  Enabled: false
RedundantReturn:
  Enabled: false
Documentation:
  Enabled: false
WordArray:
  Enabled: false
AbcSize:
  Enabled: false
MutableConstant:
  Enabled: false
SignalException:
  Enabled: false
Casecmp:
  Enabled: false
CyclomaticComplexity:
  Enabled: false
MissingRespondToMissing:
  Enabled: false
MethodMissingSuper:
  Enabled: false
Style/FrozenStringLiteralComment:
  Enabled: false
LineLength:
  Max: 120
Style/EmptyMethod:
  Enabled: false
Bundler/OrderedGems:
  Enabled: false
TXT

  # Git
  ########################################
#  git :init
#  git add: '.'
#  git commit: "-m 'Initial commit with devise template'"
end
