/**
 *
 */
interface User {
    exp: number;
    iat: number;
    auth_time: number;
    jti: string;
    iss: string;
    aud: string;
    sub: string;
    typ: string;
    azp: string;
    session_state: string;
    acr: string;
    'allowed-origins': string[];
    realm_access: { roles: [] };
    resource_access: { account: [] };
    scope: string;
    sid: string;
    email_verified: boolean;
    name: string;
    preferred_username: string;
    given_name: string;
    family_name: string;
    email: string;
}

/**
 *
 */
type AuthorizedRequest = Request & { user: User };
