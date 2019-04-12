
# declare package
ilcsoft_package( 
  NAME PathFinder
  DEPENDS ROOT
)

# install the git repo
ilcsoft_package_install_target(
  MODE SVN_REPO 
  URL "https://svnsrv.desy.de/public/pathfinder"
)

# export the package
ilcsoft_export_package()
