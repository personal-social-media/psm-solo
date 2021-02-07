class Master < Thor
  include Thor::Actions

  desc "setup1", "install step 1"
  def setup1
    s = Setup.new
    repo = Repo.new
    docker = Docker.new
    zero_ssl = Zerossl.new

    s.invoke(:ufw)
    s.invoke(:docker)
    if ask("Type yes/no if you want to remove existing nginx / apache").match /yes/i
      s.invoke(:remove_default_servers)
    end
    repo.invoke(:clone)
    s.invoke(:docker_compose)
    docker.invoke(:build)
  end

  desc "setup2", "install step 2"
  def setup2
    zero_ssl = Zerossl.new
    zero_ssl.invoke(:acme_check)
    zero_ssl.invoke(:upload_ssl)
  end

  desc "setup3", "install step 3"
  def setup3
    s = Setup.new
    app = App.new
    daemon = Daemon.new
    docker = Docker.new
    app.invoke(:deps)
    s.invoke(:generate_secrets)
    app.invoke(:create_db)
    app.invoke(:cities)
    app.invoke(:precompile_assets)

    daemon.invoke(:install)
    daemon.invoke(:start)
    daemon.invoke(:enable)
    docker.invoke(:daemon)

    s.login_url
  end
end