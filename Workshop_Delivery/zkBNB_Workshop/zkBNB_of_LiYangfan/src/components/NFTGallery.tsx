//@ts-nocheck
import React from 'react'
import NFTCard from './NFTCard'

const NFTGallery = ({props}) => {
    const nfts = JSON.parse(props)
    console.log("NFT objects:")
    console.log(nfts)
    return (
        <div className='container mx-auto pt-1 mb-4'>
            <div className='row row-cols-lg-4'>
                {nfts.map(token => <NFTCard key={token.index} nft={token}/>)}
            </div>
        </div>
    );
}

export default NFTGallery