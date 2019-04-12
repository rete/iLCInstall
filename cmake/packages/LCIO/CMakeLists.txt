
# LCIO options
option( LCIO_JAVA_SUPPORT        "Compile LCIO with Java support" OFF )
option( LCIO_JAVA_USE_MAVEN      "Set to ON to build/install lcio.jar using maven" OFF )
option( LCIO_FORTRAN_SUPPORT     "Compile LCIO with Fortran support" OFF )
option( LCIO_BUILD_ROOTDICT      "Compile LCIO ROOT dictionaries" ON )
option( LCIO_GENERATE_HEADERS    "Set to OFF to use pre-generated headers" OFF )
option( LCIO_BUILD_EXAMPLES      "Set to ON to build LCIO examples" ON )

if( LCIO_JAVA_SUPPORT OR LCIO_GENERATE_HEADERS )
  find_package( Java REQUIRED )
  if( NOT Java_FOUND )
    message( FATAL_ERROR "Couldn't find Java for LCIO. Please set LCIO_JAVA_SUPPORT/LCIO_GENERATE_HEADERS to OFF or install Java!" )
  endif()
endif()

set( LCIO_DEPENDS )
if( LCIO_BUILD_ROOTDICT )
  list( APPEND LCIO_DEPENDS ROOT )
endif()

# declare package
if( LCIO_DEPENDS )
  ilcsoft_package( 
    NAME LCIO
    DEPENDS ${LCIO_DEPENDS}
  )
else()
  # declare package
  ilcsoft_package( 
    NAME LCIO
  )
endif()

# setup cmake env
ilcsoft_add_cmake_env( VAR INSTALL_JAR VALUE ${LCIO_JAVA_SUPPORT} )
if( LCIO_JAVA_SUPPORT )
  ilcsoft_add_cmake_env( VAR LCIO_JAVA_USE_MAVEN VALUE ${LCIO_JAVA_USE_MAVEN} )
endif()
ilcsoft_add_cmake_env( VAR BUILD_LCIO_EXAMPLES VALUE ${LCIO_BUILD_EXAMPLES} )
ilcsoft_add_cmake_env( VAR BUILD_F77_TESTJOBS VALUE ${LCIO_FORTRAN_SUPPORT} )
ilcsoft_add_cmake_env( VAR LCIO_GENERATE_HEADERS VALUE ${LCIO_GENERATE_HEADERS} )
ilcsoft_add_cmake_env( VAR BUILD_ROOTDICT VALUE ${LCIO_BUILD_ROOTDICT} )


# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/lcio.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME LCIO VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$LCIO/tools:$LCIO/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$LCIO/lib" )
ilcsoft_add_export_variable( NAME PYTHONPATH VALUE "$LCIO/python:$LCIO/python/examples" )

# export the package
ilcsoft_export_package()
