
# declare package
ilcsoft_package( 
  NAME CED 
  DEPENDS ILCUTIL
  BASE 
)

# CED server option
option( CED_SERVER "Set to ON to build the glced server" ON )

# keep the old check for backward compatibility
if( CED_SERVER )
  if( APPLE )
    if( NOT EXISTS "/usr/X11/include/GL/glut.h" 
    AND NOT EXISTS "/System/Library/Frameworks/GLUT.framework/Versions/A/Headers/glut.h")
      message( WARNING "glut not found in your system!! CED_SERVER forced to OFF" )
      set( CED_SERVER OFF )
    endif()
  else()
    if( NOT EXISTS "/usr/include/GL/glut.h" 
    AND NOT EXISTS "/usr/include/glut.h")
      message( WARNING "glut not found in your system!! CED_SERVER forced to OFF" )
      set( CED_SERVER OFF )
    endif()
  endif()
endif()

ilcsoft_add_cmake_env( VAR CED_SERVER VALUE ${CED_SERVER} )

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/CED.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME PATH VALUE ${install_dir}/bin )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE ${install_dir}/lib )

# export the package
ilcsoft_export_package()
