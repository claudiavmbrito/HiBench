#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

current_dir=`dirname "$0"`
root_dir=${current_dir}/../../../../../
workload_config=${root_dir}/conf/workloads/websearch/nutchindexing.conf
. "${root_dir}/bin/functions/load-bench-config.sh"

enter_bench HadoopPrepareNutchindexing ${workload_config} 
show_bannar start

rmr-hdfs $INPUT_HDFS || true

SIZE=`dir_size $INPUT_HDFS`
MONITOR_PID=`start-monitor`
START_TIME=`timestamp`

# generate data
OPTION="-t nutch \
        -b ${NUTCH_BASE_HDFS} \
        -n ${NUTCH_INPUT} \
        -m ${NUM_MAPS} \
        -r ${NUM_REDS} \
        -p ${PAGES} \
        -o sequence"

run-hadoop-job ${DATATOOLS} HiBench.DataGen ${OPTION} 2>&1 

END_TIME=`timestamp`
stop-monitor $MONITOR_PID

show_bannar finish
leave_bench

