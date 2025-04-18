import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ToolCostDetailModel.dart';
import '../Model/ToolCostModel.dart';

class ApiService {

  final String baseUrl = "http://F2PC24017:8080/api";
  // final String baseUrl = "http://192.168.122.15:9091/api";


  Future<List<ToolCostModel>> fetchToolCosts(String month) async {
    final url = Uri.parse("$baseUrl/tool-cost?month=$month");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Lọc dữ liệu để loại bỏ các phần tử có act == null hoặc tgt_WholeM == 0
        final filteredData = data.where((item) {
          return item['act'] != null && item['tgt_WholeM'] != 0.0;
        }).toList();

        return parseToolCostList(filteredData);  // Chuyển đổi dữ liệu từ JSON thành danh sách ToolCostModel
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  Future<List<ToolCostDetailModel>> fetchToolCostsDetail(String month,String deptInput) async {
    final url = Uri.parse("$baseUrl/tool-cost-detail?month=$month&dept=$deptInput");
    print("Url: $url");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return parseToolCostDetailList(data);  // Chuyển đổi dữ liệu từ JSON thành danh sách ToolCostModel
      } else {
        print("Error: ${response.statusCode}");
        return [];
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
