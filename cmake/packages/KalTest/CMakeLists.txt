
# declare package
ilcsoft_package( 
  NAME KalTest
  DEPENDS ROOT ILCUTIL
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/KalTest.git"
)

# export the package
ilcsoft_export_package()
