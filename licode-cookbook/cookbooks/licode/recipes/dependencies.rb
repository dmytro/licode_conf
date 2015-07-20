package "expect"

bash "install_ubuntu_deps" do
  user "root"
  cwd "/opt/licode/scripts"
  environment 'TMPDIR' => "/opt/tmp/"

  code <<-EOF
    /usr/bin/expect -c 'spawn ./installUbuntuDeps.sh
    expect "[press Enter]"
    send "\r"
    expect "[press Enter]"
    send "\r"
    expect "[press Enter]"
    send "\r"
    expect "[press Enter]"
    send "\r"
    expect "[press Enter]"
    send "\r"
    expect "use the --enable-gpl option"
    send "\r"
    expect eof'
    EOF
end
