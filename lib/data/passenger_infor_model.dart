class ContactInfo {
  String? _phoneNumber;
  String? _email;

  ContactInfo({String? phoneNumber, String? email})
      : _phoneNumber = phoneNumber,
        _email = email;

  String? get phoneNumber => _phoneNumber;
  set phoneNumber(String? value) => _phoneNumber = value;

  String? get email => _email;
  set email(String? value) => _email = value;

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': _phoneNumber,
      'email': _email,
    };
  }

  @override
  String toString() {
    return 'ContactInfo: phone=$_phoneNumber, email=$_email';
  }
}

class Passenger {
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  final String type;
  String? _idNumber;
  String? _documentType;
  String? _documentNumber;
  ContactInfo? contactInfo;

  Passenger({
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    String? idNumber,
    required this.type,
    String? documentType,
    String? documentNumber,
    this.contactInfo,
  })  : _idNumber = idNumber,
        _documentType = documentType ?? 'ID Card',
        _documentNumber = documentNumber;

  String? get idNumber => _idNumber;
  set idNumber(String? value) => _idNumber = value;

  String? get documentType => _documentType;
  set documentType(String? value) => _documentType = value;

  String? get documentNumber => _documentNumber;
  set documentNumber(String? value) => _documentNumber = value;

  String _maskId(String? id) {
    if (id == null || id.length < 4) return '***';
    return '***${id.substring(id.length - 4)}';
  }

  set setDateOfBirth(String? dob) {
    if (dob != null) {
      dateOfBirth = DateTime.tryParse(dob);
    }
  }

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      type: json['type'] as String,
      idNumber: json['idNumber'] as String?,
      documentType: json['documentType'] as String?,
      documentNumber: json['documentNumber'] as String?,
      contactInfo: json['contactInfo'] != null
          ? ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'type': type,
      'idNumber': _idNumber,
      'documentType': _documentType,
      'documentNumber': _documentNumber,
      'contactInfo': contactInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Passenger: $firstName $lastName, gender=$gender, type=$type, documentType=$_documentType, idNumber=${_maskId(_idNumber)}, contact=$contactInfo';
  }
}