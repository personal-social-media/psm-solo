class App < Thor
  include Thor::Actions

  desc "deps", "install ruby gems and node modules"
  def deps
    run "docker-compose run app bundle install --jobs 4 --without development test"
  end

  desc "create-db", "creates the db"
  def create_db
    run "docker-compose run app bundle exec rake db:create db:setup"
  end

  desc "precompile-assets", "precompiles assets"
  def precompile_assets
    run "docker-compose run app rails assets:precompile"
  end

  desc "migrate-db", "migrates the db"
  def migrate_db
    run "docker-compose run app bundle exec rake db:migrate"
  end

  desc "restart", "restarts the server"
  def restart
    run "docker-compose restart --timeout 600 app sidekiq"
  end

  desc "logs", "show logs"
  def logs
    print "print this to get the logs\ntail -f app/log/production.log\n"
  end

  desc "cities", "download cities"
  def cities
    run "docker-compose run app bundle exec rake psm:download_cities"
  end
end