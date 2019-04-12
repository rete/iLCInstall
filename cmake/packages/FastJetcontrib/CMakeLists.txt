
# declare package
ilcsoft_package( 
  NAME FastJetcontrib 
  DEPENDS FastJet
  BASE 
)

ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )
ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )
ilcsoft_get_export_package_property( VAR fastjet_install_dir PACKAGE FastJet PROPERTY INSTALL_DIR )

# install the package using wget
ilcsoft_package_install_target(
  MODE WGET
  URL "http://fastjet.hepforge.org/contrib/downloads/fjcontrib-${pkg_version}.tar.gz"
  CONFIGURE_COMMAND ./configure --fastjet-config=${fastjet_install_dir}/bin/fastjet-config
  BUILD_COMMAND make && make fragile-shared-install
  BUILD_IN_SOURCE
)

ilcsoft_export_package()
