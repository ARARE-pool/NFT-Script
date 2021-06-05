#!/usr/bin/env bash


########## Global tasks ###########################################


getBalance() {
  declare -gA utxos=(); declare -gA assets=(); declare -gA policyIDs=()
  assets["lovelace"]=0; utxo_cnt=0
  asset_name_maxlen=5; asset_amount_maxlen=12
  tx_in=""
  
  if [[ -z ${1} ]] || ! utxo_raw=$(cardano-cli query utxo --mainnet --address "${1}"); then return 1; fi
  
  [[ -z ${utxo_raw} ]] && return
  
  while IFS= read -r line; do
    IFS=' ' read -ra utxo_entry <<< "${line}"
    [[ ${#utxo_entry[@]} -lt 4 ]] && continue
    ((utxo_cnt++))
    tx_in+=" --tx-in ${utxo_entry[0]}#${utxo_entry[1]}"
    utxos["${utxo_entry[0]}#${utxo_entry[1]}. Ada"]=${utxo_entry[2]} # Space added before 'Ada' for sort to place it first
    assets["lovelace"]=$(( ${assets["lovelace"]:-0} + utxo_entry[2] ))
    if [[ ${#utxo_entry[@]} -gt 4 ]]; then
      idx=5
      while [[ ${#utxo_entry[@]} -gt ${idx} ]]; do
        local asset_amount=${utxo_entry[${idx}]}
        local asset_hash_name="${utxo_entry[$((idx+1))]}"
        IFS='.' read -ra asset <<< "${asset_hash_name}"
        policyIDs["${asset[0]}"]=1
        [[ ${#asset[@]} -eq 2 && ${#asset[1]} -gt ${asset_name_maxlen} ]] && asset_name_maxlen=${#asset[1]}
        local asset_fmt="$(formatAsset ${asset_amount})"
        [[ ${#asset_fmt} -gt ${asset_amount_maxlen} ]] && asset_amount_maxlen=${#asset_fmt}
        assets["${asset_hash_name}"]=$(( ${assets["${asset_hash_name}"]:-0} + asset_amount ))
        utxos["${utxo_entry[0]}#${utxo_entry[1]}.${asset_hash_name}"]=${asset_amount}
        idx=$(( idx + 3 ))
      done
    fi
  done <<< "${utxo_raw}"
  local lovelace_fmt="$(formatLovelace ${assets["lovelace"]})"
  [[ ${#lovelace_fmt} -gt ${asset_amount_maxlen} ]] && asset_amount_maxlen=${#lovelace_fmt}
}




cd policy

cardano-cli transaction policyid --script-file policy.script > policy.id

###### WRITING SCRIPT ########
echo "{\"721\":{\"$(cat policy.id)\":{\"${ASSETNAME}\":{\"name\":\"${TOKENNAME}\",\"image\":\"${IMGLINK}\",\"Creator\":\"${CREATOR}\",\"Instagram\":\"${IGLINK}\"}}}}" > "nft_meta.json"
echo -e "\nPolicy ID           : ${FG_LBLUE}$(cat policy.id)${NC}"




cardano-cli  query protocol-parameters \
--mainnet \
--out-file protocol.json

getBalance ${base_addr}
# echo -e "${utxo_entry[1]}"
# echo -e "${tx_in}"


sleep 0.5
echo -e "Balance is          : ${FG_LBLUE}${assets[lovelace]} lovelace${NC}"

##### DUMMY TRANSACTION #####

# echo -e "cardano-cli transaction build-raw \
# 	--fee 0 \
# 	${tx_in} \
# 	--tx-out ${base_addr}+${assets[lovelace]}+"${asset_amount} $(cat policy.id).${ASSETNAME}" \
#     --mint "${asset_amount} $(cat policy.id).${ASSETNAME}" \
#     --minting-script-file policy.script \
#     --metadata-json-file nft_meta.json \
#     --invalid-hereafter ${SLOTBEFORE} \
#     --out-file matx.raw"  > "matx.json"

cardano-cli transaction build-raw \
	--fee 0 \
	${tx_in} \
	--tx-out ${base_addr}+${assets[lovelace]}+"${asset_amount} $(cat policy.id).${ASSETNAME}" \
    --mint "${asset_amount} $(cat policy.id).${ASSETNAME}" \
    --minting-script-file policy.script \
    --metadata-json-file nft_meta.json \
    --invalid-hereafter ${SLOTBEFORE} \
    --out-file matx.raw



##### FEE CALCULATE #####

min_fee_args=(
		transaction calculate-min-fee
		--tx-body-file matx.raw
		--tx-in-count 1
		--tx-out-count 1
		--mainnet
		--witness-count 2
		--protocol-params-file protocol.json
	)
min_fee=$([[ "$(cardano-cli ${min_fee_args[*]})" =~ ([0-9]+) ]] && echo ${BASH_REMATCH[1]})

sleep 0.5
echo -e "Fee is              : ${FG_LBLUE}${min_fee} lovelance${NC}"

newBalance=$(( ${assets[lovelace]} - min_fee ))
tx_out="${addr}+${newBalance}${assets_tx_out}"
sleep 0.5
echo -e "New Balance is      : ${FG_LBLUE}${newBalance} lovelance${NC}"

##### BUILDING FINAL TRANSACTION #####

echo -e "\n\n\nBuilding new transaction"
cardano-cli transaction build-raw \
	${tx_in} \
	--tx-out ${base_addr}+${newBalance}+"${asset_amount} $(cat policy.id).${ASSETNAME}" \
	--mint "${asset_amount} $(cat policy.id).${ASSETNAME}" \
	--minting-script-file policy.script \
	--metadata-json-file nft_meta.json \
	--invalid-hereafter ${SLOTBEFORE} \
	--fee ${min_fee} \
	--out-file matx.raw

echo -e "New transaction has built"

sleep 2
echo -e "\n\nReady to Sign & Submit"
sleep 2


##### SIGN & SUBMIT #####
cd ..
if { getAnswer "Do you wanna procceed to Sign?"; }; then . ./sign.sh
else echo -e "Answer was : No \n" && sleep 1
  echo -e "Please execute sign.sh script to sign & submit" && sleep 1
  echo -e "${FG_RED}Exiting Script${NC}" && sleep 1 && myExit
fi

sleep 1
