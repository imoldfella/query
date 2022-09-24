import 'writer.dart';
import 'package:address/address.dart';

class Name {
  String first, last;
  Name({required this.first, required this.last});
}

// wrapper around
class Provider {
  int get npi => 0;
  String get taxonomy {
    return "";
  }

  Address get address {
    return Address(country: '');
  }

  Provider fromNpiLine(List<dynamic> lst) {
    return Provider();
  }
}

void addProvider(Provider provider, Batch b) {
  // b we want to add the name and address
}
