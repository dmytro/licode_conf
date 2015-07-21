
Overview
-----------

Setup consists of

- intstallation script `install.sh`
- Chef-solo cookbook `cookbooks/licode`
- JSON configuration file `licode.json`

Intstallation script (`install.sh`):

- installs:
  - RVM
  - Ruby
  - Chef
- Runs chef-solo with provided `licode.json` file


Run installation as
----------------------


    sudo ./install.sh licode.json


Start log of the initLicode.sh and initBasicexample.sh are stored to
file /etc/run log (see file
cookbooks/licode/recipes/licode_config.rb).



Updates to the installtion commands during the implementation
-------------------------------------------------------------

    - npm install nuve : does not exist, using nuve-server,
      nuve-client instead

    - rabitmq-server - not listed in install commands

    - scripts in /opt/licode/script - don't have 'x' permission set,
      fails to run script

    - same with all `configure` script - don't have 'x' permission
      set, fails to run build

    - NPM fails to install from apt-get when Chris Lea repo in
      installed, added not_if condition. NPM installation only
      attempted on first run of the recipe.


Known issue
-----------

On newly build server after first run, fails to start with the
below message in /tmp/runlog. Next run fixes the issue, multiple runs
of the recipe are OK.

### message

    module.js:340
        throw err;
          ^
    Error: Cannot find module './nuve'
        at Function.Module._resolveFilename (module.js:338:15)
        at Function.Module._load (module.js:280:25)
        at Module.require (module.js:364:17)
        at require (module.js:380:17)
        at Object.<anonymous> (/opt/licode/extras/basic_example/basicServer.js:7:9)
        at Module._compile (module.js:456:26)
        at Object.Module._extensions..js (module.js:474:10)
        at Module.load (module.js:356:32)
        at Function.Module._load (module.js:312:12)
        at Function.Module.runMain (module.js:497:10)



Author: Dmytro Kovalov
