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
    return 'ContactInfo: phone=${_phoneNumber}, email=${_email}';
  }
}

class Passenger {
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  String? idType;
  final String? type; // 'adult', 'child', 'infant'

  String? _idNumber;
  String? _documentType; // Added for document type
  String? _documentNumber; // Added for document number

  Passenger({
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.idType,
    String? idNumber,
    this.type,
    String? documentType,
    String? documentNumber,
  })  : _idNumber = idNumber,
        _documentType = documentType,
        _documentNumber = documentNumber;

  String? get idNumber => _idNumber;
  set idNumber(String? value) => _idNumber = value;

  String? get documentType => _documentType; // Getter for documentType
  set documentType(String? value) => _documentType = value; // Setter for documentType

  String? get documentNumber => _documentNumber; // Getter for documentNumber
  set documentNumber(String? value) => _documentNumber = value; // Setter for documentNumber

  // Mask the ID number, showing only the last 4 digits
  String _maskId(String? id) {
    if (id == null || id.length < 4) return '***';
    return '***${id.substring(id.length - 4)}';
  }

  // If dateOfBirth is a string, parse it into a DateTime object
  set setDateOfBirth(String? dob) {
    if (dob != null) {
      dateOfBirth = DateTime.tryParse(dob); // Convert string to DateTime
    }
  }

  @override
  String toString() {
    return 'Passenger: $firstName $lastName, gender=$gender, type=$type, documentType=$_documentType, idNumber=${_maskId(_idNumber)}';
  }
}