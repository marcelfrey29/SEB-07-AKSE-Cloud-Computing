/**
 * A UserError is thrown if there is an error related to the user.
 */
export class UserError extends Error {
    constructor(readonly message: string) {
        super();
    }
}
