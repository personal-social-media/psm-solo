class Zerossl < Thor
  include Thor::Actions

  desc "acme_check", "solves acme"
  def acme_check
    print <<-TXT.colorize(:yellow)
Before starting, please sign up at 
https://app.zerossl.com/certificate/new
to get your ssl certificate for your server IP.

Please type in your
    TXT
  end

  desc "check_for_files", "checks zero ssl initial upload"
  def check_for_files
    file = "/tmp/keys.zip"

    unless File.exist?(file)
      print <<-TXT.colorize(:red)
Before starting, please sign up at 
https://app.zerossl.com/certificate/new

to get your ssl certificate for your server IP.
after that please upload it to /tmp/keys.zip

Change USER, IP to match your server config and run the commands below on your host(not server)
      TXT

      print <<-TXT.colorize(:blue)
sftp USER@IP
put ~/Downloads/IP.zip /tmp/keys.zip

exit
      TXT

      check_for_files if ask("If ready to check?Types yes").match(/yes/)
    end
  end
end