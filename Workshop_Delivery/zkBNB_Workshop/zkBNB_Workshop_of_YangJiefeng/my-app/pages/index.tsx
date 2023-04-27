import Image from 'next/image'
import { Inter } from 'next/font/google'
import { Client } from '@bnb-chain/zkbnb-js-sdk'
import Head from 'next/head'
import NFTGallery from '@/components/NFTGallery'

const inter = Inter({ subsets: ['latin'] })

const client = new Client('https://api-testnet.zkbnbchain.org')

async function fetchNFT() {
  // first get the account index by address
  const acct_res = await client.getAccountByL1Address("0x4b0469Dc710690403984369dA374B439fa215378")

  // then get the NFTs by account index
  const index = acct_res.index
  const requestParm = {accountIndex: index, offset: 0, limit: 10}
  const data = await client.getNftsByAccountIndex(requestParm)

  // preload all the metadata
  for (const nft of data.nfts) {
    const metadata_url = 'https://ipfs.io/ipfs/' + nft.ipfs_id
    const resp = await fetch(metadata_url)
    const resp_json = await resp.json()
    nft.metadata = JSON.parse(resp_json.meta_data)
  }

  return data.nfts
}

export const getStaticProps = async () => {
  try {
    console.log("Getting NFTs...")

    const nfts = await fetchNFT()
    const props = JSON.stringify(nfts)

    return {
      props: {
        props
      },
      revalidate: 3600
    };
  } catch (err) {
    console.error('page error', err)
    // we don't want to publish the error version of this page, so
    // let next.js know explicitly that incremental SSG failed
    throw err
  }
}


export default function Home(props) {
  return (
    <>
      <Head>
        <title>Create Next App</title>
        <meta name="description" content="Generated by create next app" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main>
        <h1>Jack&apos;s zkBNB NFT</h1>
        <NFTGallery {...props} />
      </main>
    </>
  )
}