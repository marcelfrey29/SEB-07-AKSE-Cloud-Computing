import { UserError } from './usererror.error';

describe('UserError', () => {
    it('should be defined', () => {
        expect(new UserError('')).toBeDefined();
    });
});
