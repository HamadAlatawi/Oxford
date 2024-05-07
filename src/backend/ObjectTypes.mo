import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

import Product "Product";
import Transaction "Transaction";
import Types "Types";
import User "User";

module ObjectTypes {

    public type Product = {
        sellerID : Text;
        name : Text;
        productPrice : Types.Price;
        productShortDesc : Text;
        productLongDesc : Text;
        isSold : Bool;
        isVisible : Bool;
        productID : Nat;
        productCategory : Text;
        productPicture : Text;
    };

    public type Transaction = {
        id : Nat;
        productID : Text;
        buyerID : Text;
        paidPrice : Types.Price;
    };

    public type User = {
        name : Text;
        buyersCart : [Product.Product];
        sellersStock : [Product.Product];
        purchases : [Transaction.Transaction];
        soldItems : [Transaction.Transaction];
        wallet : [Types.Price];
    };

};
