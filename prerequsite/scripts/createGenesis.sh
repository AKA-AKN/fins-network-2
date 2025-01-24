

export FABRIC_CFG_PATH=${PWD}configtx


configtxgen -profile FourOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block