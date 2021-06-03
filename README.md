# NFT-Script
NFT script that make our life easier

The script work with specific wallet name and hierarchy

**Script workflow**
- Create Policy dir with **policy.vkey & policy.skey**
- Create **policy.script** file
- Create **nft_metadata.json** file with asset info (for pool.pm)
- Build the transaction & calculate the min fee - Ready to **Sign & Submit**
- Sign & Submit (second script)

**Make Sure you have your ipfs file already**

## INSTRUCTIONS

1) Create a wallet && Named it **nft**
2) Transfer **5 ADA** to nft wallet
3) Edit **nft_env** file
4) **Run** the script

## nft_env - Most fill everything     

ASSETNAME="assetname"

TOKENNAME="given name #001"

IMGLINK="https://arare.io"

CREATOR="Creator Name"

IGLINK="https://instagram.com/ararestakepool"

base_addr="$(cat $CNODE_HOME/priv/wallet/nft/base.addr)"

asset_amount=10

## Running the Script

```
./policy.sh
```

## Sign & Submit

```
./sign.sh
```

## Contributing

Thank you for your interest in [ARARE](https://arare.io) NFT Script! Head over to our [Telegram](https://t.me/ararestakepool) for instructions on how to use and for asking changes!


#### Support

To report **bugs** and **issues** with scripts and documentation please join our [Telegram Chat](https://t.me/ararestakepool) **or** [GitHub Issue](https://github.com/ARARE-pool/NFT-Script/issues/new/choose).  
**Feature requests** are best opened as a [discussion thread](https://github.com/ARARE-pool/NFT-Script/discussions/new).

* inspired by cntools code
