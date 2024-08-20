import { createActor as Backend } from "../../../../declarations/backend/";
import { createActor as HttpOutcall } from "../../../../declarations/httpOutcalls"
import { createActor as fileUpload } from "../../../../declarations/fileUpload";

const canisterIdBackEnd = import.meta.env.VITE_BACKEND_CANISTER_ID;
console.log(import.meta.env)
const canisterIdFileUpload = import.meta.env.VITE_FILEUPLOAD_CANISTER_ID;
const canisterHttpOutcall = import.meta.env.VITE_HTTPOUTCALLS_CANISTER_ID;
let host;
// if(process.env.DFX_NETWORK === "playground"){
//     host = "https://raw.icp0.io"
// }else{
//     host = import.meta.env.VITE_HOST
// };

host = import.meta.env.VITE_HOST

console.log(process.env.DFX_NETWORK)
console.log(host)   
const actorBackend = Backend("6xhyy-ryaaa-aaaab-qacqa-cai", { agentOptions: { host } });
const actorFileUpload = fileUpload("6mce5-laaaa-aaaab-qacsq-cai", { agentOptions: { host } });
const httpOutcalls = HttpOutcall("7pon3-7yaaa-aaaab-qacua-cai", { agentOptions: { host } });

export { actorBackend, actorFileUpload, httpOutcalls }