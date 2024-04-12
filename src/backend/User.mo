import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Types "Types";
import Product "Product";
import Transaction "Transaction";
import Buffer "mo:base/Buffer";

actor class User(name:Text, buyersCart:[Product.Product], sellersStock:[Product.Product], purchases:[Transaction.Transaction], soldItems:[Transaction.Transaction], wallet:[Types.Price]){
    var userName:Text=name;
    stable var userBuyersCart:[Product.Product]=buyersCart;
    stable var userSellersStock:[Product.Product]=sellersStock;
    stable var userPurchases:[Transaction.Transaction]=purchases;
    stable var userSoldItems:[Transaction.Transaction]=soldItems;
    stable var userWallet:[Types.Price]=wallet;

    var buyersCartBuffer = Buffer.fromArray<Product.Product>(userBuyersCart);
    var sellersStockBuffer = Buffer.fromArray<Product.Product>(userSellersStock);
    var purchasesBuffer = Buffer.fromArray<Transaction.Transaction>(userPurchases);
    var soldItemsBuffer = Buffer.fromArray<Transaction.Transaction>(userSoldItems);
    var walletBuffer = Buffer.fromArray<Types.Price>(userWallet);

    public query func getName(): async Text{
        return userName;
    };
    public query func getBuyersCart(): async [Product.Product]{
        return userBuyersCart;
    };

    public query func getSellersStock(): async [Product.Product]{
        return userSellersStock;
    };

    public query func getPurchases(): async [Transaction.Transaction]{
        return userPurchases;
    };

    public query func getSoldItems(): async [Transaction.Transaction]{
        return userSoldItems;
    };

    public query func getWallet(): async [Types.Price]{
        return userWallet;
    };

    public func setName(newName: Text):async (){
        userName:= newName;
    };

    public func setBuyersCart(newBuyersCart: [Product.Product]): async(){
        userBuyersCart:=newBuyersCart;
    };

    public func setSellersStock(newSellersStock: [Product.Product]): async(){
        userSellersStock:=newSellersStock;
    };

    public func setPurchases(newPurchases: [Transaction.Transaction]): async(){
        userPurchases:=newPurchases;
    };

    public func setSoldItems(newSoldItems: [Transaction.Transaction]): async(){
        userSoldItems:= newSoldItems;
    };

    public func setWallet(newWallet: [Types.Price]): async(){
        userWallet:= newWallet;
    };

    public func addToCart (product: Product.Product): async() {
        buyersCartBuffer.add(product);
        await setBuyersCart(Buffer.toArray(buyersCartBuffer));
    };

    public func listItem(product: Product.Product): async() {
        sellersStockBuffer.add(product);
        await setSellersStock(Buffer.toArray(sellersStockBuffer));
    };

    public func addToPurchases (transaction: Transaction.Transaction): async() {
        purchasesBuffer.add(transaction);
        await setPurchases(Buffer.toArray(purchasesBuffer));
    };

    public func addToSoldItems (transaction: Transaction.Transaction): async() {
        soldItemsBuffer.add(transaction);
        await setSoldItems(Buffer.toArray(soldItemsBuffer));
    };

    // public func changeWalletInfo(newWallet: [Types.Price]): async(){
    //     for (i in newWallet.vals()){
    //         for (j in userWallet.vals()){
    //             if (Text.equal(i.currency, j.currency)){
    //                 j.amount:=i.amount;
    //             } 
    //         };
    //     };
    // };


};
