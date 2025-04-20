
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
  final String type; // 'adult', 'child', 'infant'
  String? _idNumber;
  String? _documentType;
  String? _documentNumber;

  Passenger({
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    String? idNumber,
    required this.type,
    String? documentType,
    String? documentNumber,
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

  @override
  String toString() {
    return 'Passenger: $firstName $lastName, gender=$gender, type=$type, documentType=$_documentType, idNumber=${_maskId(_idNumber)}';
  }
}