import { Client } from "@bnb-chain/zkbnb-js-sdk"

const client = new Client('https://api-testnet.zkbnbchain.org')

async function fetchNFT() {
    // first get the account index by address
    const acct_res = await client.getAccountByL1Address("0xcbeE6DdA2347C0EC0e45870d4D6cf3526a2E319C")

    // then get the NFTs by account index
    const index = acct_res.index
    const requestParm = { accountIndex: index, offset: 0, limit: 10 }
    const data: any = await client.getNftsByAccountIndex(requestParm)

    // preload all the metadata
    for (const nft of data.nfts) {
        const metadata_url = 'https://ipfs.io/ipfs/' + nft.ipfs_id
        const resp = await fetch(metadata_url)
        const resp_json = await resp.json()
        nft.metadata = JSON.parse(resp_json.meta_data)
    }

    return data.nfts
}

export {
    client,
    fetchNFT,
}