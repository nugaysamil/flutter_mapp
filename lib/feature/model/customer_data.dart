class CustomerData {
  const CustomerData({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.photoUrl,
    required this.material,
  });
  final String name;
  final String address;
  final String phoneNumber;
  final String photoUrl;
  final String material;
}

class CustomerDataList {
  static final List<CustomerData> customers = [
    const CustomerData(
      name: 'Leslie Alexander',
      address: 'İstinye',
      phoneNumber: '+62 822 8828 9878',
      photoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      material: 'Tahta',
    ),
    const CustomerData(
      name: 'Jane Doe',
      address: 'Üç Kuyular',
      phoneNumber: '+62 811 2233 4455',
      photoUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      material: 'Süt',
    ),
    const CustomerData(
      name: 'Şamil Nugay',
      address: 'İnciraltı',
      phoneNumber: '+62 812 3344 5566',
      photoUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
      material: 'Kola',
    ),
  ];
}
