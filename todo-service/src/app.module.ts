import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import {
    AuthGuard,
    KeycloakConnectModule,
    TokenValidation,
} from 'nest-keycloak-connect';
import { APP_GUARD } from '@nestjs/core';
import { ListModule } from './list/list.module';
import { DynamodbModule } from './dynamodb/dynamodb.module';
import { TodosModule } from './todos/todos.module';

@Module({
    imports: [
        ConfigModule.forRoot({ isGlobal: true }),
        KeycloakConnectModule.registerAsync({
            inject: [ConfigService],
            useFactory: async (configService: ConfigService) => ({
                // For local development, we use the OFFLINE validation method which requires the "realmPublicKey" field to be set.
                // This is done because we can't reach keycloak in that way, that the ISS matches.
                //
                // Keycloak says that the token is invalid because it is created at the frontend (e.g. http://localhost:3000 [Outside the Docker Network]),
                // but used for API calls to the Backend, which then calls Keycloak from its hostname (e.g http://keycloak).
                // Because http://localhost:3000 !== http://keycloak Keycloak throws an error (ISS Mismatch)
                //
                // When we know that the frontend is located at http://localhost:3000, we can tell the Backend that http://localhost:3000 is the address that should be in the token.
                // When we do, there is no more ISS Mismatch, because http://localhost:3000 === http://localhost:3000
                // BUT, There is another error: The Backend can't reach keycloak at http://localhost:3000 (because it's inside the Backend Container...) to load the Realm Public Key.
                //
                // So, we can pass the Public Key to the Backend and tell it to validate to token offline, without reaching out to Keycloak.
                // When we do, we are authenticated successfully!
                tokenValidation:
                    configService.get<string>('SERVER_ENVIRONMENT_SETTING') ===
                    'DEVELOPMENT'
                        ? TokenValidation.OFFLINE
                        : TokenValidation.ONLINE,

                // Example Auth-Server-URL: http://example.com/auth (the "/auth" is important!)
                authServerUrl:
                    configService.get<string>('KEYCLOAK_URL') ??
                    'NO_KEYCLOAK_URL_PROVIDED',
                realmPublicKey:
                    configService.get<string>('KEYCLOAK_REALM_PUBLIC_KEY') ??
                    'NO_REALM_PUBLIC_KEY_PROVIDED',

                // Configure the Realm
                realm:
                    configService.get<string>('KEYCLOAK_REALM') ??
                    'NO_REALM_PROVIDED',
                clientId:
                    configService.get<string>('KEYCLOAK_CLIENT_ID') ??
                    'NO_CLIENT_ID_PROVIDED',
                secret:
                    configService.get<string>('KEYCLOAK_CLIENT_SECRET') ??
                    'NO_CLIENT_SECRET_PROVIDED',

                // Configure the Nest-Keycloak-Connect-Dependency
                useNestLogger: true,
            }),
        }),
        ListModule,
        DynamodbModule,
        TodosModule,
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
