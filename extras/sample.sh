#/bin/env sh

#assumes current directory is the root directory of the project and that it's using git SCM
theSHA=`git rev-parse --short=7 HEAD`

# Xcode Build Run Script example using Xcode Build Script Environment variable PROJECT_DIR
# to get the location of the git repo against which to run `git rev-parse`
#
# theSHA=`git -C "${PROJECT_DIR}" rev-parse --short=7 HEAD`

# Assumes badger is in your execution path somewhere
# desktop location is just a placeholder
badger $theSHA -i ~/Desktop/Otter.png -o ~/Desktop/Otter_out.png
