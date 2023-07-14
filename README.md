# Config Files

A list of my config files for various programs.
Also contains some basic scripts that I port between all my systems.

Finally, install.py will install my config files to the correct locations for me based on the profiles defined in config_profiles.json. It will also run the appropriate first_time_setup script for the system if it is Windows or Linux (PowerShell or BASH). The first_time_setup scripts will download and install all the packages I normally use on my systems allowing me to get up and running quickly. The PowerShell script uses Chocolatey for package management while the BASH script uses apt-get.
