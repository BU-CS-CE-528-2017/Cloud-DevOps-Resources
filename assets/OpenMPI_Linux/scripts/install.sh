#!/bin/bash

cd ~
wget https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.2.tar.gz
tar -xzvf openmpi-2.0.2.tar.gz
cd openmpi-2.0.2
./configure
make
make install

exit 0
