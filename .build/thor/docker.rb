class Docker < Thor
  include Thor::Actions

  desc "stop", "stops docker"
  def stop
    run 'docker stop $(docker ps -a -q)'
  end

  desc "app", "docker-compose run app bash"
  def app
    run "docker-compose run app bash"
  end

  desc "build", "docker-compose build"
  def build
    run "docker-compose build"
  end
end