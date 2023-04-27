// import {
//   BrowserRouter,
//   Routes,
//   Route,
//   Link,
// } from "react-router-dom";
// import './App.css';
// import Home from './components/Home.js';
// import NotPage from "./components/NotPage";


// function App() {
//   console.log('App start ...');
//   return (
//     <BrowserRouter>
//       <Routes>
//         <Route path="/" element={<Home />} />
//         <Route path="*" element = { <NotPage /> }/>
//       </Routes>
//     </BrowserRouter>
//   );
// }

// export default App;

import Home from './components/Home.js';
import { WalletKitProvider } from "@mysten/wallet-kit";

function App() {
  return <WalletKitProvider>{ <Home /> }</WalletKitProvider>;
}

export default App;