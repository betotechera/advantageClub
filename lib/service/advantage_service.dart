
import 'package:advantage_club/model/Result.dart';
import 'package:advantage_club/model/advantage.dart';
import 'package:requests/requests.dart';

import '../config.dart';

class AdvantageService {
  Future createEntry(id) async {
    var response = await Requests.post(
        "${Config.api}/advantages/$id/entries",
        body: { 'source': 'APP' });
        print(response.json());
    response.raiseForStatus();
  }

  Future<Result<Advantage>> advantages(
      {String page: '1',
      searchContent,
      categorySlugName,
      Iterable<String> marketingType: const [],
      Iterable<String> subcategorySlugName: const []}) async {
    final Map<String, dynamic> queryParameters = {"page": page};
    if (categorySlugName != null) {
      queryParameters['categorySlugName'] = categorySlugName;
    }
    if (marketingType.isNotEmpty) {
      queryParameters['marketingType'] = marketingType;
    }
    if (subcategorySlugName.isNotEmpty) {
      queryParameters['subcategorySlugName'] = subcategorySlugName;
    }
    if (searchContent != null) {
      queryParameters['searchContent'] = searchContent;
    }
    queryParameters['filtered'] = "true";
    Uri completeUri = createURI(queryParameters);
    var response = await Requests.get(
        "${Config.api}/advantages",
        queryParameters: completeUri.queryParameters);
    response.raiseForStatus();
    final parsed = response.json();
    final result = Result<Advantage>(
        parsed['items']
            .map<Advantage>((json) => Advantage.fromJson(json))
            .toList(),
        parsed['total']);
    result.setHasNext(parsed['links']);
    return result;
  }

  Uri createURI(Map<String, dynamic> queryParameters) {
    var modelUri = Uri.https('', '');
    final completemodelUri = Uri(
        scheme: modelUri.scheme,
        userInfo: modelUri.userInfo,
        host: modelUri.host,
        port: modelUri.port,
        path: modelUri.path,
        queryParameters: queryParameters);
    return completemodelUri;
  }
}
