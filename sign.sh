#!/usr/bin/env bash

########## Global tasks ###########################################

myExit() {
	exit
}

PARENT="$(dirname $0)"
if [[ ! -f "${PARENT}"/nft_env ]]; then
  echo -e "\nCommon env file missing: ${PARENT}/nft_env"
  echo -e "Please donwload the NFT env file from GitHub\n"
  myExit 1
fi

. "${PARENT}"/nft_env

cd policy

##### SIGN TEST#####



##### SIGN #####

echo -e "\n\nSigning..." && sleep 3

cardano-cli transaction sign \
  --signing-key-file $CNODE_HOME/priv/wallet/nft/payment.skey \
  --signing-key-file policy.skey \
  --mainnet \
  --tx-body-file matx.raw \
  --out-file matx.signed

echo -e "${FG_LBLUE}Signed.${NC}" && sleep 0.4

##### SUBMIT #####

echo -e "\nSubmitting..." && sleep 3

cardano-cli transaction submit --tx-file  matx.signed --mainnet

echo -e "${FG_LBLUE}Submited.${NC}" && sleep 1

##### PRINTING INFO #####

echo -e "\n\nInfo" && sleep 0.4
echo -e "Policy ID      : ${FG_LBLUE}$(cat policy.id)${NC}" && sleep 0.4
echo -e "Asset Name     : ${FG_LBLUE}${ASSETNAME}${NC}" && sleep 0.4
echo -e "Minted         : ${FG_LBLUE}${asset_amount}${NC}" && sleep 0.4
echo -e "Invaild after  : ${FG_LBLUE}${SLOTBEFORE}${NC}"