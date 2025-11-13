class BasketItem {
   String name;
   String image;
  String price;
  int quantity;

  BasketItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity=1
  });

}