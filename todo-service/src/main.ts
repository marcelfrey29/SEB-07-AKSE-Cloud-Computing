import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';
import { UserValidationInterceptor } from './common/uservalidation.interceptor';
import { UserErrorFilter } from './errors/usererror.filter';

async function bootstrap() {
    const app = await NestFactory.create(AppModule, {
        cors: true,
    });
    app.useGlobalFilters(new UserErrorFilter());
    app.useGlobalInterceptors(new UserValidationInterceptor());
    const configService: ConfigService = app.get(ConfigService);
    await app.listen(configService.get<string>('SERVER_PORT') ?? 4000);
}

bootstrap();
