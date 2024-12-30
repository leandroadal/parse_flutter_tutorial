# Tutorial de Integração com Parse Server em Flutter

[Read in English](README_en.md)

Este projeto utiliza a biblioteca `parse_server_sdk_flutter` para interagir com o Parse Server em um aplicativo Flutter, facilitando a comunicação com a API do Parse. A principal função do código é realizar operações CRUD (Criar, Ler, Atualizar, Deletar) em objetos Parse dentro de um ambiente Flutter.

---

## Dependências

1. **flutter_dotenv**: Utilizado para carregar variáveis de ambiente de um arquivo `.env`.
2. **parse_server_sdk_flutter**: Biblioteca responsável por interagir com o Parse Server.

### Instalação das Dependências

Em um terminal dentro da pasta do projeto execute:

```bash
flutter pub add parse_server_sdk_flutter
```

```bash
flutter pub add flutter_dotenv
```

## Configuração do Parse Server

A função initializeParse realiza a inicialização do SDK do Parse, configurando o `appId`, `clientKey`, e o `endereço da API do Parse`. As credenciais devem ser carregadas do arquivo `.env` utilizando o `dotenv`:

```dart
Future<Parse> initializeParse() async {
  String appId = dotenv.env['PARSE_APP_ID_XLO'] ?? 'defaultAppId';
  String clientKey = dotenv.env['PARSE_CLIENT_KEY_XLO'] ?? 'defaultClientKey';

  return await Parse().initialize(
    appId,
    'https://parseapi.back4app.com/',
    clientKey: clientKey,
    autoSendSessionId: true,
    debug: true,
  );
}
```

## Funções do Parse

### Criar registro

Cria um novo registro no Parse.

```dart
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
```

Exemplo de uso:

```dart
await createData(
  table: 'Categories',
  column: 'Title',
  data: 'Blusas de frio',
  column1: 'Position',
  data1: 3,
);
```

### Atualizar registro

Atualiza um registro existente no Parse.

```dart
Future<ParseResponse> updateData() async {
  final category = ParseObject('Categories')
    ..objectId = 'BJSgu61clb'
    ..set<int>('Position', 3);

  final response = await category.save();
  print(response.success);
  return response;
}
```

### Apagar um registro

Apaga um registro específico do Parse.

```dart
Future<ParseResponse> deleteData() async {
  final category = ParseObject('Categories')..objectId = 'BJSgu61clb';

  final response = await category.delete();
  print(response.success);
  return response;
}
```

### Recuperar um registro pelo ID

Recupera um registro específico pelo objectId.

```dart
Future<void> getDataById() async {
  final response = await ParseObject('Categories').getObject('oBranFpS8M');
  if (response.success) {
    print(response.result);
  }
}
```

### Recuperar todos os registros de uma tabela

Recupera todos os registros da tabela Categories.

```dart
Future<void> getAllData() async {
  final response = await ParseObject('Categories').getAll();
  if (response.success) {
    for (var element in response.result) {
      print(element);
    }
  }
}
```

### Filtros de busca

#### equalsTo (Query Builder)

Filtra registros onde o campo Position tem o valor 2.

```dart
Future<ParseResponse> equalsTo(QueryBuilder<ParseObject> query) async {
  query.whereEqualTo('Position', 2);

  final response = await query.query();
  if (response.success) {
    print(response.result);
  }
  return response;
}
```

#### whereContains (Query Builder)

Filtra registros onde o campo Title contém a substring "Blusas".

```dart
Future<void> whereContains(QueryBuilder<ParseObject> query) async {
  query.whereContains('Title', 'Blusas');

  final response = await query.query();
  if (response.success) {
    print(response.result);
  }
}
```
