/**
 * LoggedInUser represents the user object from keycloak.
 */
export default interface LoggedInUser {
    sub: string
    // eslint-disable-next-line camelcase
    email_verified: boolean
    name: string
    // eslint-disable-next-line camelcase
    preferred_username: string
    // eslint-disable-next-line camelcase
    given_name: string
    // eslint-disable-next-line camelcase
    family_name: string
    email: string
}
