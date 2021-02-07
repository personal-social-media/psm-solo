require "thor"
Dir[File.join(__dir__, "/daemon/**/*.rb")].each { |file| require file }

Dir[File.join(__dir__, "/../thor/**/*.rb")].each { |file| require file }

loop do
  if FetchLatestCommit.new.new_update?
    Update.new.run
  elsif FetchLatestCommitSelf.new.new_update?
    Update.new.run_self
  end

  sleep rand(600..900)
end