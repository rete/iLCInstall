

ilcsoft_package( 
  NAME Eigen 
  BASE 
)

ilcsoft_add_cmake_env( VAR EIGEN_TEST_CXX11 VALUE ON )

# install from archive using wget
ilcsoft_package_install_target(
  MODE GIT_REPO
  URL "https://github.com/eigenteam/eigen-git-mirror.git"
)

ilcsoft_export_package()
