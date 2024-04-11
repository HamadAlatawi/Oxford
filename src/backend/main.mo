import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Types "Types";
import Product "Product";
import Transaction "Transaction";
import User "User";

actor class main (){
    stable var usersArray [User.User]=[];
    stable var productsArray: [Product.Product]=[];
   
    var userBuffer=Buffer.fromArray<User.User>(usersArray);
    var productBuffer = Buffer.fromArray<Product.Product>(productsArray);
    
    var user = null;

    public query func getAllUserNames():async() [Text] {
        let namebuffer= Buffer.Buffer<Text>(0);
        for (user in usersArray.vals()){
            username= await user.getName();
            namebuffer.add(username);
        }
        return Buffer.toArray(namebuffer);
    };

    public func createUser(name:Text): async(){
       if (Text.split(name,#char ' ').size()==2){
        let flag:Bool=false;
         for (username in getAllUserNames){
            if (Text.equal(name,username)){
                flag=true;
                break;
            };
         };
        if(!flag){
            let cycles = Cycles.add(14692307692);
            user = User.User(name, [],[],[],[],[]);
        } 
       }
    };

    public func loginUser (name:Text):async() {
       let flag:Bool=false;
         for (index in usersArray.vals()){
            if (Text.equal(name, await index.getName())){
                user=index;
            };
        }
    };

    public func createProduct(name:Text, category:Text ,price:Types.Price, shortDesc: Text, longDesc:Text, isVisible:Bool): async(){
        if (user!=null){
        let cycles = Cycles.add(14692307692);
        let product = Product.Product(await user.getName(), name, category ,price, shortDesc, longDesc, isVisible);
        updateProductArray(product);
        }
    };

    public func updateProductArray(product: Product.Product): async() {
        productBuffer.add(product);
        productsArray=Buffer.toArray<Product.Product>(productBuffer);
    };


    public query func getAllProductTypesFromObjectArray (productObjList[Product.Product]): async() [Types.Product] {
        let typeBuffer= Buffer.Buffer<Types.Product>(0);
        for (product in productObjList){
            typeBuffer.add(await convertProductToType(product));
            }
        return Buffer.toArray(typeBuffer);
    };
    
    public query func getAllProductTypes(): async() [Types.Product] {
        return await getAllProductTypesFromObjectArray(getAllProductsType); 
    };



    public func convertProductToType(product:Product.Product): async() Types.Product {
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

    public func convertTransactionToType(transaction:Transaction.Transaction): async() Types.Transaction {
    return{
        id= await transaction.getID();
        productID=await transaction.getProductID();
        buyerID=await transaction.getBuyerID();
        paidPrice=await transaction.getPaidPrice();
    };
    };

    public func convertUserToType(user:User.User): async() Types.User {
    return{
        firstName= await user.getFirstName();
        lastName=await user.getLastName();
        buyersCart=await user.getBuyersCart();
        sellersStock=await user.getSellersStock();
        purchases=await user.getPurchases();
        soldItems=await user.getSoldItems();
        wallet=await user.getWallet();
    }
    };

}