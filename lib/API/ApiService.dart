import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ToolCostModel.dart';

class ApiService {

  final String baseUrl = "http://localhost:8080/api";

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

        // Sắp xếp theo thứ tự ưu tiên mong muốn (Press, Mold, Guide, MA, PE)
        final sortedData = _sortData(filteredData);

        return parseToolCostList(sortedData);  // Chuyển đổi dữ liệu từ JSON thành danh sách ToolCostModel
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception caught: $e");
      return [];
    }
  }

  // Sắp xếp dữ liệu theo thứ tự mong muốn
  List<dynamic> _sortData(List<dynamic> data) {
    // Thứ tự ưu tiên
    List<String> order = ['PRESS', 'MOLD', 'GUIDE', 'MA', 'PE', 'MTC', 'COMMON'];

    // Sắp xếp lại theo thứ tự order
    data.sort((a, b) {
      int aIndex = order.indexOf(a['dept']);
      int bIndex = order.indexOf(b['dept']);
      return aIndex.compareTo(bIndex);
    });

    return data;
  }

  // Chuyển đổi JSON thành danh sách ToolCostModel
  List<ToolCostModel> parseToolCostList(List<dynamic> data) {
    return data.map((json) => ToolCostModel.fromJson(json)).toList();
  }
}
