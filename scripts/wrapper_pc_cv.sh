#!/bin/bash
# Wrapper Skript for CV
# Reads factors_config, ../data/datasets.yaml and performs cv's
# Andreas Maunz, David Vorgrimmler,  2012

if [ $# -lt 2 ]; then
  echo "Usage: $0 factors path/to/dataset.yaml"
  exit
fi

#PWD=`pwd`
#echo $PWD
#if [ ! -f $PWD/../data/datasets.yaml ] 
if [ ! -f $2 ] 
then
  echo "datasets.yaml does not exist."
  exit
fi

# Configure basics
source $HOME/.bash_aliases
otconfig
THIS_DATE=`date +%Y%m%d_%H_`
CV="CV_ds_pctype_algo_algoparams_rseed.rb"
FACTORS="$1"
PID="will_be_set_to_real_PID_when_CV_ds_pctype_algo_rseed.rb_runs"

# Don't start when running
#while ps x | grep $CV | grep -v grep >/dev/null 2>&1; do sleep 3; done
while ps x | grep $PID | grep $CV | grep -v grep >/dev/null 2>&1; do sleep 30; done

LOGFILE="$THIS_DATE""$USER""_wrapper_pc_cv.log"
#rm "$LOGFILE" >/dev/null 2>&1
if [ -f $LOGFILE ]
then
  LOGFILE="$LOGFILE`date +%M%S`"
fi


cat $FACTORS | while read factor; do
  if ! [[ "$factor" =~ "#" ]]; then # allow comments
    for r_seed in 1 2 3 4 5
    do
      factor_r="$factor $r_seed"
      echo "${THIS_DATE}: $factor_r" >> $LOGFILE>&1
      echo "ruby $CV $factor_r $2" >> $LOGFILE 2>&1
      ruby $CV $factor_r $2>> $LOGFILE 2>&1
      PID=$!
      echo >> $LOGFILE 2>&1
    done
  fi
done

