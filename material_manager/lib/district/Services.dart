import 'dart:convert';
import 'package:http/http.dart' as http;
import 'District.dart';
import 'DistrictMaterial.dart';

class Services {
  static const ROOT = 'http://192.168.1.11/requirement/requestdistrictmaterial';
  static const ROOT2 = 'http://192.168.1.11/requirement/getdistrictmaterial';
  static const ROOT3 = 'http://192.168.1.11/requirement/updatedistrictmaterial';
  //static const ROOT3 = 'http://192.168.1.11/auth/login';

  // static Future<String> createDistrictMaterials(
  //     int id,
  //     String deptCode,
  //     String materialCode,
  //     String materialName,
  //     String quantity,
  //     String remarks,
  //     String status) async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['id'] = id;
  //     map['deptcode'] = deptCode;
  //     map['materialcode'] = materialCode;
  //     map['materialname'] = materialName;
  //     map['quantity'] = quantity;
  //     map['status'] = status;
  //     map['remarks'] = remarks;
  //     final response = await http.post(ROOT, body: map);
  //     print('createDistrictMaterials Response: ${response.body}');
  //     if (200 == response.statusCode) {
  //       return response.body;
  //     } else {
  //       return "error";
  //     }
  //   } catch (e) {
  //     return "error";
  //   }
  // }

  static Future<List<DistrictMaterial>> getDistrictMaterials(String departmentcode) async {
    try {
      var map = Map<String, dynamic>();
      map['DeptCode'] = departmentcode;
      final response = await http.post(ROOT2, body: map);
      //print(parseResponse1(response.body));
      //print(response.body);
      //print(response.statusCode);
      //print('getDistrictMaterials: ${response.body}');
      if(response == null) {
          return List<DistrictMaterial>();
        }
      if (200 == response.statusCode) {
        List<DistrictMaterial> list = parseResponse1(response.body);
        if(list == null) {
          return List<DistrictMaterial>();
        } 
        return list;
      } else {
        return List<DistrictMaterial>();
      }
    } catch (e) {
      return List<DistrictMaterial>();
    }
  }

  // static List<District> parseResponse(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed.map<District>((json) => District.fromJson(json)).toList();
  // }

  static List<DistrictMaterial> parseResponse1(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<DistrictMaterial>((json) => DistrictMaterial.fromJson(json))
        .toList();
  }

  static Future<String> updateDistrictMaterials(
      String id,
      String workingStatus,
      String issuedTo) async {
    try {
      var map = Map<String, dynamic>();
      map['Id'] = id;
      map['WorkingStatus'] = workingStatus;
      map['IssuedTo'] = issuedTo;
      final response = await http.post(ROOT3, body: map);
      print('updateDistrictMaterials Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> requestDistrictMaterials(String deptCode, String materialCode,
      String materialName, String quantity, String remarks //String status
      ) async {
    try {

      var map = Map<String, dynamic>();
      map['DeptCode'] = deptCode;
      map['MaterialCode'] = materialCode;
      map['MaterialName'] = materialName;
      map['Quantity'] = quantity;
      //map['Status'] = status;
      map['Remarks'] = remarks;
      print(map);
      final response = await http.post(ROOT, body: map);
      //print('requestDistrictMaterials Response: ${response.body}');
      //print(response);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //   static Future<String> userLogin(
  //     String username,
  //     String password,) async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['username'] = username;
  //     map['password'] = password;
  //     final response = await http.post(ROOT, body: map);
  //     print('logIn Response: ${response.body}');
  //     if (200 == response.statusCode) {
  //       return response.body;
  //     } else {
  //       return "error";
  //     }
  //   } catch (e) {
  //     return "error";
  //   }
  // }


}
