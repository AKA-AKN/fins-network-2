CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="finschannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="true"}
FABRIC_CFG_PATH=${PWD}configtx


createChannelTx() {

	set -x
	configtxgen -profile FourOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
	if [ $res -ne 0 ]; then
		fatalln "Failed to generate channel configuration transaction..."
	fi

}

createAncorPeerTx() {

	for orgmsp in FarmerMSP InsuranceMSP OfficerMSP ResearchersMSP; do

	echo "Generating anchor peer update transaction for ${orgmsp}"
	set -x
	configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/${orgmsp}anchors.tx -channelID $CHANNEL_NAME -asOrg ${orgmsp}
	res=$?
	{ set +x; } 2>/dev/null
	if [ $res -ne 0 ]; then
		fatalln "Failed to generate anchor peer update transaction for ${orgmsp}..."
	fi
	done
}



verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}



## Create channeltx
echo "Generating channel create transaction '${CHANNEL_NAME}.tx'"
createChannelTx

## Create anchorpeertx
echo "Generating anchor peer update transactions"
createAncorPeerTx



exit 0