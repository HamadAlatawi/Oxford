import { createActor } from "../../../../declarations/backend";
import { createActor as fileUpload } from "../../../../declarations/fileUpload";

const canisterIdBackEnd = import.meta.env.VITE_BACKEND_CANISTER_ID;
const canisterIdFileUpload = import.meta.env.VITE_FILEUPLOAD_CANISTER_ID;
const host = import.meta.env.VITE_HOST;
const actorBackend = createActor(canisterIdBackEnd, { agentOptions: { host } });
const actorFileUpload = fileUpload(canisterIdFileUpload, { agentOptions: { host } });

export { actorBackend, actorFileUpload }