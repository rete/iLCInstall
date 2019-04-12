
# declare package
ilcsoft_package( 
  NAME KiTrack
  DEPENDS Marlin ROOT
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/KiTrack.git"
)

# export the package
ilcsoft_export_package()
