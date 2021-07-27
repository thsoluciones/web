class Clinic {
  String id;
  String name;
  String direction;
  String enterprise;

  Clinic({this.id, this.name, this.direction, this.enterprise});

  factory Clinic.fromJsonResponse(Map<String, dynamic> response) {
    return Clinic(
        id: response['_id'],
        name: response['name'],
        direction: response['direction'],
        enterprise: response['enterprise']);
  }
}
