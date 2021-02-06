class Repo < Thor
  include Thor::Actions

  desc "clone", "clones personal-social-media repo"
  def clone
    inside ".build/releases" do
      run "git clone https://github.com/personal-social-media/personal-social-media.git #{release_id} --depth 1"
    end

    run "ln -s .build/releases/#{release_id} app"
  end

  desc "finish-deploy", "ln -s the new deploy"
  def finish_deploy
    run "ln -s .build/releases/#{release_id} app"
  end

  no_commands do
    def release_id
      @release_id ||= Time.now.to_i.to_s
    end
  end
end