set -x

mkdir -p /organizations/peerOrganizations/officer.fins.com/
export FABRIC_CA_CLIENT_HOME=/organizations/peerOrganizations/officer.fins.com/

fabric-ca-client enroll -u https://admin:adminpw@ca-officer:9054 --caname ca-officer --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca-officer-9054-ca-officer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca-officer-9054-ca-officer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca-officer-9054-ca-officer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca-officer-9054-ca-officer.pem
    OrganizationalUnitIdentifier: orderer' > "/organizations/peerOrganizations/officer.fins.com/msp/config.yaml"



fabric-ca-client register --caname ca-officer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"

fabric-ca-client register --caname ca-officer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"

fabric-ca-client register --caname ca-officer --id.name officeradmin --id.secret officeradminpw --id.type admin --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"

fabric-ca-client enroll -u https://peer0:peer0pw@ca-officer:9054 --caname ca-officer -M "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/msp" --csr.hosts peer0.officer.fins.com --csr.hosts  peer0-officer --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"

cp "/organizations/peerOrganizations/officer.fins.com/msp/config.yaml" "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/msp/config.yaml"

fabric-ca-client enroll -u https://peer0:peer0pw@ca-officer:9054 --caname ca-officer -M "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls" --enrollment.profile tls --csr.hosts peer0.officer.fins.com --csr.hosts  peer0-officer --csr.hosts ca-officer --csr.hosts localhost --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"


cp "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/ca.crt"
cp "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/signcerts/"* "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/server.crt"
cp "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/keystore/"* "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/server.key"

mkdir -p "/organizations/peerOrganizations/officer.fins.com/msp/tlscacerts"
cp "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/officer.fins.com/msp/tlscacerts/ca.crt"

mkdir -p "/organizations/peerOrganizations/officer.fins.com/tlsca"
cp "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/officer.fins.com/tlsca/tlsca.officer.fins.com-cert.pem"

mkdir -p "/organizations/peerOrganizations/officer.fins.com/ca"
cp "/organizations/peerOrganizations/officer.fins.com/peers/peer0.officer.fins.com/msp/cacerts/"* "/organizations/peerOrganizations/officer.fins.com/ca/ca.officer.fins.com-cert.pem"


fabric-ca-client enroll -u https://user1:user1pw@ca-officer:9054 --caname ca-officer -M "/organizations/peerOrganizations/officer.fins.com/users/User1@officer.fins.com/msp" --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"

cp "/organizations/peerOrganizations/officer.fins.com/msp/config.yaml" "/organizations/peerOrganizations/officer.fins.com/users/User1@officer.fins.com/msp/config.yaml"

fabric-ca-client enroll -u https://officeradmin:officeradminpw@ca-officer:9054 --caname ca-officer -M "/organizations/peerOrganizations/officer.fins.com/users/Admin@officer.fins.com/msp" --tls.certfiles "/organizations/fabric-ca/officer/tls-cert.pem"

cp "/organizations/peerOrganizations/officer.fins.com/msp/config.yaml" "/organizations/peerOrganizations/officer.fins.com/users/Admin@officer.fins.com/msp/config.yaml"

{ set +x; } 2>/dev/null