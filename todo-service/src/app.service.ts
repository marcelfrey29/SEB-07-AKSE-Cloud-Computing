import { Injectable } from '@nestjs/common';

/**
 *
 */
@Injectable()
export class AppService {
    getInfo(): string {
        return 'Todo-Backend-Service: OK';
    }
}
