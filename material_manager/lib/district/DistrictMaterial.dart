class DistrictMaterial {
  int id;
  int materialCode;
  String materialName;
  int categoryCode;
  int workingStatus;
  String color;
  String manufacturer;
  String purchaseDate;
  int purchasePrice;
  int supplierCode;
  int currentValue;
  String maintenanceId;
  int totalExpense;
  String depreciationRate;
  String lastDepeciation;
  int issuedTo;
  String issued;
  String issueDate;

  DistrictMaterial(
      {this.id,
      this.materialCode,
      this.materialName,
      this.categoryCode,
      this.workingStatus,
      this.color,
      this.manufacturer,
      this.purchaseDate,
      this.purchasePrice,
      this.supplierCode,
      this.currentValue,
      this.depreciationRate,
      this.issueDate,
      this.issued,
      this.issuedTo,
      this.lastDepeciation,
      this.maintenanceId,
      this.totalExpense});
  factory DistrictMaterial.fromJson(Map<String, dynamic> json) {
    return DistrictMaterial(
      id: json['Id'] as int,
      materialCode: json['MaterialCode'] as int,
      materialName: json['MaterialName'] as String,
      categoryCode: json['CategoryCode'] as int,
      workingStatus: json['WorkingStatus'] as int,
      color: json['Color'] as String,
      manufacturer: json['Manufacturer'] as String,
      purchaseDate: json['PurchaseDate'] as String,
      purchasePrice: json['PurchasePrice'] as int,
      supplierCode: json['SupplierCode'] as int,
      currentValue: json['CurrentValue'] as int,
      depreciationRate: json['DepreciationRate'] as String,
      issueDate: json['IssueDate'] as String,
      issued: json['Issued'] as String,
      issuedTo: json['IssuedTo'] as int,
      lastDepeciation: json['LastDepeciation'] as String,
      maintenanceId: json['MaintenanceId'] as String,
      totalExpense: json['TotalExpense'] as int,
    );
  }
}
