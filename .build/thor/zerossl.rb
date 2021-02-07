class Zerossl < Thor
  include Thor::Actions

  desc "acme_check", "solves acme"
  def acme_check
    print <<-TXT.colorize(:yellow)
Please setuo your certificate for your IP
https://app.zerossl.com/certificate/new

Then select verification Method: HTTP File Upload
copy paste the link like
    TXT
    url = nil
    until url&.match(/well-known/)
      url = ask <<-TXT.colorize(:blue)
http://161.97.64.223/.well-known/pki-validation/A2D86497634737C68224ECE19F21F7DC.txt
      TXT
    end

    file_name = URI.parse(url).path
    bak_end = $/
    $/ = "END"

    print <<-TXT.colorize(:yellow)
Now Download the Auth File and paste the content,
Type END after the input
    TXT
    content = STDIN.gets.gsub("END", "")

    $/ = bak_end
    path = public_dir + file_name
    FileUtils.mkdir_p(path.split("/")[0..-2].join("/"))
    File.open(path, "w") do |f|
      f.write(content)
    end
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

      print <<-TXT
docker-compose up nginx_acme
      TXT
    end
  end

  no_commands do
    def public_dir
      "#{File.dirname(__FILE__)}/../../app/public"
    end
  end
end