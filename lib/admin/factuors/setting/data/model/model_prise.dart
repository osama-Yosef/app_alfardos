import '../../../../../client/factuors/client_order/data/model/order_model.dart';

class PricingModel {
  final String orderId;
  final String clientName;
  final String clientPhone;
  final DateTime createdAt;

  final List<String> engFiles;
  final List<String> engImages;
  final String engNote;

  PricingModel({
    required this.orderId,
    required this.clientName,
    required this.clientPhone,
    required this.createdAt,
    required this.engFiles,
    required this.engImages,
    required this.engNote,
  });

  factory PricingModel.fromOrder(
      OrderModel order,
      Map<String, dynamic>? engReview,
      ) {
    return PricingModel(
      orderId: order.id,
      clientName: order.name.isNotEmpty ? order.name : 'عميل',
      clientPhone: order.numper?.toString() ?? '',
      createdAt: order.createdAt,

      engFiles: _stringList(engReview?['files']),
      engImages: _stringList(engReview?['images']),
      engNote: engReview?['note']?.toString() ?? '',
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
