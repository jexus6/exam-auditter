createcertificatesForUDIMA() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p crypto-config-ca/peerOrganizations/udima.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.udima.example.com --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-udima-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-udima-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-udima-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-udima-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.udima.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.udima.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.udima.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.udima.example.com --id.name udimaadmin --id.secret udimaadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  mkdir -p crypto-config-ca/peerOrganizations/udima.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.udima.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/msp --csr.hosts peer0.udima.example.com --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.udima.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls --enrollment.profile tls --csr.hosts peer0.udima.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/tlsca
  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/tlsca/tlsca.udima.example.com-cert.pem

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/ca
  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer0.udima.example.com/msp/cacerts/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/ca/ca.udima.example.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.udima.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/msp --csr.hosts peer1.udima.example.com --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.udima.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/tls --enrollment.profile tls --csr.hosts peer1.udima.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/peers/peer1.udima.example.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p crypto-config-ca/peerOrganizations/udima.example.com/users
  mkdir -p crypto-config-ca/peerOrganizations/udima.example.com/users/User1@udima.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.udima.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/users/User1@udima.example.com/msp --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  mkdir -p crypto-config-ca/peerOrganizations/udima.example.com/users/Admin@udima.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://udimaadmin:udimaadminpw@localhost:7054 --caname ca.udima.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/users/Admin@udima.example.com/msp --tls.certfiles ${PWD}/fabric-ca/udima/tls-cert.pem

  cp ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/udima.example.com/users/Admin@udima.example.com/msp/config.yaml

}

# createcertificatesForUDIMA

createCertificateForMINISTERIO() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /crypto-config-ca/peerOrganizations/ministerio.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.ministerio.example.com --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-ministerio-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-ministerio-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-ministerio-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-ministerio-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.ministerio.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  echo
  echo "Register peer1"
  echo
   
  fabric-ca-client register --caname ca.ministerio.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.ministerio.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.ministerio.example.com --id.name ministerioadmin --id.secret ministerioadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  mkdir -p crypto-config-ca/peerOrganizations/ministerio.example.com/peers
  mkdir -p crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.ministerio.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/msp --csr.hosts peer0.ministerio.example.com --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.ministerio.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls --enrollment.profile tls --csr.hosts peer0.ministerio.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/tlsca
  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/tlsca/tlsca.ministerio.example.com-cert.pem

  mkdir ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/ca
  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer0.ministerio.example.com/msp/cacerts/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/ca/ca.ministerio.example.com-cert.pem

  # --------------------------------------------------------------------------------
  #  Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo
   
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.ministerio.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/msp --csr.hosts peer1.ministerio.example.com --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.ministerio.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/tls --enrollment.profile tls --csr.hosts peer1.ministerio.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/tls/keystore/* ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/peers/peer1.ministerio.example.com/tls/server.key
  # -----------------------------------------------------------------------------------

  mkdir -p crypto-config-ca/peerOrganizations/ministerio.example.com/users
  mkdir -p crypto-config-ca/peerOrganizations/ministerio.example.com/users/User1@ministerio.example.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.ministerio.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/users/User1@ministerio.example.com/msp --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  mkdir -p crypto-config-ca/peerOrganizations/ministerio.example.com/users/Admin@ministerio.example.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://ministerioadmin:ministerioadminpw@localhost:8054 --caname ca.ministerio.example.com -M ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/users/Admin@ministerio.example.com/msp --tls.certfiles ${PWD}/fabric-ca/ministerio/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/msp/config.yaml ${PWD}/crypto-config-ca/peerOrganizations/ministerio.example.com/users/Admin@ministerio.example.com/msp/config.yaml

}

# createCertificateForMINISTERIO

createCretificateForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p crypto-config-ca/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/ordererOrganizations/example.com

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer2"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register orderer3"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers
  # mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/example.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/users
  mkdir -p crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

# createCretificateForOrderer

sudo rm -rf crypto-config-ca/*
# sudo rm -rf fabric-ca/*
createcertificatesForUDIMA
createCertificateForMINISTERIO
createCretificateForOrderer

