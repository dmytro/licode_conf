NAME="licode"
BASE="/opt/#{NAME}"

default["licode"]["name"] = NAME

default["licode"]["conf"]="#{NAME}_conf"
default["licode"]["tmpdir"]="/opt/tmp/"

default["licode"]["base"]="/opt/#{NAME}"
default["licode"]["scripts"]="#{BASE}/scripts"

default["licode"]["environment"] = {
  "TMPDIR" => "/opt/tmp"
}
