import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface CanisterHttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader__1>,
}
export type Currency = { 'btc' : null } |
  { 'eth' : null } |
  { 'eur' : null } |
  { 'gbp' : null } |
  { 'icp' : null } |
  { 'usd' : null };
export interface HttpHeader { 'value' : string, 'name' : string }
export interface HttpHeader__1 { 'value' : string, 'name' : string }
export interface HttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface Main {
  'createProduct' : ActorMethod<
    [string, string, string, Price, string, string, boolean, string],
    Principal
  >,
  'createUser' : ActorMethod<[string], Principal>,
  'getAllProductTypes' : ActorMethod<[], Array<Product__1>>,
  'getAllProductTypesFromObjectArray' : ActorMethod<
    [Array<Principal>],
    Array<Product__1>
  >,
  'getAllProducts' : ActorMethod<[], Array<Principal>>,
  'getAllUserNames' : ActorMethod<[], Array<string>>,
  'getAllUserTypes' : ActorMethod<[], Array<User__1>>,
  'getAllUsers' : ActorMethod<[], Array<Principal>>,
  'getAllUsersTypesFromObjectArray' : ActorMethod<
    [Array<Principal>],
    Array<User__1>
  >,
  'getConfirmationDetails' : ActorMethod<[string], Array<Rate>>,
  'loginUser' : ActorMethod<[string], Principal>,
  'purchase' : ActorMethod<[Principal, Price, Principal], undefined>,
  'transform' : ActorMethod<[TransformArgs], CanisterHttpResponsePayload>,
}
export interface Price { 'currency' : Currency, 'amount' : bigint }
export interface Product {
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
export interface Product__1 {
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
export interface Rate { 'rate' : string, 'currency' : string }
export interface Transaction {
  'getBuyerID' : ActorMethod<[], string>,
  'getID' : ActorMethod<[], bigint>,
  'getPaidPrice' : ActorMethod<[], Price>,
  'getProductID' : ActorMethod<[], string>,
  'setBuyerID' : ActorMethod<[string], undefined>,
  'setPaidPrice' : ActorMethod<[Price], undefined>,
  'setProductID' : ActorMethod<[string], undefined>,
}
export interface TransformArgs {
  'context' : Uint8Array | number[],
  'response' : HttpResponsePayload,
}
export interface User {
  'addToCart' : ActorMethod<[Principal], undefined>,
  'addToPurchases' : ActorMethod<[Principal], undefined>,
  'addToSoldItems' : ActorMethod<[Principal], undefined>,
  'addToWallet' : ActorMethod<[Price], undefined>,
  'getBuyersCart' : ActorMethod<[], Array<Principal>>,
  'getName' : ActorMethod<[], string>,
  'getPurchases' : ActorMethod<[], Array<Principal>>,
  'getSellersStock' : ActorMethod<[], Array<Principal>>,
  'getSoldItems' : ActorMethod<[], Array<Principal>>,
  'getWallet' : ActorMethod<[], Array<Price>>,
  'listItem' : ActorMethod<[Principal], undefined>,
  'setBuyersCart' : ActorMethod<[Array<Principal>], undefined>,
  'setName' : ActorMethod<[string], undefined>,
  'setPurchases' : ActorMethod<[Array<Principal>], undefined>,
  'setSellersStock' : ActorMethod<[Array<Principal>], undefined>,
  'setSoldItems' : ActorMethod<[Array<Principal>], undefined>,
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
export declare const init: ({ IDL }: { IDL: IDL }) => IDL.Type[];
