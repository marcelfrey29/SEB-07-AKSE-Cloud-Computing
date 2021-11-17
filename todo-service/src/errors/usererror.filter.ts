import {
    ArgumentsHost,
    Catch,
    ExceptionFilter,
    HttpStatus,
} from '@nestjs/common';
import { UserError } from './usererror.error';
import { Request, Response } from 'express';

/**
 * The UserErrorFilter is responsible for catching and handling {@link UserError}s.
 */
@Catch(UserError)
export class UserErrorFilter implements ExceptionFilter {
    catch(exception: UserError, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const request = ctx.getRequest<Request>();
        const status = HttpStatus.BAD_REQUEST;

        response.status(status).json({
            statusCode: status,
            timestamp: new Date().toISOString(),
            path: request.url,
            message: exception.message,
        });
    }
}
