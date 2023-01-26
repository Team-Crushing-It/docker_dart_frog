// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../main.dart' as entrypoint;
import '../routes/todos/index.dart' as todos_index;
import '../routes/todos/[id].dart' as todos_$id;

import '../routes/_middleware.dart' as middleware;

void main() => hotReload(createServer);

Future<HttpServer> createServer() {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final handler = Cascade().add(buildRootHandler()).handler;
  return entrypoint.run(handler, ip, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/todos', (context) => buildTodosHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildTodosHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => todos_index.onRequest(context,))..all('/<id>', (context,id,) => todos_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}
