#!/bin/bash

if [ "$#" != 3 ]
then
	echo 'Usage: ./saturate.sh <num-transactions-per-sender> <transactions-per-second> [IP addresses, ...]'
	exit 1
fi
if [ "$1" -le 0 ]
then
	echo 'Error: num-transactions-per-sender must be greater than zero.'
	exit 1
fi
if [ "$1" -gt 6500000 ]
then
	echo 'Error: num-tansactions-per-sender must not be greater than 6,500,000.'
	exit 1
fi
if [ "$2" -le 0 ]
then
	echo 'Error: transactions-per-second must be greater than zero.'
fi

/usr/bin/java -cp .:./lib/* -DnumTransactions="$1" -DtransactionsPerSecond="$2" -DipAddresses="$3" org.junit.runner.JUnitCore org.aion.harness.tests.integ.saturation.SaturationTest
