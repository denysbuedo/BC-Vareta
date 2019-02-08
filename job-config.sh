#!/bin/bash
#--- Creating data config file---
file="/var/lib/jenkins/workspace/BC-Vareta/task-config.xml"
echo '<Task Job='$1'Owner='$2' EEG='$3' LeadField='$4' Surface='$5' Scalp='$6'></Task>' >> $file

#--- Creating data description file ---
file="/var/lib/jenkins/workspace/BC-Vareta/data-description.txt"
echo $3 $4 $5 $6 >> $file