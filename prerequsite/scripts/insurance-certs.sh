  set -x
mkdir -p /organizations/peerOrganizations/insurance.fins.com/
export FABRIC_CA_CLIENT_HOME=/organizations/peerOrganizations/insurance.fins.com/

fabric-ca-client enroll -u https://admin:adminpw@ca-insurance:8054 --caname ca-insurance --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca-insurance-8054-ca-insurance.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca-insurance-8054-ca-insurance.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca-insurance-8054-ca-insurance.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca-insurance-8054-ca-insurance.pem
    OrganizationalUnitIdentifier: orderer' > "/organizations/peerOrganizations/insurance.fins.com/msp/config.yaml"



fabric-ca-client register --caname ca-insurance --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"

fabric-ca-client register --caname ca-insurance --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"

fabric-ca-client register --caname ca-insurance --id.name insuranceadmin --id.secret insuranceadminpw --id.type admin --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"

fabric-ca-client enroll -u https://peer0:peer0pw@ca-insurance:8054 --caname ca-insurance -M "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/msp" --csr.hosts peer0.insurance.fins.com --csr.hosts  peer0-insurance --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"

cp "/organizations/peerOrganizations/insurance.fins.com/msp/config.yaml" "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/msp/config.yaml"

fabric-ca-client enroll -u https://peer0:peer0pw@ca-insurance:8054 --caname ca-insurance -M "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls" --enrollment.profile tls --csr.hosts peer0.insurance.fins.com --csr.hosts  peer0-insurance --csr.hosts ca-insurance --csr.hosts localhost --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"


cp "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/ca.crt"
cp "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/signcerts/"* "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/server.crt"
cp "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/keystore/"* "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/server.key"

mkdir -p "/organizations/peerOrganizations/insurance.fins.com/msp/tlscacerts"
cp "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/insurance.fins.com/msp/tlscacerts/ca.crt"

mkdir -p "/organizations/peerOrganizations/insurance.fins.com/tlsca"
cp "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/insurance.fins.com/tlsca/tlsca.insurance.fins.com-cert.pem"

mkdir -p "/organizations/peerOrganizations/insurance.fins.com/ca"
cp "/organizations/peerOrganizations/insurance.fins.com/peers/peer0.insurance.fins.com/msp/cacerts/"* "/organizations/peerOrganizations/insurance.fins.com/ca/ca.insurance.fins.com-cert.pem"


fabric-ca-client enroll -u https://user1:user1pw@ca-insurance:8054 --caname ca-insurance -M "/organizations/peerOrganizations/insurance.fins.com/users/User1@insurance.fins.com/msp" --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"

cp "/organizations/peerOrganizations/insurance.fins.com/msp/config.yaml" "/organizations/peerOrganizations/insurance.fins.com/users/User1@insurance.fins.com/msp/config.yaml"

fabric-ca-client enroll -u https://insuranceadmin:insuranceadminpw@ca-insurance:8054 --caname ca-insurance -M "/organizations/peerOrganizations/insurance.fins.com/users/Admin@insurance.fins.com/msp" --tls.certfiles "/organizations/fabric-ca/insurance/tls-cert.pem"

cp "/organizations/peerOrganizations/insurance.fins.com/msp/config.yaml" "/organizations/peerOrganizations/insurance.fins.com/users/Admin@insurance.fins.com/msp/config.yaml"

  { set +x; } 2>/dev/null