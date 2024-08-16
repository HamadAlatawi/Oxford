import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Error "mo:base/Error";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Cycles "mo:base/ExperimentalCycles";
import Text "mo:base/Text";

import HttpTypes "../commons/HttpTypes";
import JSON "../commons/json/JSON";
import Types "../commons/Types";

actor class HttpOutcalls() {

    public type Rate = { currency : Text; rate : Text };

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

    public query func transform(raw : HttpTypes.TransformArgs) : async HttpTypes.CanisterHttpResponsePayload {
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
        let ic : HttpTypes.IC = actor ("aaaaa-aa");

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
        let transform_context : HttpTypes.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        // 2.3 The HTTP request
        let http_request : HttpTypes.HttpRequestArgs = {
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
        let http_response : HttpTypes.HttpResponsePayload = await ic.http_request(http_request);

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
};
