class Repo < Thor
  include Thor::Actions

  desc "clone", "clones personal-social-media repo"
  def clone
    run "git clone https://github.com/personal-social-media/personal-social-media.git app --depth 1"
  end

  desc "update", "updates the app"
  def update
    inside "./app" do
      run "git checkout Gemfile.lock"
      run "git pull"
    end
  end
end