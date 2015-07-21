NAME        = node["licode"]["name"]
CONF        = node["licode"]["conf"]
BASE        = node["licode"]["base"]
SCRIPTS     = node["licode"]["scripts"]
ENVIRONMENT = node["licode"]["environment"]

remote_file "licode_config.js" do
  source "file:///#{SCRIPTS}/licode_default.js"
  path "#{BASE}/licode_config.js"
end

execute "./installErizo.sh" do
  cwd SCRIPTS
  environment ENVIRONMENT
end


execute "./installNuve.sh" do
  cwd SCRIPTS
  environment ENVIRONMENT
end

execute " ./installBasicExample.sh" do
  cwd SCRIPTS
  environment ENVIRONMENT
end

bash 'nohup' do
  cwd SCRIPTS
  code <<-EOCODE
  nohup ./initLicode.sh > initLicode.txt &
  nohup ./initBasicExample.sh > initBasicExample.txt &
  EOCODE
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
