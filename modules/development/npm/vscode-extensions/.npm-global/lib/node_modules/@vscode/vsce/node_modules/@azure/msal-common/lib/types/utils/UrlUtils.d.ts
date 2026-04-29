import { AuthorizeResponse } from "../response/AuthorizeResponse.js";
import { StringDict } from "./MsalTypes.js";
/**
 * Parses hash string from given string. Returns empty string if no hash symbol is found.
 * @param hashString
 */
export declare function stripLeadingHashOrQuery(responseString: string): string;
/**
 * Returns URL hash as server auth code response object.
 */
export declare function getDeserializedResponse(responseString: string): AuthorizeResponse | null;
/**
 * Utility to create a URL from the params map
 */
export declare function mapToQueryString(parameters: Map<string, string>, encodeExtraParams?: boolean, extraQueryParameters?: StringDict): string;
//# sourceMappingURL=UrlUtils.d.ts.map