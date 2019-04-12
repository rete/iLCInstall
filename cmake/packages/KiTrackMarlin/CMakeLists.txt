
# declare package
ilcsoft_package( 
  NAME KiTrackMarlin
  DEPENDS KiTrack MarlinTrk GSL DD4hep
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/KiTrackMarlin.git"
)

# export the package
ilcsoft_export_package()
