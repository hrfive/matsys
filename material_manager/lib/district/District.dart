class District {
  int id;
  int deptCode;
  int materialCode;
  String materialName;
  int quantity;
  String status;
  String remarks;

  District(
      {this.id,
      this.deptCode,
      this.materialCode,
      this.materialName,
      this.quantity,
      this.remarks,
      this.status});
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['Id'] as int,
      deptCode: json['DeptCode'] as int,
      materialCode: json['MaterialCode'] as int,
      materialName: json['MaterialName'] as String,
      quantity: json['Quantity'] as int,
      status: json['Status'] as String,
      remarks: json['Remarks'] as String,
    );
  }
}
