#!/usr/bin/env bash
PKG_NAME=cdms2
USER=uvcdat
echo "Trying to upload conda"
if [ `uname` == "Linux" ]; then
    OS=linux-64
    echo "Linux OS"
    export PATH="/travis_home/miniconda/bin:$PATH"
    echo $PATH
    which conda
#    conda update -y -q conda  # -R issue woraround
else
    echo "Mac OS"
    OS=osx-64
fi

# Python 3 section
echo "Building python 3"
source activate py3
mkdir ${HOME}/conda-bld
# pin conda so that conda-build does not update it
echo "conda ==4.3.21" >> ~/miniconda/conda-meta/pinned  # Pin conda as workaround for conda/conda#6030
conda install -n root -q anaconda-client conda-build
conda config --set anaconda_upload no
export CONDA_BLD_PATH=${HOME}/conda-bld
export VERSION="2.12"
echo "Cloning recipes"
cd ${HOME}
git clone git://github.com/UV-CDAT/conda-recipes
cd conda-recipes
# uvcdat creates issues for build -c uvcdat confises package and channel
rm -rf uvcdat
python ./prep_for_build.py
echo "Building now"
echo "use nesii/label/dev-esmf for py3"
conda install conda-build==3.2.2
conda build $PKG_NAME -c nesii/label/dev-esmf -c nadeau1 -c uvcdat/label/nightly -c conda-forge -c uvcdat 
anaconda -t $CONDA_UPLOAD_TOKEN upload -u $USER -l nightly $CONDA_BLD_PATH/$OS/$PKG_NAME-$VERSION.`date +%Y`*_0.tar.bz2 --force

# Python 2 section
echo "Building python 2"
source activate py2
which python
conda install -q anaconda-client conda-build
conda config --set anaconda_upload no
rm -rf ${HOME}/conda-bld
mkdir ${HOME}/conda-bld
export CONDA_BLD_PATH=${HOME}/conda-bld
export VERSION="2.12"
cd ${HOME}/conda-recipes
python ./prep_for_build.py
echo "Building now"
conda install conda-build==3.2.2
conda build $PKG_NAME -c uvcdat/label/nightly -c conda-forge -c uvcdat 
anaconda -t $CONDA_UPLOAD_TOKEN upload -u $USER -l nightly $CONDA_BLD_PATH/$OS/$PKG_NAME-$VERSION.`date +%Y`*_0.tar.bz2 --force

