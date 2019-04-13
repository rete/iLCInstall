#############################################################
# cmake module for finding mysqlclient headers and libraries
#
# returns:
#   MySQL_FOUND               : set to TRUE or FALSE
#   MySQL_DIR                 : path to mysql package
#   MySQL_VERSION             : package version
#   MySQL_INCLUDE_DIRS        : paths to mysql includes
#   MySQL_LIBRARY_DIRS        : paths to mysql libraries
#   MySQL_LIBRARIES           : list of mysql libraries
#   MySQL_CONFIG_EXECUTABLE   : the mysql config executable
#
# @author Remi Ete, DESY
#############################################################

IF( NOT MySQL_DIR )
  SET( MySQL_DIR MySQL_DIR-NOTFOUND )
ENDIF()
MARK_AS_ADVANCED( MySQL_DIR )

# ------------- mysql_config  --------------------------------
SET( MySQL_CONFIG_EXECUTABLE MySQL_CONFIG_EXECUTABLE-NOTFOUND )
MARK_AS_ADVANCED( MySQL_CONFIG_EXECUTABLE )

IF( NOT MySQL_DIR )
    FIND_PROGRAM( MySQL_CONFIG_EXECUTABLE mysql_config )
ELSE()
    FIND_PROGRAM( MySQL_CONFIG_EXECUTABLE mysql_config PATHS ${MySQL_DIR}/bin NO_DEFAULT_PATH )
ENDIF()

IF( MySQL_CONFIG_EXECUTABLE )

    # ==============================================
    # ===          MySQL_VERSION                 ===
    # ==============================================

    EXECUTE_PROCESS( COMMAND "${MySQL_CONFIG_EXECUTABLE}" --version
        OUTPUT_VARIABLE MySQL_VERSION
        RESULT_VARIABLE _exit_code
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    IF( _exit_code EQUAL 0 )
        SET( MySQL_VERSION ${MySQL_VERSION} )
    ELSE()
        SET( MySQL_VERSION )
    ENDIF()

ENDIF( MySQL_CONFIG_EXECUTABLE )


# ------------- include dirs ---------------------------------
SET( MySQL_INCLUDE_DIRS MySQL_INCLUDE_DIRS-NOTFOUND )
MARK_AS_ADVANCED( MySQL_INCLUDE_DIRS )

# MySQL_DIR at this point can be used as a guess variable
# Note that after finding the includ dirs, MySQL_DIR is set
# according to the found path is originally not set
IF( MySQL_DIR )
    FIND_PATH( MySQL_INCLUDE_DIRS
        NAMES mysql.h
        PATHS ${MySQL_DIR}/include ${MySQL_DIR}/include/mysql ${MySQL_DIR}/include/mysql5/mysql
        NO_DEFAULT_PATH
    )
ELSE()
    FIND_PATH( MySQL_INCLUDE_DIRS
        NAMES mysql.h
        PATHS /usr /usr/local /opt/local
        PATH_SUFFIXES include include/mysql include/mysql5/mysql mysql/include
    )
    IF( MySQL_INCLUDE_DIRS )
        SET( MySQL_DIR ${MySQL_INCLUDE_DIRS} )
    ENDIF()
ENDIF()

# ------------- libraries ------------------------------------
SET( MySQL_LIBRARIES MySQL_LIBRARIES-NOTFOUND )
MARK_AS_ADVANCED( MySQL_LIBRARIES )

FIND_LIBRARY( MySQL_LIBRARIES NAMES mysqlclient mysqlclient_r PATHS
    ${MySQL_DIR}/lib64
    ${MySQL_DIR}/lib64/mysql
    ${MySQL_DIR}/lib64/mysql5/mysql
    ${MySQL_DIR}/lib
    ${MySQL_DIR}/lib/mysql
    ${MySQL_DIR}/lib/mysql5/mysql
    ${MySQL_DIR}/lib/x86_64-linux-gnu/
    NO_DEFAULT_PATH
)
IF( MySQL_LIBRARIES )
    GET_FILENAME_COMPONENT( MySQL_LIBRARY_DIRS ${MySQL_LIBRARIES} PATH )
    MARK_AS_ADVANCED( MySQL_LIBRARY_DIRS )
ENDIF( MySQL_LIBRARIES )

# ---------- final checking ---------------------------------------------------
INCLUDE( FindPackageHandleStandardArgs )
SET( PACKAGE_VERSION_COMPATIBLE TRUE )
# set MySQL_FOUND to TRUE if all listed variables are TRUE and not empty
FIND_PACKAGE_HANDLE_STANDARD_ARGS( MySQL DEFAULT_MSG MySQL_DIR MySQL_CONFIG_EXECUTABLE MySQL_INCLUDE_DIRS MySQL_LIBRARIES PACKAGE_VERSION_COMPATIBLE )

SET( MySQL_FOUND ${MYSQL_FOUND} )
