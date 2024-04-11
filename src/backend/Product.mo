import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Float "mo:base/Float";
import Types "Types";
import Bool "mo:base/Bool"

actor class Product(sellerID:Text, name:Text, price:Types.Price, shortDesc: Text, longDesc:Text, isVisible:Bool=true){
    var productSellerID:Text=sellerID;
    var productName:Text=name;
    var productPrice:Types.Price=price;
    var productShortDesc:Text=shortDesc;
    var productLongDesc:Text=longDesc;
    var prosuctIsVisible:Bool=isVisible;
    var isSold:Bool=false;

    public query func getSellerID(): async Text{
        return productSellerID;
    };

    public query func getName(): async Text{
        return productName;
    };

    public query func getPrice(): async Types.Price{
        return productPrice;
    };

    public query func getShortDesc(): async Text{
        return productShortDesc;
    };

    public query func getLongDesc(): async Text{
        return productLongDesc;
    };

    public query func getIsSold(): async Bool{
        return isSold;
    };

    public query func getIsVisible(): async Bool{
        return isVisible;
    };

    public func setName(newName: Text):async (){
        productName:= newName;
    };

    public func setPrice(newPrice: Types.Price): async(){
        productPrice:=newPrice;
    };

    public func setShortDesc(newShortDesc: Text): async(){
        productShortDesc:=newShortDesc;
    };

    public func setLongDesc(newLongDesc: Text): async(){
        productLongDesc:=newLongDesc;
    };

    public func updateStatus(): async() {
        isSold:=true;
    };

    public func setIsVisible( visiblity:Bool ): async(){
        prosuctIsVisible:=visiblity;
    }

};