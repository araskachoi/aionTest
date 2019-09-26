#!/usr/bin/env python
'''
Metrics for single test
    Average Block size:  sum(each block_size)/total_blocks

    blockTime(n) = timeStamp(n) - timeStamp(n-1)
    Average Block Time:  sun(block_time for each block)/total_blocks

    txSent = tps * (time_of_test_run after delay)
    txSuccessRate = (totalTrasnactionsInBlock/txSent)

    txThroughPut = totalTransactionsInBlock/blockTime
    avgTxThroughPut = sum(txThroughPut for each block)/total_blocks 

'''

import json

def aggerateData (p, tps):
    with open(p, 'r') as f:
        nodeInfo = json.load(f)

    testInitialDelay = 120

    fullLength = {
        "blockSizes": [],
        "totalTransactions": [],
        "txThroughPut": [],
        "timestamps" : [],
        "blockTime" : [],
        "blockNumber": []
    }


    initialStamp = int(nodeInfo[0]['timestamp'], 0)
    previousStamp = int(nodeInfo[0]['timestamp'], 0)
    startStamp = 0
    index = 0
    txStartIndex = 0

    a2min = 0
    txCheck = False

    for blockInfo in nodeInfo:
        timeStamp = int(blockInfo['timestamp'], 0)
        blockSize = int(blockInfo['size'], 0)
        totalTransactions = len(blockInfo['transactions'])
        
        if totalTransactions > 0 and not txCheck:
            txCheck, initialStamp, previousStamp = True, timeStamp, timeStamp

        if txCheck:
            blockNumber = blockInfo['number']
            fullLength['blockSizes'].append(blockSize)
            fullLength["blockTime"].append(timeStamp - previousStamp)
            fullLength["timestamps"].append(timeStamp)
            fullLength["totalTransactions"].append(totalTransactions)
            fullLength["blockNumber"].append(blockNumber)

            fullLength["txThroughPut"].append(totalTransactions)
            #if fullLength['blockTime'][-1] != 0:
            #    fullLength["txThroughPut"].append(totalTransactions/fullLength['blockTime'][-1])

            previousStamp = int(blockInfo['timestamp'],0)
            diff = (timeStamp - initialStamp)
    
            # First Block with transactions + 120 = Start of test Interval
            if (diff >= 120):
                diff1 = abs(120 - diff)
                diff2 = abs(120 - (timeStamp -  fullLength["timestamps"][-2]))

                if startStamp == 0:
                    a2min = index
                    txStartIndex = blockNumber = blockInfo['number'] - 1
                    startStamp = -1
                    if diff2 < diff1:
                        a2min = index - 1
            index += 1
    
    startIndex = fullLength["blockNumber"][a2min] -1
    intervalStart = int(nodeInfo[startIndex]['timestamp'], 0)
    intervalEnd = int(nodeInfo[-1]['timestamp'], 0)

    txSent = tps * (intervalEnd - intervalStart )

    after2Min = {
        "blockSizes": fullLength['blockSizes'][a2min:],
        "totalTransactions": fullLength['totalTransactions'][a2min:],
        "txThroughPut": fullLength['txThroughPut'][a2min:],
        "timestamps" : fullLength['timestamps'][a2min:],
        "blockTime" : fullLength['blockTime'][a2min:],
        "txSent": txSent,
        "intervalStart": intervalStart,
        "intervalEnd": intervalEnd,
        "totalRunTime": (intervalEnd-intervalStart)
    }
    
    after2Min['avgBlockSize'] = sum(after2Min['blockSizes'])/len(after2Min["blockSizes"])
    after2Min['avgBlockTime'] = sum(after2Min['blockTime'])/len(after2Min["blockTime"])
    after2Min['txSuccessRate'] = sum(after2Min['totalTransactions'])/txSent
    after2Min['avgTxThroughPut'] = sum(after2Min['txThroughPut'])/(intervalEnd - intervalStart)
    after2Min["totalTransactions"] = sum(fullLength['txThroughPut'][a2min:])
   
    return after2Min, fullLength

# initialPath = "/Users/master/Documents/Professional/whiteblock/whiteblock-parser/script/test/"
#check ="/home/master/daniel/saturation/series1/series_1a.1_2019-09-24T22:02:09/nodes/9864b48e-dd0c-47f8-a8a9-db898e154535/blocks.json"
#print(aggerateData(check, 200))


