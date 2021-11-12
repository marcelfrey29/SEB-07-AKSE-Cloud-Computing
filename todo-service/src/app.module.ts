import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthGuard, KeycloakConnectModule } from 'nest-keycloak-connect';
import { APP_GUARD } from '@nestjs/core';

@Module({
    imports: [
        ConfigModule.forRoot({ isGlobal: true }),
        KeycloakConnectModule.registerAsync({
            inject: [ConfigService],
            useFactory: async (configService: ConfigService) => ({
                authServerUrl:
                    configService.get<string>(
                        'KEYCLOAK_URL' ?? 'http://keycloak:8080',
                    ) + '/auth',
                realm: configService.get<string>('KEYCLOAK_REALM') ?? 'todoapp',
                clientId:
                    configService.get<string>('KEYCLOAK_CLIENT_ID') ??
                    'todoservice',
                secret:
                    configService.get<string>('KEYCLOAK_CLIENT_SECRET') ?? '',
                useNestLogger: true,
            }),
        }),
    ],
    controllers: [AppController],
    providers: [
        AppService,
        {
            provide: APP_GUARD,
            useClass: AuthGuard,
        },
    ],
})
export class AppModule {}
