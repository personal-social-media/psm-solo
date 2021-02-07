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
      url = ask <<-TXT.colorize(:green)
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

    print <<-TXT.colorize(:yellow)
Now open another terminal, cd into psm-solo and run:\n
    TXT
    print "docker-compose up nginx_acme\n".colorize(:green)
    print "now you can verify the domain\n"
    ask("Press any key to continue to the next step")
  end

  desc "upload_ssl", "checks zero ssl initial upload"
  def upload_ssl
    file = "/tmp/keys.zip"

    unless File.exist?(file)
      print <<-TXT.colorize(:red)
Now you need to upload the keys using SFTP to /tmp/keys.zip
Change USER, IP to match your server config and run the commands below on your host(not server)
      TXT

      print <<-TXT.colorize(:green)
sftp USER@IP
put IP.zip /tmp/keys.zip

exit
      TXT

      upload_ssl if ask("If ready to check?Types yes").match(/yes/i)
    end

    run "mkdir -p /tmp/ssl"
    inside "/tmp" do
      run "unzip keys.zip -d ssl"
    end

    inside "/tmp/ssl" do
      run "cat certificate.crt ca_bundle.crt >> certificate.crt"
      run "cp mv certificate.crt #{keys_dir}/certificate.crt"
      run "cp mv private.key #{keys_dir}/private.key"
    end

    run "rm /tmp/keys.zip /tmp/ssl -rf"
  end

  no_commands do
    def public_dir
      "#{File.dirname(__FILE__)}/../../app/public"
    end

    def keys_dir
      "#{File.dirname(__FILE__)}/../keys"
    end
  end
end