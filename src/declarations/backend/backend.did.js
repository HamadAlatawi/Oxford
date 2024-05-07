export const idlFactory = ({ IDL }) => {
  const Currency = IDL.Variant({
    'btc' : IDL.Null,
    'eth' : IDL.Null,
    'eur' : IDL.Null,
    'gbp' : IDL.Null,
    'icp' : IDL.Null,
    'usd' : IDL.Null,
  });
  const Price = IDL.Record({ 'currency' : Currency, 'amount' : IDL.Nat });
  const Product = IDL.Service({
    'getCategory' : IDL.Func([], [IDL.Text], ['query']),
    'getIsSold' : IDL.Func([], [IDL.Bool], ['query']),
    'getIsVisible' : IDL.Func([], [IDL.Bool], ['query']),
    'getLongDesc' : IDL.Func([], [IDL.Text], ['query']),
    'getName' : IDL.Func([], [IDL.Text], ['query']),
    'getPicture' : IDL.Func([], [IDL.Text], ['query']),
    'getPrice' : IDL.Func([], [Price], ['query']),
    'getProductID' : IDL.Func([], [IDL.Nat], ['query']),
    'getSellerID' : IDL.Func([], [IDL.Text], ['query']),
    'getShortDesc' : IDL.Func([], [IDL.Text], ['query']),
    'setIsVisible' : IDL.Func([IDL.Bool], [], []),
    'setLongDesc' : IDL.Func([IDL.Text], [], []),
    'setName' : IDL.Func([IDL.Text], [], []),
    'setPicture' : IDL.Func([IDL.Text], [], []),
    'setPrice' : IDL.Func([Price], [], []),
    'setProductID' : IDL.Func([IDL.Nat], [], ['query']),
    'setShortDesc' : IDL.Func([IDL.Text], [], []),
    'updateStatus' : IDL.Func([], [], []),
  });
  const Transaction = IDL.Service({
    'getBuyerID' : IDL.Func([], [IDL.Text], ['query']),
    'getID' : IDL.Func([], [IDL.Nat], ['query']),
    'getPaidPrice' : IDL.Func([], [Price], ['query']),
    'getProductID' : IDL.Func([], [IDL.Text], ['query']),
    'setBuyerID' : IDL.Func([IDL.Text], [], []),
    'setPaidPrice' : IDL.Func([Price], [], []),
    'setProductID' : IDL.Func([IDL.Text], [], []),
  });
  const User = IDL.Service({
    'addToCart' : IDL.Func([Product], [], []),
    'addToPurchases' : IDL.Func([Transaction], [], []),
    'addToSoldItems' : IDL.Func([Transaction], [], []),
    'addToWallet' : IDL.Func([Price], [], []),
    'getBuyersCart' : IDL.Func([], [IDL.Vec(Product)], ['query']),
    'getName' : IDL.Func([], [IDL.Text], ['query']),
    'getPurchases' : IDL.Func([], [IDL.Vec(Transaction)], ['query']),
    'getSellersStock' : IDL.Func([], [IDL.Vec(Product)], ['query']),
    'getSoldItems' : IDL.Func([], [IDL.Vec(Transaction)], ['query']),
    'getWallet' : IDL.Func([], [IDL.Vec(Price)], ['query']),
    'listItem' : IDL.Func([Product], [], []),
    'setBuyersCart' : IDL.Func([IDL.Vec(Product)], [], []),
    'setName' : IDL.Func([IDL.Text], [], []),
    'setPurchases' : IDL.Func([IDL.Vec(Transaction)], [], []),
    'setSellersStock' : IDL.Func([IDL.Vec(Product)], [], []),
    'setSoldItems' : IDL.Func([IDL.Vec(Transaction)], [], []),
    'setWallet' : IDL.Func([IDL.Vec(Price)], [], []),
    'takeFromWallet' : IDL.Func([Price], [], []),
  });
  const Product__1 = IDL.Record({
    'productLongDesc' : IDL.Text,
    'productCategory' : IDL.Text,
    'name' : IDL.Text,
    'productShortDesc' : IDL.Text,
    'productID' : IDL.Nat,
    'isSold' : IDL.Bool,
    'isVisible' : IDL.Bool,
    'sellerID' : IDL.Text,
    'productPicture' : IDL.Text,
    'productPrice' : Price,
  });
  const User__1 = IDL.Record({
    'name' : IDL.Text,
    'soldItems' : IDL.Vec(Transaction),
    'buyersCart' : IDL.Vec(Product),
    'sellersStock' : IDL.Vec(Product),
    'purchases' : IDL.Vec(Transaction),
    'wallet' : IDL.Vec(Price),
  });
  const Rate = IDL.Record({ 'rate' : IDL.Text, 'currency' : IDL.Text });
  const HttpHeader = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const HttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const TransformArgs = IDL.Record({
    'context' : IDL.Vec(IDL.Nat8),
    'response' : HttpResponsePayload,
  });
  const HttpHeader__1 = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const CanisterHttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader__1),
  });
  const Main = IDL.Service({
    'createProduct' : IDL.Func(
        [
          IDL.Text,
          IDL.Text,
          IDL.Text,
          Price,
          IDL.Text,
          IDL.Text,
          IDL.Bool,
          IDL.Text,
        ],
        [Product],
        [],
      ),
    'createUser' : IDL.Func([IDL.Text], [User], []),
    'getAllProductTypes' : IDL.Func([], [IDL.Vec(Product__1)], []),
    'getAllProductTypesFromObjectArray' : IDL.Func(
        [IDL.Vec(Product)],
        [IDL.Vec(Product__1)],
        [],
      ),
    'getAllProducts' : IDL.Func([], [IDL.Vec(Product)], ['query']),
    'getAllUserNames' : IDL.Func([], [IDL.Vec(IDL.Text)], []),
    'getAllUserTypes' : IDL.Func([], [IDL.Vec(User__1)], []),
    'getAllUsers' : IDL.Func([], [IDL.Vec(User)], ['query']),
    'getAllUsersTypesFromObjectArray' : IDL.Func(
        [IDL.Vec(User)],
        [IDL.Vec(User__1)],
        [],
      ),
    'getConfirmationDetails' : IDL.Func([IDL.Text], [IDL.Vec(Rate)], []),
    'loginUser' : IDL.Func([IDL.Text], [User], []),
    'purchase' : IDL.Func([User, Price, Product], [], []),
    'transform' : IDL.Func(
        [TransformArgs],
        [CanisterHttpResponsePayload],
        ['query'],
      ),
  });
  return Main;
};
export const init = ({ IDL }) => { return []; };
