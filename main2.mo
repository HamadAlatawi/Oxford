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


actor class Main(name:Text){
    stable var usersArray: [User.User]=[];
    stable var productsArray: [Product.Product]=[];
   
    var userBuffer=Buffer.fromArray<User.User>(usersArray);
    var productBuffer = Buffer.fromArray<Product.Product>(productsArray);
    
    var user= await createUser(name);

    public func numberOfSplits(str: Text, delimiter: Text): async Nat {
        var count:Nat=0;
            for (c in str.chars()) {
                if (Text.equal(Text.fromChar(c), delimiter)) {
                    
                count +=1;
                } 
            };
        return count;
    };


    public query func getAllUserNames(): async [Text] {
        let namebuffer= Buffer.Buffer<Text>(0);
        for (index in usersArray.vals()){
            // let name=await index.getName();
            // namebuffer.add(name);
        };
        return Buffer.toArray(namebuffer);
    };

    public query func createUser(name:Text): async ?User.User {
       let fullNameSplits= await numberOfSplits(name," ");
       if (fullNameSplits != 1){
        var flag:Bool=false;
        let usernames=await getAllUserNames();
         for (username in usernames.vals()){
            if (Text.equal(name,username)){
                flag:=true;
                //break;
            };
         };
        if(flag==false){
            let cycles = Cycles.add(14692307692);
            return await User.User(name, [],[],[],[],[]);
        }; 
       };
       return null;
    };
    //{0.0,#btc},{#eth,0.0},{#icp,0.0},{#usd,0.0},{#eur,0.0},{#gbp,0.0}

    public query func loginUser (name:Text): async ?User.User {
       let flag:Bool=false;
         for (index in usersArray.vals()){
            if (Text.equal(name, await index.getName())){
                return index;
            };
        };
        return null;
    };

    public func createProduct(name:Text, category:Text ,price:Types.Price, shortDesc: Text, longDesc:Text, isVisible:Bool): async(){
        if (user!=null){
        let cycles = Cycles.add(14692307692);
        let product = Product.Product(await user.getName(), name, category ,price, shortDesc, longDesc, isVisible);
        updateProductArray(product);
        };
    };

    public func updateProductArray(product: Product.Product): async() {
        productBuffer.add(product);
        productsArray:=Buffer.toArray<Product.Product>(productBuffer);
    };

    public query func getAllProducts ():async [Product.Product]{
        return productsArray; 
    };


    public query func getAllProductTypesFromObjectArray (productObjList:[Product.Product]): async [ObjectTypes.Product] {
        let typeBuffer= Buffer.Buffer<ObjectTypes.Product>(0);
        for (product in productObjList.vals()){
            typeBuffer.add(await (convertProductToType(product)));
            };
        return Buffer.toArray(typeBuffer);
    };
    
    public query func getAllProductTypes(): async [ObjectTypes.Product] {
        return await (getAllProductTypesFromObjectArray(await getAllProducts())); 
    };



    public query func convertProductToType(product:Product.Product): async ObjectTypes.Product {
        return{
                sellerID= await product.getSellerID();
                name=await product.getName();
                productPrice=await product.getPrice();
                productShortDesc=await product.getShortDesc();
                productLongDesc=await product.getLongDesc();
                isSold=await product.getStatus();
                isVisible=await product.getIsVisible();
        }
    };

    public func convertTransactionToType(transaction:Transaction.Transaction): async ObjectTypes.Transaction {
    return{
        id= await transaction.getID();
        productID=await transaction.getProductID();
        buyerID=await transaction.getBuyerID();
        paidPrice=await transaction.getPaidPrice();
    };
    };

    public func convertUserToType(user:User.User): async ObjectTypes.User {
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