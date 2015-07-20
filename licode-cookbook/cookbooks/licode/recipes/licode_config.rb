NAME        = node["licode"]["name"]
CONF        = node["licode"]["conf"]
TMPDIR      = "/opt/tmp/"

BASE        = node["licode"]["base"]
SCRIPTS     = node["licode"]["scripts"]

ENVIRONMENT = node["licode"]["environment"]

# package %w{ nodejs npm }

%w{  express node-getopt body-parser socket.io amqp mongojs log4js net nuve-server nuve-client fs http https formidable forever fs-extra http-proxy }.map do |pkg|
  execute  "npm install #{pkg}" do
    not_if "npm list #{pkg} | grep #{pkg}"
  end
end

%w{licode_config.js package.json }.map do |cfg|
  remote_file cfg do
    source "file:///opt/#{ CONF }/config/#{ cfg }"
    path "#{ BASE }/#{ cfg }"
  end
end

remote_file "basicServer.js" do
  source "file:///opt/#{ CONF }/config/basicServer.js"
  path "#{ BASE }/extras/basicServer.js"
end

bash "start" do

  cwd SCRIPTS
  environment ENVIRONMENT

  code(<<-EOCODE
  ( set -x; \
  killall node ; \
  /etc/init.d/mongod restart; \
  chmod +x initLicode.sh initBasicExample.sh; \
  nohup ./initLicode.sh 2>&1 >  initLicode.txt & \
  nohup ./initBasicExample.sh 2>&1 > initBasicExample.txt & ) 2>&1 > /tmp/runlog
  EOCODE
    )
end
