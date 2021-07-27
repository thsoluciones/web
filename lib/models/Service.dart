class Service {
  String id;
  String code;
  String typeOfService;
  String typeOfTreatment;
  String price;
  String clinic;

  Service(
      {this.id,
      this.code,
      this.typeOfService,
      this.typeOfTreatment,
      this.price,
      this.clinic});

  factory Service.fromJsonResponse(Map<String, dynamic> response) {
    return Service(
        id: response['_id'],
        code: response['code'],
        typeOfService: response['typeofservice'],
        typeOfTreatment: response['typeoftreatment'],
        price: response['price'],
        clinic: response['clinic']);
  }
}
