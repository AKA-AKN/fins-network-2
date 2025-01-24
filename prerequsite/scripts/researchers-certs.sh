set -x

mkdir -p /organizations/peerOrganizations/researchers.fins.com/
export FABRIC_CA_CLIENT_HOME=/organizations/peerOrganizations/researchers.fins.com/

fabric-ca-client enroll -u https://admin:adminpw@ca-researchers:9054 --caname ca-researchers --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca-researchers-9054-ca-researchers.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca-researchers-9054-ca-researchers.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca-researchers-9054-ca-researchers.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca-researchers-9054-ca-researchers.pem
    OrganizationalUnitIdentifier: orderer' > "/organizations/peerOrganizations/researchers.fins.com/msp/config.yaml"



fabric-ca-client register --caname ca-researchers --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"

fabric-ca-client register --caname ca-researchers --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"

fabric-ca-client register --caname ca-researchers --id.name researchersadmin --id.secret researchersadminpw --id.type admin --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"

fabric-ca-client enroll -u https://peer0:peer0pw@ca-researchers:9054 --caname ca-researchers -M "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/msp" --csr.hosts peer0.researchers.fins.com --csr.hosts  peer0-researchers --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"

cp "/organizations/peerOrganizations/researchers.fins.com/msp/config.yaml" "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/msp/config.yaml"

fabric-ca-client enroll -u https://peer0:peer0pw@ca-researchers:9054 --caname ca-researchers -M "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls" --enrollment.profile tls --csr.hosts peer0.researchers.fins.com --csr.hosts  peer0-researchers --csr.hosts ca-researchers --csr.hosts localhost --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"


cp "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/ca.crt"
cp "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/signcerts/"* "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/server.crt"
cp "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/keystore/"* "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/server.key"

mkdir -p "/organizations/peerOrganizations/researchers.fins.com/msp/tlscacerts"
cp "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/researchers.fins.com/msp/tlscacerts/ca.crt"

mkdir -p "/organizations/peerOrganizations/researchers.fins.com/tlsca"
cp "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/tls/tlscacerts/"* "/organizations/peerOrganizations/researchers.fins.com/tlsca/tlsca.researchers.fins.com-cert.pem"

mkdir -p "/organizations/peerOrganizations/researchers.fins.com/ca"
cp "/organizations/peerOrganizations/researchers.fins.com/peers/peer0.researchers.fins.com/msp/cacerts/"* "/organizations/peerOrganizations/researchers.fins.com/ca/ca.researchers.fins.com-cert.pem"


fabric-ca-client enroll -u https://user1:user1pw@ca-researchers:9054 --caname ca-researchers -M "/organizations/peerOrganizations/researchers.fins.com/users/User1@researchers.fins.com/msp" --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"

cp "/organizations/peerOrganizations/researchers.fins.com/msp/config.yaml" "/organizations/peerOrganizations/researchers.fins.com/users/User1@researchers.fins.com/msp/config.yaml"

fabric-ca-client enroll -u https://researchersadmin:researchersadminpw@ca-researchers:9054 --caname ca-researchers -M "/organizations/peerOrganizations/researchers.fins.com/users/Admin@researchers.fins.com/msp" --tls.certfiles "/organizations/fabric-ca/researchers/tls-cert.pem"

cp "/organizations/peerOrganizations/researchers.fins.com/msp/config.yaml" "/organizations/peerOrganizations/researchers.fins.com/users/Admin@researchers.fins.com/msp/config.yaml"

{ set +x; } 2>/dev/null