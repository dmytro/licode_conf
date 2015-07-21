NAME        = node["licode"]["name"]
CONF        = node["licode"]["conf"]
BASE        = node["licode"]["base"]
SCRIPTS     = node["licode"]["scripts"]
ENVIRONMENT = node["licode"]["environment"]


bash "start" do

  cwd SCRIPTS
  environment ENVIRONMENT

  code(<<-EOCODE
  killall node

  /etc/init.d/mongodb restart
  nohup ./initLicode.sh 2>&1 >  initLicode.txt &
  sleep 10
  nohup ./initBasicExample.sh 2>&1 > initBasicExample.txt &

  killall node
  sleep 60
  nohup ./initLicode.sh 2>&1 >  initLicode.txt &
  sleep 10
  nohup ./initBasicExample.sh 2>&1 > initBasicExample.txt &

  EOCODE
    )
end
