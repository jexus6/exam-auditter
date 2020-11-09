export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_UDIMA_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/ca.crt
export PEER0_MINISTERIO_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

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


invokeFunctions() {
    # Get Transaction By tx id
    setGlobalsForPeer0Udima
    peer chaincode invoke \
        -o localhost:7050 \
        --cafile $ORDERER_CA \
        --tls $CORE_PEER_TLS_ENABLED \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
        -C mychannel -n qscc \
        -c '{"function":"GetTransactionByID","Args":["mychannel", "eb00ec055803ca538fc32637e622caa62687c30e07c84d7002ad4e73a13e71b1"]}'

    # peer chaincode invoke \
    #     -o localhost:7050 \
    #     --cafile $ORDERER_CA \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
    #     -C mychannel -n qscc \
    #     -c '{"function":"GetChainInfo","Args":["mychannel"]}'

    # peer chaincode invoke \
    #     -o localhost:7050 \
    #     --cafile $ORDERER_CA \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
    #     -C mychannel -n qscc \
    #     -c '{"function":"GetBlockByNumber","Args":["mychannel","2"]}'

}
invokeFunctions