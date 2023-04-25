// @ts-nocheck
import React from 'react';

//component that takes an nft object and maps it to corresponding elements
const NFTCard = ({ nft }) => {
    return (
        <div className="col pt-4 ">
            <div className='card shadow-lg p-2'>
                <img src={nft.metadata.image} alt="NFT" className="card-image-top" />
                <div className="card-body">
                    <h5 className="card-title text-dark">{nft.metadata.name}</h5>
                    <p className="card-text text-dark">{nft.metadata.description}</p>
                </div>
            </div>
        </div>
    )
}

export default NFTCard;