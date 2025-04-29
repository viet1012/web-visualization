import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/DetailsDataModel.dart';
import '../Model/ToolCostDetailModel.dart';
import '../Model/ToolCostModel.dart';
import '../Model/ToolCostSubDetailModel.dart';

class ApiService {
  // final String baseUrl = "http://F2PC24017:8080/api";
  final String baseUrl = "http://192.168.122.15:9091/api";

  Future<ToolCostModel?> fetchToolCostsByDept(String month, String dept) async {
    final url = Uri.parse("$baseUrl/tool-cost/by-dept?month=$month&dept=$dept");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Kiểm tra nếu act null hoặc tgt_WholeM == 0 => return null
        if (jsonData['act'] == null || jsonData['tgt_WholeM'] == 0.0) {
          return null;
        }

        return ToolCostModel.fromJson(jsonData); // Trả về 1 item duy nhất
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception caught: $e");
      return null;
    }
  }

  Future<List<ToolCostModel>> fetchToolCosts(String month) async {
    final url = Uri.parse("$baseUrl/tool-cost?month=$month");
    print("Url: $url");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Lọc dữ liệu để loại bỏ các phần tử có act == null hoặc tgt_WholeM == 0
        final filteredData =
            data.where((item) {
              return item['act'] != null && item['tgt_WholeM'] != 0.0;
            }).toList();

        return parseToolCostList(
          filteredData,
        ); // Chuyển đổi dữ liệu từ JSON thành danh sách ToolCostModel
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<List<ToolCostDetailModel>> fetchToolCostsDetail(
    String month,
    String deptInput,
  ) async {
    final url = Uri.parse(
      "$baseUrl/tool-cost-detail?month=$month&dept=$deptInput",
    );
    print("Url: $url");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return parseToolCostDetailList(
          data,
        ); // Chuyển đổi dữ liệu từ JSON thành danh sách ToolCostModel
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<List<DetailsDataModel>> fetchDetailsData(
    String month,
    String deptInput,
  ) async {
    final url = Uri.parse("$baseUrl/details-data?month=$month&dept=$deptInput");
    print("url: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DetailsDataModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<List<DetailsDataModel>> fetchSubDetailsData(
    String month,
    String deptInput,
    String group,
  ) async {
    final encodedGroup = Uri.encodeComponent(group); // 👈 Encode group

    final url = Uri.parse(
      "$baseUrl/sub-details-data?month=$month&dept=$deptInput&group=$encodedGroup",
    );
    print("url: $url");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DetailsDataModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<List<ToolCostSubDetailModel>> fetchToolCostsSubDetail(
    String month,
    String deptInput,
    String group,
  ) async {
    final encodedGroup = Uri.encodeComponent(group); // 👈 Encode group
    final url = Uri.parse(
      "$baseUrl/tool-cost-sub-detail?month=$month&dept=$deptInput&group=$encodedGroup",
    );

    print("url: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => ToolCostSubDetailModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<List<DetailsDataModel>> fetchToolCostsSubSubDetail(
    String month,
    String deptInput,
    String group,
  ) async {
    final encodedGroup = Uri.encodeComponent(group); // 👈 Encode group

    final url = Uri.parse(
      "$baseUrl/sub-sub-details-data?month=$month&dept=$deptInput&group=$encodedGroup",
    );
    print("url: $url");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DetailsDataModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  // Chuyển đổi JSON thành danh sách ToolCostModel
  List<ToolCostModel> parseToolCostList(List<dynamic> data) {
    return data.map((json) => ToolCostModel.fromJson(json)).toList();
  }

  List<ToolCostDetailModel> parseToolCostDetailList(List<dynamic> data) {
    return data.map((json) => ToolCostDetailModel.fromJson(json)).toList();
  }
}
