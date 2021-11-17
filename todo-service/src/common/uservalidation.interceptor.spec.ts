import { UserValidationInterceptor } from './uservalidation.interceptor';

describe('UserValidationInterceptor', () => {
    it('should be defined', () => {
        expect(new UserValidationInterceptor()).toBeDefined();
    });
});
