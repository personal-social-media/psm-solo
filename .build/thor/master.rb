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
    zero_ssl.invoke(:acme_check)
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
    s.invoke(:generate_secrets)
    app.invoke(:create_db)
    app.invoke(:precompile_assets)

    s.login_url

    daemon.invoke(:install)
    daemon.invoke(:enable)
  end
end