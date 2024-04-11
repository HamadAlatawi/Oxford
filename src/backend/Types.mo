import Curves "../../motoko-bitcoin/src/ec/Curves";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
module Types {
    public type SendRequest = {
        destination_address : Text;
        amount_in_satoshi : Satoshi;
    };

    public type ECDSAPublicKeyReply = {
        public_key : Blob;
        chain_code : Blob;
    };

    public type EcdsaKeyId = {
        curve : EcdsaCurve;
        name : Text;
    };

    public type EcdsaCurve = {
        #secp256k1;
    };

    public type SignWithECDSAReply = {
        signature : Blob;
    };

    public type ECDSAPublicKey = {
        canister_id : ?Principal;
        derivation_path : [Blob];
        key_id : EcdsaKeyId;
    };

    public type SignWithECDSA = {
        message_hash : Blob;
        derivation_path : [Blob];
        key_id : EcdsaKeyId;
    };

    public type Satoshi = Nat64;
    public type MillisatoshiPerVByte = Nat64;
    public type Cycles = Nat;
    public type BitcoinAddress = Text;
    public type BlockHash = [Nat8];
    public type Page = [Nat8];

    public let CURVE = Curves.secp256k1;
    
    /// The type of Bitcoin network the dapp will be interacting with.
    public type Network = {
        #mainnet;
        #testnet;
        #regtest;
    };

    /// The type of Bitcoin network as defined by the Bitcoin Motoko library
    /// (Note the difference in casing compared to `Network`)
    public type NetworkCamelCase = {
        #Mainnet;
        #Testnet;
        #Regtest;
    };

    public func network_to_network_camel_case(network: Network) : NetworkCamelCase {
        switch (network) {
            case (#regtest) {
                #Regtest
            };
            case (#testnet) {
                #Testnet
            };
            case (#mainnet) {
                #Mainnet
            };
        }
    };

    /// A reference to a transaction output.
    public type OutPoint = {
        txid : Blob;
        vout : Nat32;
    };

    /// An unspent transaction output.
    public type Utxo = {
        outpoint : OutPoint;
        value : Satoshi;
        height : Nat32;
    };

    /// A request for getting the balance for a given address.
    public type GetBalanceRequest = {
        address : BitcoinAddress;
        network : Network;
        min_confirmations : ?Nat32;
    };

    /// A filter used when requesting UTXOs.
    public type UtxosFilter = {
        #MinConfirmations : Nat32;
        #Page : Page;
    };

    /// A request for getting the UTXOs for a given address.
    public type GetUtxosRequest = {
        address : BitcoinAddress;
        network : Network;
        filter : ?UtxosFilter;
    };

    /// The response returned for a request to get the UTXOs of a given address.
    public type GetUtxosResponse = {
        utxos : [Utxo];
        tip_block_hash : BlockHash;
        tip_height : Nat32;
        next_page : ?Page;
    };

    /// A request for getting the current fee percentiles.
    public type GetCurrentFeePercentilesRequest = {
        network : Network;
    };

    public type SendTransactionRequest = {
        transaction : [Nat8];
        network : Network;
    };

    public type Currency=
{
    #BTC;
    #ETH;
    #ICP;
    #USD;
    #EUR;
    #GBP;
};

public type Price=
{
    currency: Currency;
    amount: Float;
};

public type Product={
    sellerID:Text;
    name:Text;
    productPrice:Price;
    productShortDesc:Text;
    productLongDesc:Text;
    isSold:Bool;
    isVisible:Bool;
};

public type Transaction={
    id:Nat;
    productID:Text;
    buyerID:Text;
    paidPrice:Types.Price;
};

public type User{
    name:Text;
    buyersCart:[Product.Product];
    sellersStock:[Product.Product];
    purchases:[Transaction.Transaction];
    soldItems:[Transaction.Transaction];
    wallet:[Types.Price];
};

}

