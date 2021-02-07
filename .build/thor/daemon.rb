class Daemon < Thor
  include Thor::Actions

  desc "install", "installs the psm daemon"
  def install
    run <<-SH
echo '#{file_content}' | sudo tee /etc/systemd/system/#{service_name}.service
    SH

    run "sudo systemctl daemon-reload"
  end

  desc "status", "gets the status of the service"
  def status
    print `sudo systemctl status #{service_name}.service`
  end

  desc "start", "stats service"
  def start
    run "sudo systemctl start #{service_name}.service"
  end

  desc "enable", "enable service"
  def enable
    run "sudo systemctl enable #{service_name}.service"
  end

  desc "restart", "restarts service"
  def restart
    `sudo systemctl restart #{service_name}.service`
  end

  no_commands do
    def file_content
      <<-CONF
[Unit]
Description=#{service_name}
After=network.target

[Service]
Type=simple
User=#{ENV["USER"]}

WorkingDirectory=#{Dir.pwd}
ExecStart=#{bundle} install && #{ruby} .build/daemon/app.rb
Restart=always

[Install]
      CONF
    end

    def service_name
      "personal-social-media-daemon"
    end

    def bundle
      `which bundle`.gsub("\n", "")
    end

    def ruby
      `which ruby`.gsub("\n", "")
    end
  end
end