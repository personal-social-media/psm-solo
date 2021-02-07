class Master < Thor
  include Thor::Actions

  desc "setup", "install everything"
  def setup
    s = Setup.new
    repo = Repo.new
    app = App.new
    docker = Docker.new
    daemon = Daemon.new
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
    raise "ok"
    app.invoke(:deps)

    s.invoke(:generate_secrets)
    app.invoke(:create_db)
    app.invoke(:precompile_assets)

    s.login_url

    daemon.invoke(:install)
    daemon.invoke(:enable)
  end
end