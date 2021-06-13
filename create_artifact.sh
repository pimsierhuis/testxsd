#!/bin/bash

rm -rf target
mkdir -p target/build


### Determine version from git info

echo "Determining version..."

VERSION=0-localbuild

if [ -z "$GITHUB_REF" ]; then
  echo "Github ref not set, using version 0-localbuild"
  
else
  echo "Github ref: $GITHUB_REF"
  if [[ $GITHUB_REF == refs/heads/* ]]; then
    BRANCH=${GITHUB_REF:11}
    VERSION=branch-${BRANCH}-${GITHUB_SHA}
  elif [[ $GITHUB_REF == refs/tags/* ]]; then
    VERSION=${GITHUB_REF:10}
  else
    echo "Unsupported github ref, exiting"
    exit 1
  fi
fi

echo "Using version $VERSION"


### Build

sed s/PLACEHOLDER/${VERSION}/ test.xsd > target/build/test.xsd

cp test.pdf target/build/

### Create artifact

ARTIFACT_FILE=testxsd-${VERSION}.zip

mkdir -p target/artifact
(cd target/build && zip -r ../../target/artifact/${ARTIFACT_FILE} .)

