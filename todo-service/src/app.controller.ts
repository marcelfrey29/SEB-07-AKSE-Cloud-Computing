import { Controller, Get, Req } from '@nestjs/common';
import { AppService } from './app.service';
import { Public } from 'nest-keycloak-connect';

@Controller()
export class AppController {
    constructor(private readonly appService: AppService) {}

    @Get('pub')
    @Public()
    getPublic(): string {
        return this.appService.getHello();
    }

    @Get('priv')
    getPrivate(@Req() request: AuthorizedRequest): string {
        return 'Your name: ' + request.user.name;
    }
}
