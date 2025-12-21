import 'dart:io';

class ClientOrderItem {
  String name;
  int numper;
  String product;
  String material;
  int amount;
  String size;
  String comment;

  List<String>? images;
  List<String>? files;
  List<File>? imageFiles;
  List<File>? fileFiles;

  ClientOrderItem({
    required this.name,
    required this.numper,
    required this.product,
    required this.material,
    required this.amount,
    required this.size,
    required this.comment,

    this.images,
    this.files,
    this.imageFiles,
    this.fileFiles,
  });
}
