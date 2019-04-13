
ilcsoft_package(
  NAME MySQL
  NO_INSTALL_SUPPORT
)

set( MySQL_DIR "" CACHE STRING "Path to MySQL directory" )
ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )

find_package( MySQL ${pkg_version} REQUIRED )

# export variables
ilcsoft_set_package_property( PROPERTY INSTALL_DIR VALUE ${MySQL_DIR} )
ilcsoft_set_package_property( PROPERTY VERSION VALUE ${MySQL_VERSION} )
get_filename_component( MySQL_BIN_DIR ${MySQL_CONFIG_EXECUTABLE} DIRECTORY )

message( STATUS "++=> MySQL directory: ${MySQL_DIR}" )
message( STATUS "++=> MySQL includes: ${MySQL_INCLUDE_DIRS}" )
message( STATUS "++=> MySQL libraries: ${MySQL_LIBRARIES}" )
message( STATUS "++=> MySQL library directory: ${MySQL_LIBRARY_DIRS}" )
message( STATUS "++=> MySQL version: ${MySQL_VERSION}" )
message( STATUS "++=> MySQL config executable: ${MySQL_CONFIG_EXECUTABLE}" )
message( STATUS "++=> MySQL bin dir: ${MySQL_BIN_DIR}" )

# export variables to init_ilcsoft.sh
ilcsoft_add_export_variable( NAME MYSQL_HOME VALUE ${MySQL_DIR} )
ilcsoft_add_export_variable( NAME MYSQL VALUE "$MYSQL_HOME" )
ilcsoft_add_export_variable( NAME MYSQL_PATH VALUE "$MYSQL_HOME" )
ilcsoft_add_export_variable( NAME MYSQL_LIBDIR VALUE "${MySQL_LIBRARY_DIRS}" )
ilcsoft_add_export_variable( NAME PATH VALUE "${MySQL_BIN_DIR}" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$MYSQL_LIBDIR" )

ilcsoft_export_package()
