#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

genkernel --kernel-config="${DIR}/config" --lvm --luks --btrfs --makeopts=-j8 "$@"
