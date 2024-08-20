import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface CanisterHttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface HttpHeader { 'value' : string, 'name' : string }
export interface HttpOutcalls {
  'getConfirmationDetails' : ActorMethod<[string], Array<Rate>>,
  'transform' : ActorMethod<[TransformArgs], CanisterHttpResponsePayload>,
}
export interface HttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface Rate { 'rate' : string, 'currency' : string }
export interface TransformArgs {
  'context' : Uint8Array | number[],
  'response' : HttpResponsePayload,
}
export interface _SERVICE extends HttpOutcalls {}
