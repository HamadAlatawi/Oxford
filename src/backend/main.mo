import Assets "canister:fileUpload";

import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Cycles "mo:base/ExperimentalCycles";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";

import HttpTypes "../commons/HttpTypes";
import JSON "../commons/json/JSON";
import TransactionTypes "../commons/TransactionTypes";
import ObjectTypes "ObjectTypes";
import Product "Product";
import Transaction "Transaction";
import Types "Types";
import User "User";
// import Container "Container";
// import TypesImg "../commons/imgTypes";

//Actor
actor class Main() {
    stable var usersArray : [User.User] = [];
    stable var productsArray : [Product.Product] = [];
    stable var productIDNum : Nat = 0;

    var userBuffer = Buffer.fromArray<User.User>(usersArray);
    var productBuffer = Buffer.fromArray<Product.Product>(productsArray);

    public type Price = { SellerCurrency : Text; Amount : Nat };
    public type Rate = { currency : Text; rate : Text };
    type TransactionConfiramtionDetails = TransactionTypes.BtcTransactionConfiramtionDetails;
    //public type CurrencyRates = Array<Rate>;


    //CONFIRMATION LOGIC
    public func getConfirmationDetails(txidHash : Text) : async [Rate] {
        let ic : HttpTypes.IC = actor ("aaaaa-aa");

        let host : Text = "api.coinbase.com";
        let url = "https://" # host # "/v2/exchange-rates?currency=" # txidHash;

        let requestHeaders = [
            { name = "Host"; value = host # ":443" },
        ];

        let transformContext : HttpTypes.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        let httpRequest : HttpTypes.HttpRequestArgs = {
            url = url;
            max_response_bytes = null;
            headers = requestHeaders;
            body = null;
            method = #get;
            transform = ?transformContext;
        };

        ExperimentalCycles.add(HttpTypes.HTTP_REQUEST_CYCLES_COST);

        let httpResponse : HttpTypes.HttpResponsePayload = await ic.http_request(httpRequest);

        let responseBody : Blob = Blob.fromArray(httpResponse.body);
        let decodedResponse = switch (Text.decodeUtf8(responseBody)) {
            case (null) { throw Error.reject("Transaction Not Found!") };
            case (?decoded_text) { decoded_text };
        };
        await parseCurrencyRates(decodedResponse);

    };

    public query func transform(raw : HttpTypes.TransformArgs) : async Types.CanisterHttpResponsePayload {
        let transformed : HttpTypes.CanisterHttpResponsePayload = {
            status = raw.response.status;
            body = raw.response.body;
            headers = [
                {
                    name = "Content-Security-Policy";
                    value = "default-src 'self'";
                },
                { name = "Referrer-Policy"; value = "strict-origin" },
                { name = "Permissions-Policy"; value = "geolocation=(self)" },
                {
                    name = "Strict-Transport-Security";
                    value = "max-age=63072000";
                },
                { name = "X-Frame-Options"; value = "DENY" },
                { name = "X-Content-Type-Options"; value = "nosniff" },
            ];
        };
        transformed;
    };

    private func parseCurrencyRates(jsonText : Text) : async [Rate] {
        let jsonResponse : JSON.JSON = switch (JSON.parse(jsonText)) {
            case (?jsonResponse) { jsonResponse };
            case (null) { throw Error.reject("Not Valid JSON Response") };
        };
        var rating = Buffer.Buffer<Rate>(0);

        switch (jsonResponse) {
            case (#Object(jsonResponse)) {
                for ((key, value) in jsonResponse.vals()) {
                    if (Text.equal(key, "data")) {
                        switch (value) {
                            case (#Object(data)) {
                                for ((k, v) in data.vals()) {
                                    if (Text.equal(k, "rates")) {
                                        switch (v) {
                                            case (#Object(rates)) {
                                                for ((currency, rate) in rates.vals()) {
                                                    switch (rate) {
                                                        case (#String(rate)) {
                                                            rating.add({
                                                                currency = currency;
                                                                rate = rate;
                                                            });
                                                        };
                                                        case (_) {};
                                                    };
                                                };
                                            };
                                            case (_) {};
                                        };
                                    };
                                };
                            };
                            case (_) {};
                        };
                    };
                };
            };
            case (_) { throw Error.reject("Not Valid JSON Response") };
        };

        // Return the parsed rates
        Buffer.toArray(rating);
    };

    private func get_icp_usd_exchange() : async Text {

        //1. DECLARE IC MANAGEMENT CANISTER
        //We need this so we can use it to make the HTTP request
        let ic : Types.IC = actor ("aaaaa-aa");

        //2. SETUP ARGUMENTS FOR HTTP GET request

        // 2.1 Setup the URL and its query parameters
        let ONE_MINUTE : Nat64 = 60;
        let start_timestamp : Types.Timestamp = 1682978460; //May 1, 2023 22:01:00 GMT
        let end_timestamp : Types.Timestamp = 1682978520; //May 1, 2023 22:02:00 GMT
        let api_key = "b653cf6b-3018-4c57-8ab2-d307140666df";
        //let host : Text = "api.pro.coinbase.com";
        //let url = "https://" # host # "/products/ICP-USD/candles?start=" # Nat64.toText(start_timestamp) # "&end=" # Nat64.toText(start_timestamp) # "&granularity=" # Nat64.toText(ONE_MINUTE);
        //https://api.coinbase.com/v2/exchange-rates?currency=ICP

        let host : Text = "api.coinbase.com";
        let url = "https://" # host # "/v2/exchange-rates?currency=ICP";

        // 2.2 prepare headers for the system http_request call
        let request_headers = [
            { name = "Host"; value = host # ":443" },
            { name = "User-Agent"; value = "exchange_rate_canister" },
        ];

        // 2.2.1 Transform context
        let transform_context : Types.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        // 2.3 The HTTP request
        let http_request : Types.HttpRequestArgs = {
            url = url;
            max_response_bytes = null; //optional for request
            headers = request_headers;
            body = null; //optional for request
            method = #get;
            transform = ?transform_context;
        };

        //3. ADD CYCLES TO PAY FOR HTTP REQUEST

        //The IC specification spec says, "Cycles to pay for the call must be explicitly transferred with the call"
        //IC management canister will make the HTTP request so it needs cycles
        //See: https://internetcomputer.org/docs/current/motoko/main/cycles

        //The way Cycles.add() works is that it adds those cycles to the next asynchronous call
        //"Function add(amount) indicates the additional amount of cycles to be transferred in the next remote call"
        //See: https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-http_request
        Cycles.add(200000000000);

        //4. MAKE HTTPS REQUEST AND WAIT FOR RESPONSE
        //Since the cycles were added above, we can just call the IC management canister with HTTPS outcalls below
        let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

        //5. DECODE THE RESPONSE

        //As per the type declarations in `src/Types.mo`, the BODY in the HTTP response
        //comes back as [Nat8s] (e.g. [2, 5, 12, 11, 23]). Type signature:

        //public type HttpResponsePayload = {
        //     status : Nat;
        //     headers : [HttpHeader];
        //     body : [Nat8];
        // };

        //We need to decode that [Nat8] array that is the body into readable text.
        //To do this, we:
        //  1. Convert the [Nat8] into a Blob
        //  2. Use Blob.decodeUtf8() method to convert the Blob to a ?Text optional
        //  3. We use a switch to explicitly call out both cases of decoding the Blob into ?Text

        let response_body : Blob = Blob.fromArray(http_response.body);
        let decoded_text : Text = switch (Text.decodeUtf8(response_body)) {
            case (null) { "No value returned" };
            case (?y) { y };
        };

        //6. RETURN RESPONSE OF THE BODY
        //The API response will looks like this:
        decoded_text

    };

    public func getAllUserNames() : async [Text] {
        let namebuffer = Buffer.Buffer<Text>(0);
        for (index in usersArray.vals()) {
            let name = await index.getName();
            namebuffer.add(name);
        };
        return Buffer.toArray(namebuffer);
    };
    private func numberOfSplits(str : Text, delimiter : Text) : async Nat {
        var count : Nat = 0;
        for (c in str.chars()) {
            if (Text.equal(Text.fromChar(c), delimiter)) {
                count += 1;
            };
        };
        return count;
    };

    public func createUser(name : Text) : async User.User {
        let fullNameSplits = await numberOfSplits(name, " ");
        if (fullNameSplits != 1) {
            var flag : Bool = false;
            let usernames = await getAllUserNames();
            for (username in usernames.vals()) {
                if (Text.equal(name, username)) {
                    flag := true;
                };
            };
        };
        let cycles = Cycles.add(200000000000);
        let user = await User.User(name, [], [], [], [], [{ currency = #eth; amount = 0 }, { currency = #btc; amount = 0 }, { currency = #icp; amount = 0 }, { currency = #usd; amount = 0 }, { currency = #gbp; amount = 0 }, { currency = #eur; amount = 0 }]);
        let temp = updateUserArray(user);
        return user;
    };
    private func updateUserArray(user : User.User) : async () {
        userBuffer.add(user);
        usersArray := Buffer.toArray<User.User>(userBuffer);
    };

    public func loginUser(name : Text) : async User.User {
        for (index in usersArray.vals()) {
            if (Text.equal(name, await index.getName())) {
                return index;
            };
        };
        return await createUser(name);
    };

    public query func getAllUsers() : async [User.User] {
        return usersArray;
    };

    public func getAllUsersTypesFromObjectArray(userObjList : [User.User]) : async [ObjectTypes.User] {
        let typeBuffer = Buffer.Buffer<ObjectTypes.User>(0);
        for (user in userObjList.vals()) {
            typeBuffer.add(await (convertUserToType(user)));
        };
        return Buffer.toArray(typeBuffer);
    };

    public func getAllUserTypes() : async [ObjectTypes.User] {
        return await (getAllUsersTypesFromObjectArray(await getAllUsers()));
    };

    // public func editProduct(productID : Nat) : async (){
        
    // };

    public func createProduct(user : Text, name : Text, category : Text, price : Types.Price, shortDesc : Text, longDesc : Text, isVisible : Bool, picture : Text) : async Product.Product {
        let cycles = Cycles.add(200000000000);
        var product = await Product.Product(user, name, category, price, shortDesc, longDesc, isVisible, picture, productIDNum);
        productIDNum := productIDNum + 1;
        let temp = updateProductArray(product);
        return product;
    };

    private func updateProductArray(product : Product.Product) : async () {
        productBuffer.add(product);
        productsArray := Buffer.toArray<Product.Product>(productBuffer);
    };

    public query func getAllProducts() : async [Product.Product] {
        return productsArray;
    };

    public func getAllProductTypesFromObjectArray(productObjList : [Product.Product]) : async [ObjectTypes.Product] {
        let typeBuffer = Buffer.Buffer<ObjectTypes.Product>(0);
        for (product in productObjList.vals()) {
            typeBuffer.add(await (convertProductToType(product)));
        };
        return Buffer.toArray(typeBuffer);
    };

    public func getAllProductTypes() : async [ObjectTypes.Product] {
        return await (getAllProductTypesFromObjectArray(await getAllProducts()));
    };

    public func purchase(user : User.User, price : Types.Price, product : Product.Product) : async () {
        let sellerName = await product.getSellerID();
        for (index in usersArray.vals()) {
            let target = await user.getName();
            if (Text.equal(target, sellerName)) {
                let x = index.addToWallet(price);
            };
        };
    };

    private func convertProductToType(product : Product.Product) : async ObjectTypes.Product {
        return {
            sellerID = await product.getSellerID();
            name = await product.getName();
            productPrice = await product.getPrice();
            productShortDesc = await product.getShortDesc();
            productLongDesc = await product.getLongDesc();
            isSold = await product.getIsSold();
            isVisible = await product.getIsVisible();
            productID = await product.getProductID();
            productCategory = await product.getCategory();
            productPicture = await product.getPicture();
        };
    };

    private func convertTransactionToType(transaction : Transaction.Transaction) : async ObjectTypes.Transaction {
        return {
            id = await transaction.getID();
            productID = await transaction.getProductID();
            buyerID = await transaction.getBuyerID();
            paidPrice = await transaction.getPaidPrice();
        };
    };

    private func convertUserToType(user : User.User) : async ObjectTypes.User {
        return {
            name = await user.getName();
            buyersCart = await user.getBuyersCart();
            sellersStock = await user.getSellersStock();
            purchases = await user.getPurchases();
            soldItems = await user.getSoldItems();
            wallet = await user.getWallet();
        };
    };
};
