#!/usr/bin/env python
import os
import json
import sys

from nodeParser import aggerateData
from resourceParser import aggerateData as aggerateSystemData

# NOTE: V Represents where all the tests are
#directory = os.fsencode("/home/master/series1")
directory = os.fsencode(sys.argv[1])
TPS = 500

results = {}
blockParsing = False

for subdir, dirs, files in os.walk(directory):

    for file in files:
        path = os.path.join(subdir, file)

        if "blocks.json" in str(file) and not blockParsing:
            blockParsing = True
            stats, fullstats = aggerateData(path.decode("utf-8"), TPS)
            
            d = os.path.dirname(path)
            seriesNam  = os.path.dirname(os.path.dirname(d))

            seriesPath = os.path.abspath(d)
            newFile = seriesNam.decode("utf-8")  + "/info.txt"
            f = open(newFile, "a+")
            f.write("Chain Metrics \n")
            f.write(str(stats['avgBlockSize']) + '\n')
            f.write(str(stats['avgBlockTime']) + '\n')
            f.write(str(stats['txSent']) + '\n')
            f.write(str(stats['txSuccessRate']) + '\n')
            f.write(str(stats['avgTxThroughPut']) + '\n')
            f.close()

        elif "cpu.log" in str(file):
            d = os.path.dirname(path)
            seriesPath = os.path.abspath(d)

            stats = aggerateSystemData(seriesPath.decode("utf-8")+"/cpu.log")

            d = os.path.dirname(path)
            seriesPath = os.path.abspath(d)
            newFile = seriesPath.decode("utf-8")  + "/info.txt"
            # newFile = os.path.join(str(seriesPath), "info.txt")
            f = open(newFile, "a+")
            f.write("CPU/RAM metrics \n")
            f.write(str(stats['cpuAvgUsage']) + '\n' )
            f.write(str(stats['ramAvgUsage']) + '\n' )
            f.write("Average Cpu Usage per node : "+ str(stats['cpuAvgs']) + '\n')
            f.write("Average Ram Usage per node : "+ str(stats['ramAvgs']) + '\n')
            
            f.close()

print("...Completed...")


