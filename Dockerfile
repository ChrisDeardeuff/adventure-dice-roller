# Use latest stable channel SDK.
FROM dart:latest AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . /app
RUN dart pub get --offline

RUN dart run nyxx_commands:compile bin/server.dart -o bot.dart

CMD ["dart", "bot.dart"]
