
# declare package
ilcsoft_package( 
  NAME DDKalTest
  DEPENDS LCIO KalTest aidaTT GSL
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/DDKalTest.git"
)

# export the package
ilcsoft_export_package()
