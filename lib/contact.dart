class Contact {
  final String title;
  final String firstName;
  final String lastName;
  final String street;
  final int number;
  final String city;
  final String state;
  final String country;
  final int postcode;
  final String email;
  final String phone;
  final String cell;
  final String immageUrl;

  Contact({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.number,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.email,
    required this.phone,
    required this.cell,
    required this.immageUrl,
  });

  static Contact get johnDoe => Contact(
    title: 'Mr.',
    firstName: 'John',
    lastName: 'Doe',
    street: 'Nosuchstreet',
    number: 0,
    city: 'Nosuchcity',
    state: 'Nosuchstate',
    country: 'Nosuchcountry',
    postcode: 12345,
    email: 'j.doe@nosuchemail.com',
    phone: '1234567890',
    cell: '1234567890',
    immageUrl: '',
  );
}
