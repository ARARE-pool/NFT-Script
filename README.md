# NFT-Script
NFT script that make our life easier

The script work with specific wallet name and hierarchy. The script is one-time mint, if you want to mint more tokens you have to do it manually - This is how we learn

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
3) Make a dir with the name of the nft you want
4) Download the Github files into the folder
5) Add your env file to the folder
6) Edit **nft_env** file - **make sure your NFT is already on ipfs**
7) Change **Permissions** <pre>
chmod 755 policy.sh
chmod 755 metadata.sh
chmod 755 sign.sh </pre> 
8) **Run** the script


## nft_env - Most fill everything     
<pre>
ASSETNAME="assetname"
TOKENNAME="given name #001"
IMGLINK="ipfs://QmZohc2mLgsXDhF17DskrLdGraPKPmSVbefp5kXmT7WfuC"
CREATOR="ARARE Pool"
IGLINK="https://instagram.com/adararestakepool"
base_addr="$(cat $CNODE_HOME/priv/wallet/nft/base.addr)"
asset_amount=10
</pre>

##

## Running the Script

```
./policy.sh
```

## Sign & Submit

```
./sign.sh
```

## More info
the script is semi-auto, it need you to be involved in the order of executing, folders name, delete duplicate files ect..
If you already executed `policy.sh` it will auto create a policy folder. if you want to run `policy.sh` again you need to delete/move the folder before you execute

## Contributing

Thank you for your interest in [ARARE](https://arare.io) NFT Script! Head over to our [Telegram](https://t.me/ararestakepool) for instructions on how to use and for asking changes!


#### Support

To report **bugs** and **issues** with scripts and documentation please join our [Telegram Chat](https://t.me/ararestakepool) **or** [GitHub Issue](https://github.com/ARARE-pool/NFT-Script/issues/new/choose).  
**Feature requests** are best opened as a [discussion thread](https://github.com/ARARE-pool/NFT-Script/discussions/new).

<i>inspired by cntools code</i>
