class App < Thor
  include Thor::Actions

  desc "deps", "install ruby gems and node modules"
  def deps
    run "docker-compose run app bundle install --jobs 4 --without development test"
    run "docker-compose run app yarn install"
  end


  desc "create-db", "creates the db"
  def create_db
    run "docker-compose run app bundle exec rake db:create db:setup"
  end

  desc "precompile-assets", "precompiles assets"
  def precompile_assets
    run "docker-compose run app rails assets:precompile"
  end
end