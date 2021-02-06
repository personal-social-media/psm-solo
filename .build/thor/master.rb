class Master < Thor
  include Thor::Actions

  desc "setup", "install everything"
  def setup
    s = Setup.new
    repo = Repo.new
    app = App.new
    docker = Docker.new

    s.invoke(:ufw)
    s.invoke(:docker)
    if ask("Type yes/no if you want to remove existing nginx / apache").match /yes/i
      s.invoke(:remove_default_servers)
    end
    repo.invoke(:clone)
    s.invoke(:docker_compose)
    docker.invoke(:build)
    app.invoke(:deps)

    s.invoke(:generate_secrets)
    app.invoke(:create_db)
    app.invoke(:precompile_assets)

    s.login_url
  end
end