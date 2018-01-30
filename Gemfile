source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

if !ENV['APPRAISAL_INITIALIZED'] && !ENV['CI']
  gem 'spree', github: 'spree/spree', branch: 'master'
  gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: 'master'
else
  gem 'spree'
  gem 'spree_auth_devise'
end

gem 'rails-controller-testing'

gemspec
