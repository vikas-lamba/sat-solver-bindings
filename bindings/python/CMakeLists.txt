#
# cmake description for satsolver Python bindings
#
# !!Attn!!: This creates two files
#  1. satsolver.so
#  2. satsolver.py
# and the .py file gets imported. See bindings/python/tests.
#

ADD_SUBDIRECTORY(tests)

# SWIG_OUPUT is per-target
SET( SWIG_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/satsolver_python.c" )

FIND_PACKAGE(PythonInterp REQUIRED)
EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} -c "from sys import stdout; from distutils import sysconfig; stdout.write(sysconfig.get_python_lib())" OUTPUT_VARIABLE PYTHON_LIB_DIR)

IF (NOT PYTHON_SITEDIR)
  SET (PYTHON_SITEDIR ${PYTHON_LIB_DIR})
ENDIF (NOT PYTHON_SITEDIR)

MESSAGE(STATUS "Python executable: ${PYTHON_EXECUTABLE}")
MESSAGE(STATUS "Python lib dir: ${PYTHON_LIB_DIR}")
MESSAGE(STATUS "Python site dir: ${PYTHON_SITEDIR}")

ADD_CUSTOM_COMMAND (
   OUTPUT  "${SWIG_OUTPUT}"
   COMMAND ${CMAKE_COMMAND} -E echo_append "Creating wrapper code for Python ..."
   COMMAND ${SWIG_EXECUTABLE} -python -DSATSOLVER_VERSION=${SATSOLVER_VERSION} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
   COMMAND ${CMAKE_COMMAND} -E echo "Done."
   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
   DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../*.i
)

SET(binding_SRCS "${SWIG_OUTPUT}")

# Py_True and Py_False are a bit tricky
ADD_DEFINITIONS( -fno-strict-aliasing )

ADD_LIBRARY( satsolver_python SHARED ${binding_SRCS} )
# name it '_satsolver.so'
#  and don't prefix with 'lib'
SET_TARGET_PROPERTIES( satsolver_python PROPERTIES PREFIX "" OUTPUT_NAME "_satsolver")

INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR}/satsolver )
INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR}/applayer )
INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR}/bindings )
INCLUDE_DIRECTORIES( ${SATSOLVER_INCLUDE_PATH} )
INCLUDE_DIRECTORIES( ${PYTHON_INCLUDE_PATH} )

TARGET_LINK_LIBRARIES( satsolver_python ${SATSOLVERAPP_LIBRARY} )
IF(${SATSOLVER_VERSION} GREATER 1701)
TARGET_LINK_LIBRARIES( satsolver_python ${SATSOLVERTOOLS_LIBRARY} )
ENDIF(${SATSOLVER_VERSION} GREATER 1701)
TARGET_LINK_LIBRARIES( satsolver_python ${SATSOLVEREXT_LIBRARY} )
TARGET_LINK_LIBRARIES( satsolver_python ${SATSOLVER_LIBRARY} )
TARGET_LINK_LIBRARIES( satsolver_python ${PYTHON_LIBRARIES} )
TARGET_LINK_LIBRARIES( satsolver_python ${RPMDB_LIBRARY} )

INSTALL(TARGETS satsolver_python LIBRARY DESTINATION ${PYTHON_SITEDIR})

INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/satsolver.py DESTINATION ${PYTHON_SITEDIR} )
