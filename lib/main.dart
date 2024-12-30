import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());

  await initializeParse();

  // ==== CRIAR ====
  //await createData();

  // ==== ATUALIZAr =====
  //await updateData();

  // ==== APAGAR ====
  //await deleteData();

  // ==== RECUPERAR INFORMAÇÃO ====
  //await getDataById();

  // ==== RECUPERAR TODAS AS INFORMAÇÕES ====
  //await getAllData();

  // ==== BUSCAR INFORMAÇÕES SEGUINDO OS PARÂMETROS ESPECIFICADOS
  final query = QueryBuilder(ParseObject('Categories'));

  // Procurar as linhas em que a coluna position tem o valor de 2
  //await equalsTo(query);
  /*
  await createData(
    table: 'Categories',
    column: 'Title',
    data: 'Blusas de frio',
    column1: 'Position',
    data1: 3,
  );

  await createData(
    table: 'Categories',
    column: 'Title',
    data: 'Tenho Blusas',
    column1: 'Position',
    data1: 4,
  );
  */
  // Que tenha a palavra blusa em algum lugar da string em Title
  //final query1 = QueryBuilder(ParseObject('Categories'));
  // a variável query precisa ser diferente não vai ter os filtros da função anterior
  //await whereContains(query1);

  // Juntando as duas
  await equalsTo(query);
  await whereContains(query);
}

Future<Parse> initializeParse() async {
  String appId = dotenv.env['PARSE_APP_ID_XLO'] ?? 'defaultAppId';
  String clientKey = dotenv.env['PARSE_CLIENT_KEY_XLO'] ?? 'defaultClientKey';

  return await Parse().initialize(
    // App Id
    appId,
    // Parse API Address
    'https://parseapi.back4app.com/',
    clientKey: clientKey,
    autoSendSessionId: true,
    debug: true,
  );
}

Future<ParseResponse> createData(
    {required String table,
    required String column,
    required dynamic data,
    required String column1,
    required dynamic data1}) async {
  final category = ParseObject(table)
    ..set(column, data)
    ..set(column1, data1);

  final response = await category.save();
  print(response.success);
  return response;
}

Future<ParseResponse> updateData() async {
  final category = ParseObject('Categories')
    ..objectId = 'BJSgu61clb'
    ..set<int>('Position', 3);

  final response = await category.save();
  print(response.success);
  return response;
}

Future<ParseResponse> deleteData() async {
  final category = ParseObject('Categories')..objectId = 'BJSgu61clb';

  final response = await category.delete();
  print(response.success);
  return response;
}

Future<void> getDataById() async {
  final response = await ParseObject('Categories').getObject('oBranFpS8M');
  if (response.success) {
    print(response.result);
  }
}

Future<void> getAllData() async {
  final response = await ParseObject('Categories').getAll();
  if (response.success) {
    for (var element in response.result) {
      print(element);
    }
  }
}

Future<ParseResponse> equalsTo(QueryBuilder<ParseObject> query) async {
  query.whereEqualTo('Position', 2);

  final response = await query.query();

  if (response.success) {
    print(response.result);
  }
  return response;
}

Future<void> whereContains(QueryBuilder<ParseObject> query) async {
  query.whereContains('Title', 'Blusas');

  final response = await query.query();
  if (response.success) {
    print(response.result);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
