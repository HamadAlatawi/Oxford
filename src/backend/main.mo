import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Types "Types";
import Product "Product";
import Transaction "Transaction";
import User "User";
import ObjectTypes "ObjectTypes";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Cycles "mo:base/ExperimentalCycles";


actor class Main(){
    stable var usersArray: [User.User]=[];
    stable var productsArray: [Product.Product]=[];
   
    var userBuffer=Buffer.fromArray<User.User>(usersArray);
    var productBuffer = Buffer.fromArray<Product.Product>(productsArray);

    public func getAllUserNames(): async [Text] {
        let namebuffer= Buffer.Buffer<Text>(0);
        for (index in usersArray.vals()){
            let name=await index.getName();
            namebuffer.add(name);
        };
        return Buffer.toArray(namebuffer);
    };
     private func numberOfSplits(str: Text, delimiter: Text):async Nat {
        var count:Nat=0;
            for (c in str.chars()) {
                if (Text.equal(Text.fromChar(c), delimiter)) {
                count +=1;
                } 
            };
        return count;
    };

    public func createUser(name:Text): async User.User {
       let fullNameSplits= await numberOfSplits(name," ");
       if (fullNameSplits != 1){
        var flag:Bool=false;
        let usernames=await getAllUserNames();
         for (username in usernames.vals()){
            if (Text.equal(name,username)){
                flag:=true;
            };
         }; 
        };
        let cycles = Cycles.add(14692307692);
        let user=await User.User(name, [],[],[],[],[{currency=#eth;amount=0},{currency=#btc;amount=0},{currency=#icp;amount=0},{currency=#usd;amount=0},{currency=#gbp;amount=0},{currency=#eur;amount=0}]);
        let temp=updateUserArray(user);
        return user;
       };
    private func updateUserArray(user: User.User): async() {
    userBuffer.add(user);
    usersArray:=Buffer.toArray<User.User>(userBuffer);
    };

    public func loginUser (name:Text): async User.User {
         for (index in usersArray.vals()){
            if (Text.equal(name, await index.getName())){
                return index;
            }
        };
        return await createUser(name); 
    };

    public query func getAllUsers ():async [User.User]{
        return usersArray; 
    };

    public func getAllUsersTypesFromObjectArray (userObjList:[User.User]): async [ObjectTypes.User] {
        let typeBuffer= Buffer.Buffer<ObjectTypes.User>(0);
        for (user in userObjList.vals()){
            typeBuffer.add(await (convertUserToType(user)));
            };
        return Buffer.toArray(typeBuffer);
    };

    public func getAllUserTypes(): async [ObjectTypes.User] {
        return await (getAllUsersTypesFromObjectArray(await getAllUsers())); 
    };



   

    public func createProduct(user:Text ,name:Text, category:Text ,price:Types.Price, shortDesc: Text, longDesc:Text, isVisible:Bool): async Product.Product{
        let cycles = Cycles.add(14692307692);
        var product = await Product.Product(user, name, category ,price, shortDesc, longDesc, isVisible);
        let temp=updateProductArray(product);
        return product
    };

    private func updateProductArray(product: Product.Product): async() {
        productBuffer.add(product);
        productsArray:=Buffer.toArray<Product.Product>(productBuffer);
    };

     public query func getAllProducts ():async [Product.Product]{
        return productsArray; 
    };


    public func getAllProductTypesFromObjectArray (productObjList:[Product.Product]): async [ObjectTypes.Product] {
        let typeBuffer= Buffer.Buffer<ObjectTypes.Product>(0);
        for (product in productObjList.vals()){
            typeBuffer.add(await (convertProductToType(product)));
            };
        return Buffer.toArray(typeBuffer);
    };
    
    public func getAllProductTypes(): async [ObjectTypes.Product] {
        return await (getAllProductTypesFromObjectArray(await getAllProducts())); 
    };

    public func purchase(user: User.User,price: Types.Price ,product:Product.Product): async(){
        let sellerName=await product.getSellerID();
        for(index in usersArray.vals()){
            let target= await user.getName();
            if (Text.equal(target,sellerName)){
                let x=index.addToWallet(price);
            };
        };
    };

    private func convertProductToType(product:Product.Product): async ObjectTypes.Product {
        return{
                sellerID= await product.getSellerID();
                name=await product.getName();
                productPrice=await product.getPrice();
                productShortDesc=await product.getShortDesc();
                productLongDesc=await product.getLongDesc();
                isSold=await product.getIsSold();
                isVisible=await product.getIsVisible();
        }
    };

    private func convertTransactionToType(transaction:Transaction.Transaction): async ObjectTypes.Transaction {
    return{
        id= await transaction.getID();
        productID=await transaction.getProductID();
        buyerID=await transaction.getBuyerID();
        paidPrice=await transaction.getPaidPrice();
    };
    };

    private func convertUserToType(user:User.User): async ObjectTypes.User {
    return{
        name= await user.getName();
        buyersCart=await user.getBuyersCart();
        sellersStock=await user.getSellersStock();
        purchases=await user.getPurchases();
        soldItems=await user.getSoldItems();
        wallet=await user.getWallet();
    }
    };   

}