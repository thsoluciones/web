class Expedient {
  String id;
  String name;
  String lastname;
  String direction;
  String dateBirthday;

  //if is
  bool isAChild;
  String fatherName;
  String motherName;
  String tutorName;
  String school;

  Map<String, dynamic> child;

  String work;
  String email;
  List<dynamic> cellphones;

  String whyVisiting;
  String badFor;
  String medicalLastArchive; //clinic
  String odontologyLastArchive; //odontologic clinic
  String lastClinicVisiting;
  String others;

  String clinic;
  List<dynamic> history;

  Expedient(
      {this.id,
      this.name,
      this.lastname,
      this.direction,
      this.dateBirthday,
      this.work,
      this.email,
      this.history,
      this.cellphones,
      this.whyVisiting,
      this.badFor,
      this.medicalLastArchive, //clinic
      this.odontologyLastArchive,
      this.child,
      this.lastClinicVisiting,
      this.clinic,
      this.isAChild});

  factory Expedient.fromJsonResponse(Map<String, dynamic> response) {
    return Expedient(
        id: response['_id'],
        name: response['name'],
        lastname: response['lastname'],
        direction: response['direction'],
        dateBirthday: response['birthday'],
        work: response['workplace'],
        email: response['email'],
        history: response['history'],
        isAChild: response['isAChild'],
        cellphones: response['cellphones'],
        whyVisiting: response['reasonforvisit'],
        badFor: response['alergicTo'],
        medicalLastArchive: response['medicalhistory'],
        odontologyLastArchive: response['dentalhistory'],
        child: response['child'],
        lastClinicVisiting: response['visitingclinic'],
        clinic: response['clinic']);
  }

  Map<String, dynamic> form() {
    return {
      'name': this.name,
      'lastname': this.lastname,
      'direction': this.direction,
      'birthday': this.dateBirthday,
      'isAChild': this.isAChild,
      'child': this.child,
      'workplace': this.work,
      'email': this.email,
      'cellPhones': [],
      'reasonforvisit': this.whyVisiting,
      'alergicTo': this.badFor,
      'medicalhistory': this.medicalLastArchive, //clinic
      'dentalhistory': this.odontologyLastArchive,
      'visitingclinic': this.lastClinicVisiting,
      'other': this.others,
      'clinic': this.clinic
    };
  }

  Map<String, dynamic> normalForm() {
    return {
      'name': this.name,
      'direction': this.direction,
      'date_birthday': this.dateBirthday,
      'child': this.child,
      'isAChild': this.isAChild,
      'work': this.work,
      'email': this.email,
      'cell_phones': this.cellphones,
      'why_visiting': this.whyVisiting,
      'bad_for': this.badFor,
      'medical_last_archive': this.medicalLastArchive, //clinic
      'odontology_last_archive': this.odontologyLastArchive
    };
  }
}
