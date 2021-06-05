#!/usr/bin/env bash


########## Global tasks ###########################################

myExit() {
	exit
}

PARENT="$(dirname $0)"
if [[ ! -f "${PARENT}"/env ]]; then
  echo -e "\nCommon env file missing: ${PARENT}/env"
  echo -e "This is a mandatory prerequisite, please install with prereqs.sh or manually download from GitHub\n"
  myExit 1
fi

PARENT="$(dirname $0)"
if [[ ! -f "${PARENT}"/nft_env ]]; then
  echo -e "\nCommon env file missing: ${PARENT}/nft_env"
  echo -e "Please donwload the NFT env file from GitHub\n"
  myExit 1
fi

. "${PARENT}"/env
. "${PARENT}"/nft_env


echo "  __   ____   __   ____  ____     "
echo " / _\ (  _ \ / _\ (  _ \(  __)    "
echo "/    \ )   //    \ )   / ) _)     "
echo "\_/\_/(__\_)\_/\_/(__\_)(____)    " && sleep 0.4
echo " ____  ____  __   __ _  ____      "
echo "/ ___)(_  _)/ _\ (  / )(  __)     "
echo "\___ \  )( /    \ )  (  ) _)      "
echo "(____/ (__)\_/\_/(__\_)(____)     " && sleep 0.4
echo " ____   __    __   __             "
echo "(  _ \ /  \  /  \ (  )            "
echo " ) __/(  O )(  O )/ (_/\          "
echo "(__)   \__/  \__/ \____/          " && sleep 0.4
echo " __ _  ____  ____                 "
echo "(  ( \(  __)(_  _)                "
echo "/    / ) _)   )(                  "
echo "\_)__)(__)   (__)                 " && sleep 0.4
echo " ____   ___  ____  __  ____  ____ "
echo "/ ___) / __)(  _ \(  )(  _ \(_  _)"
echo "\___ \( (__  )   / )(  ) __/  )(  "
echo "(____/ \___)(__\_)(__)(__)   (__) " && sleep 0.4


echo -e "\n\nWelcome to ARARE NFT script" && sleep 0.1
if { getAnswer "Would you like to start?"; }; then sleep 0.4
else echo -e "${FG_LBLUE}Bye Bye${NC}"
	 sleep 0.4 && myExit
fi

echo -e "\n\nHow long (sec) do you want the policy to be valid? (0=unlimited) ${FG_GREEN}"
read ttl_enter
echo -e "${NC}"
	if ! isNumber ${ttl_enter}; then
	  echo -e "\nERROR: invalid TTL number, non digit characters found: ${ttl_enter}"
	  myExit
	fi
	if [[ ${ttl_enter} -eq 0 ]]; then
	  echo "ttl = 0 (Unlimited)"
	  SLOTBEFORE=0
	else
	  ttl=$(( $(getSlotTipRef) + (ttl_enter/SLOT_LENGTH) ))
	  SLOTBEFORE=${ttl}
	  echo -e "Tip right now       : ${FG_LBLUE}$(getSlotTipRef)${NC}"
	  echo -e "Invaild after       : ${FG_LBLUE}${SLOTBEFORE}${NC}"
	  # cardano-cli query tip --mainnet
	fi

mkdir policy && cd policy
cardano-cli address key-gen \
    --verification-key-file policy.vkey \
    --signing-key-file policy.skey

sleep 0.5
echo -e "Policy keyHash      : ${FG_LBLUE}$(cardano-cli address key-hash --payment-verification-key-file policy.vkey)${NC}"




sleep 0.5
echo "{\"type\":\"all\",\"scripts\":[{\"keyHash\":\"$(cardano-cli address key-hash --payment-verification-key-file policy.vkey)\",\"type\":\"sig\"},{\"type\":\"before\",\"slot\": ${SLOTBEFORE}}]}" > "policy.script"

cd ..

. ./metadata.sh


echo -e "\n\n${FG_GREEN}THE END${NC}"
