class Docker < Thor
  include Thor::Actions

  desc "stop", "stops docker"
  def stop
    run 'docker stop $(docker ps -a -q)'
  end

  desc "stop", "docker-compose stop"
  def stop_all
    run 'docker-compose stop'
  end

  desc "app", "docker-compose run app bash"
  def app
    run "docker-compose run app bash"
  end

  desc "build", "docker-compose build"
  def build
    run "docker-compose build app nginx"
  end

  desc "restart", "docker-compose restart"
  def restart
    run "docker-compose restart"
  end

  desc "daemon", "starts docker-compose as daemon"
  def daemon
    run "docker-compose up -d app sidekiq redis nginx postgres"
  end
end