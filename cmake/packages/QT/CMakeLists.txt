
# declare package
ilcsoft_package( 
  NAME QT 
  BASE 
)

ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )

# install the package using git
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "git://code.qt.io/qt/qt.git"
  CONFIGURE_COMMAND ./configure 
    -prefix ${pkg_install_dir} 
    -no-webkit 
    -opensource 
    -confirm-license
    -prefix-install 
    -fast 
    -make libs 
    -no-separate-debug-info 
    -no-xkb 
    -no-xinerama
  BUILD_IN_SOURCE
)

# export variables to init_ilcsoft.sh
ilcsoft_add_export_variable( NAME QTDIR VALUE ${pkg_install_dir} )
# WARNING kept this for backward compatibility. Not sure this is right ...
ilcsoft_add_export_variable( NAME QMAKESPEC VALUE "$QTDIR/mkspecs/linux-g++" )
ilcsoft_add_export_variable( NAME PATH VALUE "$QTDIR/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$QTDIR/lib" )

# export the package
ilcsoft_export_package()
