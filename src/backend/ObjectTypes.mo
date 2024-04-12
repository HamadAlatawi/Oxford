import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Product "Product";
import Transaction "Transaction";
import User "User";
import Types "Types";
import Text "mo:base/Text";

module ObjectTypes {

public type Product={
    sellerID:Text;
    name:Text;
    productPrice:Types.Price;
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

public type User={
    name:Text;
    buyersCart:[Product.Product];
    sellersStock:[Product.Product];
    purchases:[Transaction.Transaction];
    soldItems:[Transaction.Transaction];
    wallet:[Types.Price];
};

}