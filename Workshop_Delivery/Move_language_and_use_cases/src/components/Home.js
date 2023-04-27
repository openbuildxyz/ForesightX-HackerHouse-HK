
import Card from 'react-bootstrap/Card';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Button from 'react-bootstrap/Button';
import  React,{Component, useState} from 'react';
import { ConnectButton, useWalletKit } from "@mysten/wallet-kit";
import { formatAddress } from "@mysten/sui.js";


function Home(){

    const walletName = 'connect wallet';
    const [c_account, setAccount] = useState(walletName);
    const [c_cryptoID, setCryptoID] = useState('');
    const [stateLogin, setStateLogin] = useState('');
    const [stateContact, setStateContact] = useState('');
    const [disabledConnetctBtn, setDisabledConnectBtn] = useState(false);

    const [showModal, setShowModal] = useState(false);
    const [userAgent, setUserAgent] = useState(null);
    const [callState, setCallState] = useState("idle");
    const [rotateImage, setRotateImage] = useState(false);
    const [contact, setContact] = useState('');

    const { currentAccount } = useWalletKit();


  return(
   <>
      <Container >
        <Row style={{ marginTop: '30px' }}>
            <Col style={{ textAlign: 'left' }}>
                <Button variant="outline-primary" href='/'>Home</Button>{' '}
                <Button variant="outline-primary" style={{ marginLeft: '15px' }} href='/apps' >Apps</Button>{' '}
            </Col>
            <Col style={{ textAlign: 'right',marginBottom: '30px' }}>
            <ConnectButton
                connectText={"Connect Wallet"}
                connectedText = {currentAccount != null ? `Connected: ${formatAddress(currentAccount.address)}` : "Connect Wallet"}
                // connectedText={`Connected: ${formatAddress(currentAccount.address)}`}
            />            
            </Col>
        </Row>

        <Row>
            <Col md={{ span: 3, offset: 6 }} style={{ margin: '0px auto' }}>
                <Card style={{ width: '18rem' }}>
                <Card.Body>
                    <Card.Title>Sui</Card.Title>
                    <Card.Text>
                    Docs for Sui, a next-generation smart contract platform with high throughput, low latency, 
                    and an asset-oriented programming model powered by Move
                    </Card.Text>
                    <label id='contact_state_label' style={{ color: 'red', marginLeft: '10px', fontSize: '14px' }} > {stateContact} </label>
                    <div className='text-center' style={{ marginTop: '15px' }}>
                        <Button style={{ marginLeft: '10px' }} id='contact_call_btn' href='https://docs.sui.io/devnet/build' > Learn More </Button> 
                    </div>
                </Card.Body>
                </Card>
            </Col>
        </Row>

    </Container>
   </>
  );
}

export default Home;

