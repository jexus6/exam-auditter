export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_UDIMA_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/ca.crt
export PEER0_MINISTERIO_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForOrderer(){
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp
    
}

setGlobalsForPeer0Udima(){
    export CORE_PEER_LOCALMSPID="UdimaMSP"
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

presetup(){
    echo Vendoring Go dependencies ...
    pushd ./artifacts/src/github.com/fabcar_contract_api/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./artifacts/src/github.com/fabcar/go/"
CC_NAME="fabcar"

packageChaincode(){
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0Udima
    peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.udima ===================== "
}

installChaincode(){
    setGlobalsForPeer0Udima
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.udima ===================== "
    
    setGlobalsForPeer1Udima
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.udima ===================== "
    
    setGlobalsForPeer0Ministerio
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.ministerio ===================== "
    
    setGlobalsForPeer1Ministerio
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.ministerio ===================== "
}

queryInstalled(){
    setGlobalsForPeer0Udima
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.udima on channel ===================== "
}

approveForMyUdima(){
    setGlobalsForPeer0Udima

    peer lifecycle chaincode approveformyorg -o localhost:7050  \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --version ${VERSION} --init-required --package-id ${PACKAGE_ID} --sequence ${VERSION}

    echo "===================== chaincode approved from org 1 ===================== "
    
}

# --signature-policy "OR ('UdimaMSP.member')"
# --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA
# --peerAddresses peer0.udima.example.com:7051 --tlsRootCertFiles $PEER0_UDIMA_CA --peerAddresses peer0.ministerio.example.com:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA
#--channel-config-policy Channel/Application/Admins
# --signature-policy "OR ('UdimaMSP.peer','MinisterioMSP.peer')"


checkCommitReadyness(){
    setGlobalsForPeer0Udima

    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
    --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required

    echo "===================== checking commit readyness from org 1 ===================== "
}

approveForMyMinisterio(){
    setGlobalsForPeer0Ministerio

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --version ${VERSION} --init-required \
    --package-id ${PACKAGE_ID} --sequence ${VERSION}

    echo "===================== chaincode approved from org 2 ===================== "
}

checkCommitReadyness(){
    
    setGlobalsForPeer0Udima

    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
    --name ${CC_NAME} --version ${VERSION} \
    --sequence ${VERSION} --output json --init-required

    echo "===================== checking commit readyness from org 1 ===================== "
}

commitChaincodeDefination(){
    setGlobalsForPeer0Udima

    peer lifecycle chaincode commit -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED  --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA \
    --version ${VERSION} --sequence ${VERSION} \
    --init-required
   
   echo "===================== Chaincode Defination commited on peer0-org 1 and peer0-ministerio ===================== "
}

queryCommitted(){
    setGlobalsForPeer0Udima

    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

    
}

chaincodeInvokeInit(){
    setGlobalsForPeer0Udima

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA \
    --isInit -c '{"function":"initLedger","Args":[]}'
    
}


chaincodeInvoke(){
    # setGlobalsForPeer0Udima

    # Initialize Ledger
    # peer chaincode invoke -o localhost:7050 \
    # --ordererTLSHostnameOverride orderer.example.com \
    # --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} \
    # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_UDIMA_CA \
    # --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA  \
    # -c '{"function":"initLedger","Args":[]}'
    
    setGlobalsForPeer0Udima

    ## Create Car
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME}  \
    #     --peerAddresses localhost:7051 \
    #     --tlsRootCertFiles $PEER0_UDIMA_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA $PEER_CONN_PARMS  \
    #     -c '{"function": "CreateCar","Args":["Car-ABCDEEE", "Audi", "R8", "Red", "Pavan"]}'
    
    ## Change car owner
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 \
        --tlsRootCertFiles $PEER0_UDIMA_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_MINISTERIO_CA $PEER_CONN_PARMS  \
        -c '{"function": "ChangeCarOwner","Args":["Car-ABCDEEE", "Sandip"]}'
}

chaincodeQuery(){
    setGlobalsForPeer0Udima

    # Query all Cars
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

    # Query by Car id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryCar", "Car-ABCDEEE"]}'
}

# packageChaincode
# installChaincode
# queryInstalled
# approveForMyUdima
# checkCommitReadyness
# approveForMyMinisterio
# checkCommitReadyness
# commitChaincodeDefination
# queryCommitted
# chaincodeInvokeInit
chaincodeInvoke
chaincodeQuery