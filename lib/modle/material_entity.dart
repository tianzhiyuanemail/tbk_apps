
class  Materialentity {
	String materialName;
	String typeName;
	int typeId;
	int id;
	int materialId;
	String remarks;

	Materialentity({this.materialName, this.typeName, this.typeId, this.id, this.materialId, this.remarks});

	Materialentity.fromJson(Map<String, dynamic> json) {
		materialName = json['materialName'];
		typeName = json['typeName'];
		typeId = json['typeId'];
		id = json['id'];
		materialId = json['materialId'];
		remarks = json['remarks'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['materialName'] = this.materialName;
		data['typeName'] = this.typeName;
		data['typeId'] = this.typeId;
		data['id'] = this.id;
		data['materialId'] = this.materialId;
		data['remarks'] = this.remarks;
		return data;
	}
}

