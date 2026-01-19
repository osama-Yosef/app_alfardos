class HomeActiveOrder {
  final String name;
  final String matrial;
  final String deliveryDate;
  final double progress;

  HomeActiveOrder({
    required this.name,
    required this.matrial,
    required this.deliveryDate,
    required this.progress,
  });

  factory HomeActiveOrder.fromMap(Map<String, dynamic> map) {
    double progressValue = (map['progress'] ?? 0) / 100;

    if ((map['status'] ?? '') == 'done') {
      progressValue = 1.0;
    }

    return HomeActiveOrder(
      name: map['name'] ?? '',
      matrial: map['material'] ?? '',
      deliveryDate: map['delivery_date'] ?? '',
      progress: progressValue,
    );
  }
}
