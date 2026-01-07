class PricingReviewModel {
  /// id الأوردر نفسه (document id)
  final String orderId;

  /// تاريخ إضافة التسعير
  final String date;

  /// هل تم السداد بالكامل
  final bool isPaid;

  /// سعر الليزر
  final int laser;

  /// سعر الخامة
  final int material;

  /// آخر عربون تم دفعه
  final int lastDeposit;

  /// إجمالي المدفوع
  final int paid;

  /// المتبقي على العميل
  final int remaining;

  /// السعر الكلي
  final int total;

  /// ملاحظة
  final String note;

  /// صورة إيصال التحويل (ممكن تكون فاضية لو كاش)
  final String receipt;

  PricingReviewModel({
    required this.orderId,
    required this.date,
    required this.isPaid,
    required this.laser,
    required this.material,
    required this.lastDeposit,
    required this.paid,
    required this.remaining,
    required this.total,
    required this.note,
    required this.receipt,
  });

  /// ================= FROM FIRESTORE =================
  factory PricingReviewModel.fromMap(
      Map<String, dynamic> map, {
        required String orderId,
      }) {
    return PricingReviewModel(
      orderId: orderId,
      date: map['date'] ?? '',
      isPaid: map['isPaid'] ?? false,
      laser: (map['laser'] ?? 0).toInt(),
      material: (map['material'] ?? 0).toInt(),
      lastDeposit: (map['lastDeposit'] ?? 0).toInt(),
      paid: (map['paid'] ?? 0).toInt(),
      remaining: (map['remaining'] ?? 0).toInt(),
      total: (map['total'] ?? 0).toInt(),
      note: map['note'] ?? '',
      receipt: map['receipt'] ?? '',
    );
  }

  /// ================= TO FIRESTORE =================
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'isPaid': isPaid,
      'laser': laser,
      'material': material,
      'lastDeposit': lastDeposit,
      'paid': paid,
      'remaining': remaining,
      'total': total,
      'note': note,
      'receipt': receipt,
    };
  }

  /// ================= COPY WITH (للتعديل السريع) =================
  PricingReviewModel copyWith({
    int? paid,
    int? lastDeposit,
    int? remaining,
    bool? isPaid,
    String? receipt,
    String? note,
  }) {
    return PricingReviewModel(
      orderId: orderId,
      date: date,
      isPaid: isPaid ?? this.isPaid,
      laser: laser,
      material: material,
      lastDeposit: lastDeposit ?? this.lastDeposit,
      paid: paid ?? this.paid,
      remaining: remaining ?? this.remaining,
      total: total,
      note: note ?? this.note,
      receipt: receipt ?? this.receipt,
    );
  }
}
