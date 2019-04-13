

ilcsoft_package(
  NAME Boost
  NO_INSTALL_SUPPORT
)

set( Boost_FIND_COMPONENTS "" CACHE STRING "The required Boost components" )
ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )

if( Boost_FIND_COMPONENTS )
  find_package( Boost ${pkg_version} REQUIRED COMPONENTS ${Boost_FIND_COMPONENTS} )
else()
  find_package( Boost ${pkg_version} REQUIRED )
endif()

message( STATUS "++=> Boost directory: ${Boost_ROOT}" )
message( STATUS "++=> Boost version: ${Boost_VERSION}" )
message( STATUS "++=> Boost includes: ${Boost_INCLUDE_DIRS}" )
message( STATUS "++=> Boost libraries: ${Boost_LIBRARIES}" )
message( STATUS "++=> Boost library directory: ${Boost_LIBRARY_DIRS}" )

ilcsoft_set_package_property( PROPERTY INSTALL_DIR VALUE ${Boost_ROOT} )
ilcsoft_set_package_property( PROPERTY VERSION VALUE ${Boost_VERSION} )

# export variables to init_ilcsoft.sh
ilcsoft_add_export_variable( NAME BOOST_ROOT VALUE ${pkg_install_dir} )

ilcsoft_export_package()
