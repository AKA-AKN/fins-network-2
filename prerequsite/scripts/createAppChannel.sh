peer channel create -o orderer:7050 -c finschannel -f ./channel-artifacts/finschannel.tx --outputBlock ./channel-artifacts/finschannel.block --tls --cafile /organizations/ordererOrganizations/fins.com/orderers/orderer.fins.com/msp/tlscacerts/tlsca.fins.com-cert.pem

