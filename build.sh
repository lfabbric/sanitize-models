#!/bin/bash

# set version
VERSION=0.2

# set file name
ZIPFILE=SanitizeModels-$VERSION.zip

# remove the existing zip file
if [ ! -d build ]; then
    mkdir build
fi
rm -f build/$ZIPFILE
cd src

# load in the basic plugin files
zip ../build/$ZIPFILE sanitizemodels.cfc index.cfm
