# How To Use
1. Ensure that your `JAVA_HOME` is set correctly (jdk 10+ supported)
2. Run the saturator: `./saturate.sh <num-transactions-per-sender> <transactions-per-second> [IP addresses...]`
3. Copy the provided genesis.json file into whatever kernel build you are using
4. Ensure that in your kernel's config.xml file the rpc server is turned on and is using port 8545

### The program arguments
- num-transactions-per-sender: the number of transactions each sender will send to the kernel. Note the number of senders is equal to the number of IP addresses supplied.
- IP addresses: this is a comma-separated list of at least one IP address.

### Example
Let's suppose we want the following parameters:
- sending 1,000 transactions per sender.
- sending at a rate of 100 transactions per second.
- sending transactions to the following IP addresses: 11.92.80.117 and 81.0.0.8 and 90.21.21.21

To run with these settings: `./saturate.sh 1000 100 "11.92.80.117, 81.0.0.8, 90.21.21.21"`

Note that 3 sender threads will be created, one per IP, and each thread will send 1,000 transactions. Thus 3,000 transactions will be run.
(Really 3,003 will be run because 3 initial transactions will be sent to fund the sender accounts using a premined account).

This program is meant to be run outside of your nodes, and only run once. It will flood each node with transactions.

### What the program does
1. Creates N accounts, one per IP address, and N threads that correspond one-to-one with these accounts.
2. Funds each of the N accounts with a premined account (ie. sends N transactions).
3. Starts the N threads and each thread will send T transactions each to one of the specified IP addresses.
