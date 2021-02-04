#!/bin/bash

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_UDIMA_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/ca.crt
export PEER0_MINISTERIO_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json

export CHANNEL_NAME=mychannel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

setGlobalsForPeer0Udima() {
    export CORE_PEER_LOCALMSPID="UdimaMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_UDIMA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/users/Admin@udima.example.com/msp
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Udima() {
    export CORE_PEER_LOCALMSPID="UdimaMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_UDIMA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/users/Admin@udima.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051

}

setGlobalsForPeer0Ministerio() {
    export CORE_PEER_LOCALMSPID="MinisterioMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MINISTERIO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/users/Admin@ministerio.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1Ministerio() {
    export CORE_PEER_LOCALMSPID="MinisterioMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MINISTERIO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/users/Admin@ministerio.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}


CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="node"
VERSION="1"
CC_SRC_PATH="./chaincode/exam_register"
CC_NAME="exam_auditter"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0Udima
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.udima ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0Udima
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.udima ===================== "

    # setGlobalsForPeer1Udima
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.udima ===================== "

    setGlobalsForPeer0Ministerio
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.ministerio ===================== "

    # setGlobalsForPeer1Ministerio
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.ministerio ===================== "
}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0Udima
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.udima on channel ===================== "
}

# queryInstalled



approveForMyUdima() {
    setGlobalsForPeer0Udima
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

getBlock() {
    setGlobalsForPeer0Udima

    peer channel getinfo  -c mychannel -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA
}

# getBlock



checkCommitReadyness() {
    setGlobalsForPeer0Udima
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

# --collections-config ./artifacts/private-data/collections_config.json \
# --signature-policy "OR('UdimaMSP.member','MinisterioMSP.member')" \
approveForMyMinisterio() {
    setGlobalsForPeer0Ministerio

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from org 2 ===================== "
}

# approveForMyMinisterio

checkCommitReadyness() {

    setGlobalsForPeer0Udima
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
        --collections-config $PRIVATE_DATA_CONFIG \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0Udima
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0Udima
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0Udima
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA \
        --isInit -c '{"Args":[]}'

}

# chaincodeInvokeInit

chaincodeInvoke() {
  
    setGlobalsForPeer0Udima
  
    ## Add private data
  
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA \
         -c '{"Args":["createExam","1","2","3","4","5"]}'
        
}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForPeer0Ministerio

    # Query Exam by Hash
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getExam","Args":["1"]}'

}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
# presetup

packageChaincode
installChaincode
queryInstalled
approveForMyUdima
checkCommitReadyness
approveForMyMinisterio
checkCommitReadyness
commitChaincodeDefination
queryCommitted
chaincodeInvokeInit
sleep 5
chaincodeInvoke
sleep 3
chaincodeQuery
