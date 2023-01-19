# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build

WORKDIR /app

# Copy Dependencies
COPY packages/in_memory_todos_data_source ./packages/in_memory_todos_data_source
COPY packages/todos_data_source ./packages/todos_data_source

# Install Dependencies
RUN dart pub get -C packages/in_memory_todos_data_source
RUN dart pub get -C packages/todos_data_source

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/


# Start server.
CMD ["/app/bin/server"]