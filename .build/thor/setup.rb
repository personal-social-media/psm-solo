class Setup < Thor
  include Thor::Actions
  desc "ufw", "enable ufw"
  def ufw
    run "sudo apt-get install -y ufw wget"
    run "sudo ufw allow 22"
    run "sudo ufw allow 80"
    run "sudo ufw allow 443"
    run "sudo ufw enable"
  end

  desc "docker", "install docker"
  def docker
    run "sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y"
    run "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
    run 'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
    run "sudo apt install docker-ce unzip -y"
    run "sudo adduser $USER docker"
    run 'sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
    run "sudo chmod +x /usr/local/bin/docker-compose"
  end

  desc "remove-default-servers", "remove nginx / apache"
  def remove_default_servers
    run "sudo apt remove apache2* nginx -y"
  end

  desc "docker-compose", "generate docker-compose file"
  def docker_compose
    sample = File.read("docker-compose.yml.erb")
    erb = ERB.new(sample)
    @load_balancer_ip = ask("Type the server IP:\n").strip
    @zero_ssl_email = ask("Type your zero ssl email?\nSign up here to get it https://zerossl.com/\n").strip
    @load_balancer_ip = "https://#{@load_balancer_ip}"
    @@load_balancer_ip = @load_balancer_ip
    @pg_password = SecureRandom.hex
    @login_token = SecureRandom.hex 32
    @@login_token = @login_token
    @secret_key_base = SecureRandom.hex 32

    yml = erb.result(binding)
    File.open("docker-compose.yml", "w") do |f|
      f.write yml
    end
  end

  desc "generate-secrets", "generate docker-compose secrets"
  def generate_secrets
    run "docker-compose run app bundle exec rake psm:generate_keys"
  end

  no_commands do
    def login_url
      path = Pathname.new("#{File.dirname(__FILE__)}/../../docker-compose.yml").cleanpath
      docker_compose_yml = YAML.load_file(path)
      env = docker_compose_yml.dig("services", "app", "environment")
      print "Setup done\nNow go to\n\n #{env["LOAD_BALANCER_ADDRESS"]}/session/register?login_token=#{env["LOGIN_TOKEN"]}\n"
    end
  end
end