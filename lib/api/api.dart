import 'package:http/http.dart' as http;

Future getSyllableCount(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

Future getRhyme(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

Future getMetre(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

Future postForm(String url, String body) async {
  http.Response response = await http.post(
    Uri.parse(url),
    headers: {
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    },
    body: body,
  );
  return response.body;
}
