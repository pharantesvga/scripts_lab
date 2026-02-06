#!/bin/bash

# Intervalo 1 a 114
for i in $(seq 1 114); do
  ssh-keygen -f '/home/pharantes/.ssh/known_hosts' -R "200.128.159.$i"
done


