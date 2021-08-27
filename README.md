# aztf-on-demand-burst

# https://github.com/uglide/azure-content/blob/master/articles/virtual-machines/virtual-machines-linux-configure-lvm.md

```
# install LVM utilities
  # sudo apt-get update
  # sudo apt-get install lvm2



$ ./bench_fio -d /data -t directory -s 4g --mode randread -o ./bursting --iodepth 128 --numjobs 4 --block-size 8k --extra-opts fallocate=none

$ ./bench_fio -d /data -t directory -s 4g --mode randwrite -o ./bursting --iodepth 128 --numjobs 4 --block-size 8k --extra-opts fallocate=none


./fio_plot  -i ../benchmark_script/bursting/data/8k ../benchmark_script/no-bursting/data/8k -T "IOPS, randread" -g -t iops -r randread -d 128 -n 4 --xlabel-parent 2

./fio_plot  -i ../benchmark_script/bursting/data/8k ../benchmark_script/no-bursting/data/8k -T "IOPS, randwrite" -g -t iops -r randwrite -d 128 -n 4 --xlabel-parent 2

./fio_plot  -i ../benchmark_script/bursting/data/8k ../benchmark_script/no-bursting/data/8k -T "Latency, randread" -g -t lat -r randread -d 128 -n 4 --xlabel-parent 2

./fio_plot  -i ../benchmark_script/bursting/data/8k ../benchmark_script/no-bursting/data/8k -T "Latency, randwrite" -g -t lat -r randwrite -d 128 -n 4 --xlabel-parent 2

./fio_plot  -i ../benchmark_script/bursting/data/8k ../benchmark_script/no-bursting/data/8k -T "Bandwidth, randread" -g -t bw -r randread -d 128 -n 4 --xlabel-parent 2

./fio_plot  -i ../benchmark_script/bursting/data/8k ../benchmark_script/no-bursting/data/8k -T "Bandwidth, randwrite" -g -t bw -r randwrite -d 128 -n 4 --xlabel-parent 2



