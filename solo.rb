root = ENV["CHEF_SOLO_PROFILE_ROOT"] || File.absolute_path(File.dirname(__FILE__))
root << "profiles/#{ENV["CHEF_SOLO_PROFILE"]}" if ENV["CHEF_SOLO_PROFILE"]


file_cache_path root
cookbook_path ["#{root}/cookbooks", "#{root}/site-cookbooks"]
role_path     "#{root}/roles"
data_bag_path "#{root}/data_bags"

log_level :fatal
log_location STDOUT
