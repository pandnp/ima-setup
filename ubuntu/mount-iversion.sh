#!/bin/bash

# add iversion to each partiton except swap

awk '!/(^#)|swap|iversion/{$4=$4 ",iversion"}1' OFS="\t" /etc/fstab > tmp && mv tmp /etc/fstab
