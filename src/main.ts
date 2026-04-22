import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { HttpExceptionFilter } from './exception-filters/http-exception-filter';
import { applyDocs } from './api-docs/apply-docs';
import AppConfig from './app.config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors();

  app.useGlobalPipes(new ValidationPipe());

  app.useGlobalFilters(new HttpExceptionFilter());

  applyDocs(app);

  const port = new AppConfig().build().metaData.port;

  await app.listen(port, '0.0.0.0', () => { // ← добавить '0.0.0.0'
    console.info(`The app is up and running on ${port} port`);
  });
}

bootstrap().then();