import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type Currency = { 'btc' : null } |
  { 'eth' : null } |
  { 'eur' : null } |
  { 'gbp' : null } |
  { 'icp' : null } |
  { 'usd' : null };
export interface Main {
  'createProduct' : ActorMethod<
    [string, string, string, Price, string, string, boolean, string],
    Principal
  >,
  'createUser' : ActorMethod<[string], Principal>,
  'getAllProductTypes' : ActorMethod<[], Array<Product>>,
  'getAllProductTypesFromObjectArray' : ActorMethod<
    [Array<Principal>],
    Array<Product>
  >,
  'getAllProducts' : ActorMethod<[], Array<Principal>>,
  'getAllUserNames' : ActorMethod<[], Array<string>>,
  'getAllUserTypes' : ActorMethod<[], Array<User__1>>,
  'getAllUsers' : ActorMethod<[], Array<Principal>>,
  'getAllUsersTypesFromObjectArray' : ActorMethod<
    [Array<Principal>],
    Array<User__1>
  >,
  'loginUser' : ActorMethod<[string], Principal>,
  'purchase' : ActorMethod<[Principal, Price, Principal], undefined>,
}
export interface Price { 'currency' : Currency, 'amount' : bigint }
export interface Product {
  'productLongDesc' : string,
  'productCategory' : string,
  'name' : string,
  'productShortDesc' : string,
  'productID' : bigint,
  'isSold' : boolean,
  'isVisible' : boolean,
  'sellerID' : string,
  'productPicture' : string,
  'productPrice' : Price,
}
export interface Product__1 {
  'getCategory' : ActorMethod<[], string>,
  'getIsSold' : ActorMethod<[], boolean>,
  'getIsVisible' : ActorMethod<[], boolean>,
  'getLongDesc' : ActorMethod<[], string>,
  'getName' : ActorMethod<[], string>,
  'getPicture' : ActorMethod<[], string>,
  'getPrice' : ActorMethod<[], Price>,
  'getProductID' : ActorMethod<[], bigint>,
  'getSellerID' : ActorMethod<[], string>,
  'getShortDesc' : ActorMethod<[], string>,
  'setIsVisible' : ActorMethod<[boolean], undefined>,
  'setLongDesc' : ActorMethod<[string], undefined>,
  'setName' : ActorMethod<[string], undefined>,
  'setPicture' : ActorMethod<[string], undefined>,
  'setPrice' : ActorMethod<[Price], undefined>,
  'setProductID' : ActorMethod<[bigint], undefined>,
  'setShortDesc' : ActorMethod<[string], undefined>,
  'updateStatus' : ActorMethod<[], undefined>,
}
export interface Transaction {
  'id' : bigint,
  'paidPrice' : Price,
  'productID' : string,
  'buyerID' : string,
}
export interface User {
  'addToCart' : ActorMethod<[Product], undefined>,
  'addToPurchases' : ActorMethod<[Transaction], undefined>,
  'addToSoldItems' : ActorMethod<[Transaction], undefined>,
  'addToWallet' : ActorMethod<[Price], undefined>,
  'getBuyersCart' : ActorMethod<[], Array<Product>>,
  'getName' : ActorMethod<[], string>,
  'getPurchases' : ActorMethod<[], Array<Transaction>>,
  'getSellersStock' : ActorMethod<[], Array<Product>>,
  'getSoldItems' : ActorMethod<[], Array<Transaction>>,
  'getWallet' : ActorMethod<[], Array<Price>>,
  'listItem' : ActorMethod<[Product], undefined>,
  'setBuyersCart' : ActorMethod<[Array<Product>], undefined>,
  'setName' : ActorMethod<[string], undefined>,
  'setPurchases' : ActorMethod<[Array<Transaction>], undefined>,
  'setSellersStock' : ActorMethod<[Array<Product>], undefined>,
  'setSoldItems' : ActorMethod<[Array<Transaction>], undefined>,
  'setWallet' : ActorMethod<[Array<Price>], undefined>,
  'takeFromWallet' : ActorMethod<[Price], undefined>,
}
export interface User__1 {
  'name' : string,
  'soldItems' : Array<Transaction>,
  'buyersCart' : Array<Product>,
  'sellersStock' : Array<Product>,
  'purchases' : Array<Transaction>,
  'wallet' : Array<Price>,
}
export interface _SERVICE extends Main {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
