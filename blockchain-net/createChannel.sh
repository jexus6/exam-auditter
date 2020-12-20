export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_UDIMA_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/ca.crt
export PEER0_MINISTERIO_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=mychannel

# setGlobalsForOrderer(){
#     export CORE_PEER_LOCALMSPID="OrdererMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp
    
# }

setGlobalsForPeer0Udima(){
    export CORE_PEER_LOCALMSPID="UdimaMSP"
    echo $CORE_PEER_LOCALMSPID
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_UDIMA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/users/Admin@udima.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Udima(){
    export CORE_PEER_LOCALMSPID="UdimaMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_UDIMA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/users/Admin@udima.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0Ministerio(){
    export CORE_PEER_LOCALMSPID="MinisterioMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MINISTERIO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/users/Admin@ministerio.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer1Ministerio(){
    export CORE_PEER_LOCALMSPID="MinisterioMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MINISTERIO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/users/Admin@ministerio.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    
}

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Udima
    
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

removeOldCrypto(){
    
    rm -rf ./../back/udima-wallet/*
    rm -rf ./../back/ministerio-wallet/*
}


joinChannel(){
    setGlobalsForPeer0Udima
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1Udima
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer0Ministerio
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1Ministerio
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

updateAnchorPeers(){
    setGlobalsForPeer0Udima
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0Ministerio
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

#removeOldCrypto
echo "CREATE CHANNEL";
createChannel
echo "JOIN CHANNEL";
joinChannel
echo "UPDATE ANCHOR";
updateAnchorPeers