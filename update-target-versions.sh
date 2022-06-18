#!/bin/bash

./update-latest-release-from-github.py

(cd eclipse; ./update-target-versions.sh)
(cd models; ./update-target-versions.sh)
(cd eclipse; ./update-target-versions.sh)
(cd runtime/judo-tatami; ./update-target-versions.sh)


