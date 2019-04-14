
# declare package
ilcsoft_package(
  NAME ILDConfig
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO
  URL "https://github.com/iLCSoft/ILDConfig.git"
  SOURCE_INSTALL
  NO_INSTALL
  CONFIGURE_COMMAND echo "No configure command to run for ILDConfig!"
  BUILD_COMMAND echo "No build for ILDConfig !"
)

# export the package
ilcsoft_export_package()
