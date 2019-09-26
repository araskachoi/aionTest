#!/bin/bash -xeu
COMMAND=whiteblock
WAIT_TIME=630

NODES=30
IMAGE=aion_test_image:latest
BANDWIDTH=1000
ACCOUNTS=15
PACKET_LOSS=0
LATENCY=0
TPS=200
CPU_LIMIT=3
MEM_LIMIT=0
TX_SIZE=200
RETRY_DELAY=5
RETRIES=2

TMUX=

retry_run() {
        n=0
        set -e
        until [ $n -ge $RETRIES ]
        do
                $@ && break  
                n=$[$n+1]
                sleep $RETRY_DELAY
        done
        set +e
}

run_test() {
        sudo docker restart rpc
        ulimit -n 10000
        local dir=series_$1_$(date +"%FT%T"| tr -d '[:space:]')
        sudo mkdir $dir

        echo "Running Tests"
        retry_run $COMMAND build -b aion -n $NODES -c $CPU_LIMIT -m $MEM_LIMIT -i $IMAGE -o "mineThreads=1" -t"genesis.json.mustache=/home/master/daniel/saturation/genesis.json" -y

        OUTPUT_FILE=$dir/cpu.log
        OUTPUT_FILE_FOR_DATADIR_SIZE=$dir/datadir_size.log
        tmux new -s datadir_size -d; tmux send-keys -t datadir_size "while :; do for ((i=0;i<$NODES;i++)); do echo \$(whiteblock ssh \$i -- du -sb /aion/custom/database | awk '{print \$1}') \$(date +'%s') >> $OUTPUT_FILE_FOR_DATADIR_SIZE; done; done" C-m
        tmux new -s cpu_recorder -d; tmux send-keys -t cpu_recorder "while :; do NO_PRETTY=1 whiteblock get nodes >> $OUTPUT_FILE;  done" C-m

        sleep 10
        echo "Build complete"

        retry_run $COMMAND netconfig all -d $LATENCY -l $PACKET_LOSS -b $BANDWIDTH

        ./saturate.sh 6500000 $TPS "10.1.0.2, 10.1.0.18, 10.1.0.34, 10.1.0.50, 10.1.0.66, 10.1.0.82, 10.1.0.98, 10.1.0.114, 10.1.0.130, 10.1.0.146, 10.1.0.162, 10.1.178, 10.1.0.194, 10.1.0.210, 10.1.0.226" &>/dev/null &

        sleep $WAIT_TIME
	pkill -f "saturate.sh"
        retry_run $COMMAND export --local --dir $dir/nodes --single-node-mode
        tmux kill-session -t cpu_recorder
        tmux kill-session -t datadir_size
}

run_case() {
        for i in {1..3}
        do
                run_test $1.$i
        done
}

run_test20() {
        sudo docker restart rpc
        ulimit -n 10000
        local dir=series_$1_$(date +"%FT%T"| tr -d '[:space:]')
        sudo mkdir $dir

        echo "Running Tests"
        retry_run $COMMAND build -b aion -n $NODES -c $CPU_LIMIT -m $MEM_LIMIT -i $IMAGE -o "mineThreads=1" -t"genesis.json.mustache=/home/master/daniel/saturation/genesis.json" -y

        OUTPUT_FILE=$dir/cpu.log
        OUTPUT_FILE_FOR_DATADIR_SIZE=$dir/datadir_size.log
        tmux new -s datadir_size -d; tmux send-keys -t datadir_size "while :; do for ((i=0;i<$NODES;i++)); do echo \$(whiteblock ssh \$i -- du -sb /aion/custom/database | awk '{print \$1}') \$(date +'%s') >> $OUTPUT_FILE_FOR_DATADIR_SIZE; done; done" C-m
        tmux new -s cpu_recorder -d; tmux send-keys -t cpu_recorder "while :; do NO_PRETTY=1 whiteblock get nodes >> $OUTPUT_FILE;  done" C-m

        sleep 10
        echo "Build complete"

        retry_run $COMMAND netconfig all -d $LATENCY -l $PACKET_LOSS -b $BANDWIDTH

        ./saturate.sh 6500000 $TPS "10.1.0.2, 10.1.0.18, 10.1.0.34, 10.1.0.50, 10.1.0.66, 10.1.0.82, 10.1.0.98, 10.1.0.114, 10.1.0.130, 10.1.0.146, 10.1.0.162, 10.1.178, 10.1.0.194, 10.1.0.210, 10.1.0.226, 10.1.0.242, 10.1.0.258, 10.1.0.274, 10.1.0.290, 10.1.0.306"  &>/dev/null &

        sleep $WAIT_TIME
        pkill -f "saturate.sh"
        retry_run $COMMAND export --local --dir $dir/nodes --single-node-mode
        tmux kill-session -t cpu_recorder
        tmux kill-session -t datadir_size
}

run_case20() {
        for i in {1..3}
        do
                run_test20 $1.$i
        done
}

run_test25() {
        sudo docker restart rpc
        ulimit -n 10000
        local dir=series_$1_$(date +"%FT%T"| tr -d '[:space:]')
        sudo mkdir $dir

        echo "Running Tests"
        retry_run $COMMAND build -b aion -n $NODES -c $CPU_LIMIT -m $MEM_LIMIT -i $IMAGE -o "mineThreads=1" -t"genesis.json.mustache=/home/master/daniel/saturation/genesis.json" -y

        OUTPUT_FILE=$dir/cpu.log
        OUTPUT_FILE_FOR_DATADIR_SIZE=$dir/datadir_size.log
        tmux new -s datadir_size -d; tmux send-keys -t datadir_size "while :; do for ((i=0;i<$NODES;i++)); do echo \$(whiteblock ssh \$i -- du -sb /aion/custom/database | awk '{print \$1}') \$(date +'%s') >> $OUTPUT_FILE_FOR_DATADIR_SIZE; done; done" C-m
        tmux new -s cpu_recorder -d; tmux send-keys -t cpu_recorder "while :; do NO_PRETTY=1 whiteblock get nodes >> $OUTPUT_FILE;  done" C-m

        sleep 10
        echo "Build complete"

        retry_run $COMMAND netconfig all -d $LATENCY -l $PACKET_LOSS -b $BANDWIDTH

        ./saturate.sh 6500000 $TPS "10.1.0.2, 10.1.0.18, 10.1.0.34, 10.1.0.50, 10.1.0.66, 10.1.0.82, 10.1.0.98, 10.1.0.114, 10.1.0.130, 10.1.0.146, 10.1.0.162, 10.1.178, 10.1.0.194, 10.1.0.210, 10.1.0.226, 10.1.0.242, 10.1.0.258, 10.1.0.274, 10.1.0.290, 10.1.0.306, 10.1.0.322, 10.1.0.338, 10.1.0.354, 10.1.0.370, 10.1.0.386"  &>/dev/null &

        sleep $WAIT_TIME
        pkill -f "saturate.sh"
        retry_run $COMMAND export --local --dir $dir/nodes --single-node-mode
        tmux kill-session -t cpu_recorder
        tmux kill-session -t datadir_size
}

run_case25() {
        for i in {1..3}
        do
                run_test25 $1.$i
        done
}

run_test30() {
        sudo docker restart rpc
        ulimit -n 10000
        local dir=series_$1_$(date +"%FT%T"| tr -d '[:space:]')
        sudo mkdir $dir

        echo "Running Tests"
        retry_run $COMMAND build -b aion -n $NODES -c $CPU_LIMIT -m $MEM_LIMIT -i $IMAGE -o "mineThreads=1" -t"genesis.json.mustache=/home/master/daniel/saturation/genesis.json" -y

        OUTPUT_FILE=$dir/cpu.log
        OUTPUT_FILE_FOR_DATADIR_SIZE=$dir/datadir_size.log
        tmux new -s datadir_size -d; tmux send-keys -t datadir_size "while :; do for ((i=0;i<$NODES;i++)); do echo \$(whiteblock ssh \$i -- du -sb /aion/custom/database | awk '{print \$1}') \$(date +'%s') >> $OUTPUT_FILE_FOR_DATADIR_SIZE; done; done" C-m
        tmux new -s cpu_recorder -d; tmux send-keys -t cpu_recorder "while :; do NO_PRETTY=1 whiteblock get nodes >> $OUTPUT_FILE;  done" C-m

        sleep 10
        echo "Build complete"

        retry_run $COMMAND netconfig all -d $LATENCY -l $PACKET_LOSS -b $BANDWIDTH

        ./saturate.sh 6500000 $TPS "10.1.0.2, 10.1.0.18, 10.1.0.34, 10.1.0.50, 10.1.0.66, 10.1.0.82, 10.1.0.98, 10.1.0.114, 10.1.0.130, 10.1.0.146, 10.1.0.162, 10.1.178, 10.1.0.194, 10.1.0.210, 10.1.0.226, 10.1.0.242, 10.1.0.258, 10.1.0.274, 10.1.0.290, 10.1.0.306, 10.1.0.322, 10.1.0.338, 10.1.0.354, 10.1.0.370, 10.1.0.386, 10.1.0.402, 10.1.0.418, 10.1.0.434, 10.1.0.450, 10.1.0.466"  &>/dev/null &

        sleep $WAIT_TIME
        pkill -f "saturate.sh"
        retry_run $COMMAND export --local --dir $dir/nodes --single-node-mode
        tmux kill-session -t cpu_recorder
        tmux kill-session -t datadir_size
}

run_case30() {
        for i in {1..3}
        do
                run_test30 $1.$i
        done
}

reset_vars() {
        # Defaults to contol case specs
        LATENCY=0
        PACKET_LOSS=0
        BANDWIDTH=1000
        NODES=30 #clients
        ACCOUNTS=15 #Sender accounts
        TX_SIZE=200
        TPS=200
}

for i in $@; do

        reset_vars
        case "$i" in
                1)
                        # Control Case
                        run_case 1a
                        run_case 1b
                        run_case 1c
                        ;;
                2)
                        # Network Latency Test
                        LATENCY=50
                        run_case 2a
                        LATENCY=100
                        run_case 2b
                        LATENCY=150
                        run_case 2c
                        ;;
                3)
                        # Packet Loss
                        PACKET_LOSS=0.01
                        run_case 3a
                        PACKET_LOSS=0.1
                        run_case 3b
                        PACKET_LOSS=1
                        run_case 3c
                        ;;
                4)
                        # V Bandwidth test
                        BANDWIDTH=10
                        run_case 4a
                        BANDWIDTH=50
                        run_case 4b
                        BANDWIDTH=100
                        run_case 4c
                        ;;
                5)
                        # V Increase Network Latency
                        LATENCY=200
                        run_case 5a
                        LATENCY=300
                        run_case 5b
                        LATENCY=400
                        run_case 5c
                        ;;
                6)
                        # V Stress Test
                        LATENCY=150
                        PACKET_LOSS=0.01
                        BANDWIDTH=10
                        TPS=500

                        run_case 6a
                        run_case 6b
                        run_case 6c
                        ;;
                7)
                        # V Transaction Size
                        # TX_SIZE=500
                        # run_case 7a
                        # TX_SIZE=750
                        # run_case 7b
                        # TX_SIZE=1000
                        # run_case 7c
                        echo "skip series 7"
                        ;;
                8)
                        # V Transaction Count
                        LATENCY=0
                        PACKET_LOSS=0

                        BANDWIDTH=10
                        TPS=700
                        run_case 8a

                        BANDWIDTH=50
                        TPS=1000
                        run_case 8b

                        BANDWIDTH=100
                        TPS=1500
                        run_case 8c
                        ;;
                9)
                        # V Sending Account
                        LATENCY=0
                        PACKET_LOSS=0
                        BANDWIDTH=1000

                        run_case20 9a
                        run_case25 9b
                        run_case30 9c
                        ;;

                *)
                        echo "Enter a valid case#"
                        ;;
        esac
done
