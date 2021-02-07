require "thor"
Dir[File.join(__dir__, "/daemon/**/*.rb")].each { |file| require file }

Dir[File.join(__dir__, "/../thor/**/*.rb")].each { |file| require file }

loop do
  if FetchLatestCommit.new.new_update?
    p "ok"
  end

  sleep rand(600..900)
end