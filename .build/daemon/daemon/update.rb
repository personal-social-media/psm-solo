class Update
  def run
    fetch_repo
    update_app
  end

  def fetch_repo
    repo.invoke(:update)
  end

  def update_app
    app.invoke(:deps)
    app.invoke(:migrate_db)
    app.invoke(:precompile_assets)
  end

  def repo
    @repo ||= Repo.new
  end

  def app
    @app ||= App.new
  end
end