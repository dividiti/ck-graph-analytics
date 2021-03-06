#! /bin/bash

#
# Extra installation script
#
# See CK LICENSE.txt for licensing details.
# See CK COPYRIGHT.txt for copyright details.
#
# Developer(s):
#

#SOURCE_PATCH_PATH=`ck find package:lib-seissol`
#cp $SOURCE_PATCH_PATH/scripts.linux/patch4 ${INSTALL_DIR}/src/submodules/PUML/
#cd ${INSTALL_DIR}/src/submodules/PUML/
#git apply patch4
#
#if [ "${?}" != "0" ] ; then
#    echo "Error: PUML Patch failed!"
#      exit 1
#fi

cd ${INSTALL_DIR}/src/

git submodule update

PREFIX=${INSTALL_DIR}/install
mkdir -p $PREFIX

COMPILER_TYPE="gcc"
if [ "${CK_CC}" == "icc" ] ; then
   COMPILER_TYPE="intel"
fi

#FIX ME USE CK VARIABLES
# i.e.,  arch: .  Valid values are: ['snoarch', 'dnoarch', 'swsm', 'dwsm', 'ssnb', 'dsnb', 'sknc', 'dknc', 'shsw', 'dhsw', 'sknl', 'dknl'
# dsnb = sandy bridge
scons -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS}  \
       order=6 compileMode=release \
       arch=${CK_SEISSOL_TARGET_ARCH} \
       parallelization=hybrid commThread=yes \
       netcdf=yes netcdfDir=${CK_ENV_LIB_NETCDF} \
       compiler=${COMPILER_TYPE} \
       hdf5=yes hdf5Dir=${CK_ENV_LIB_HDF5} 
#       metis=yes metisDir=${CK_ENV_LIB_METIS}

if [ "${?}" != "0" ] ; then
    echo "Error: compilation failed!"
      exit 1
fi
cp ${INSTALL_DIR}/src/src/version.h ${PREFIX}
if [ "${?}" != "0" ] ; then
    echo "Error: copy version.h failed!"
      exit 1
fi
