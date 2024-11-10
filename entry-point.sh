CHAINID=${CHAINID:-stargaze}

cp /root/config.yaml .

hyperlane core deploy --chain lazy --yes

echo y | yarn cw-hpl upload local -n $CHAINID
yarn cw-hpl deploy local -n $CHAINID

# Parse stargaze contracts address
jq '.chains.stargaze = {mailbox: .chains.stargaze.mailbox, validatorAnnounce: .chains.stargaze.validatorAnnounce, interchainGasPaymaster: .chains.stargaze.interchainGasPaymaster, merkleTreeHook: .chains.stargaze.merkleTreeHook}' ./context/$CHAINID.config.json > stargaze.json

# Parse lazy contract address
yq eval -o=json . /root/.hyperlane/chains/lazy/addresses.yaml | jq '{chains: {lazy: .}}' > lazy.json

# Join 2 json Maps
jq -s '.[0] * .[1]' stargaze.json lazy.json > chains.json

cat chains.json