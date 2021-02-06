class Repo < Thor
  include Thor::Actions

  desc "clone", "clones personal-social-media repo"
  def clone
    inside ".build/releases" do
      run "git clone https://github.com/personal-social-media/personal-social-media.git #{release_id} --depth 1"
    end

    run "ln -s .build/releases app"
  end

  desc "update", "updates the app"
  def update
    inside "./app" do
      run "git checkout Gemfile.lock"
      run "git pull origin master"
    end
  end

  no_commands do
    def release_id
      @release_id ||= Time.now.to_i.to_s
    end
  end
end