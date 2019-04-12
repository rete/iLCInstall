
# declare package
ilcsoft_package( 
  NAME KalDet
  DEPENDS KalTest Marlin MarlinUtil GEAR ROOT
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/MarlinReco.git"
)

# populate MARLIN_DLL property
ilcsoft_package_add_marlindll()

# export the package
ilcsoft_export_package()
