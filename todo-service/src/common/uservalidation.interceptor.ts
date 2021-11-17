import {
    CallHandler,
    ExecutionContext,
    Injectable,
    Logger,
    NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { UserError } from '../errors/usererror.error';

/**
 * This Interceptor ensures that the request object contains the user property.
 *
 * If the property does not exist, no user information can be extracted.
 * In this case, an {@link UserError} is throw.
 */
@Injectable()
export class UserValidationInterceptor implements NestInterceptor {
    private readonly logger = new Logger(UserValidationInterceptor.name);

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const value = context.switchToHttp().getRequest();
        if (!(value as AuthorizedRequest).user) {
            this.logger.warn(
                'The request does not contain a user object. This might be related authentication.',
            );
            throw new UserError('Missing user object in the request.');
        }
        return next.handle();
    }
}
