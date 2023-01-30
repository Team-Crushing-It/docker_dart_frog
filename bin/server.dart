// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/todos/index.dart' as todos_index;
import '../routes/todos/[id].dart' as todos_$id;

import '../routes/_middleware.dart' as middleware;

void main() => createServer();

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, ip, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/todos', (RequestContext context) => buildTodosHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildTodosHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (RequestContext context) => todos_index.onRequest(context,))..all('/<id>', (RequestContext context, String id,) => todos_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}
