
# declare package
ilcsoft_package( 
  NAME MarlinTrk
  DEPENDS LCIO GEAR GSL Marlin MarlinUtil KalTest KalDet ROOT DDKalTest DD4hep aidaTT
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/MarlinTrk.git"
)

# export the package
ilcsoft_export_package()
