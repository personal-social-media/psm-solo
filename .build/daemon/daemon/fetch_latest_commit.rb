class FetchLatestCommit
  def new_update?
    p "checking for update #{Time.now.to_i}"
    return false if existing == fetch_latest_commit
    File.open(commit_file, "w") do |f|
      f.write fetch_latest_commit
    end
    true
  end

  def fetch_latest_commit
    @fetch_latest_commit ||= `git ls-remote https://github.com/personal-social-media/personal-social-media.git  grep refs/heads/master | cut -f 1`
  end

  def existing
    return nil unless File.exist?(commit_file)
    File.read(commit_file)
  end


  def commit_file
    "#{File.dirname(__FILE__)}/../tmp/commit"
  end
end