
import "dart:io";

class Product {
  String? name, description;
  double? price;

  Product(String? name, String? description, double? price) {
    this.name = name;
    this.description = description;
    this.price = price;
  }

  void display(var i) {
    print("Details for product $i");
    print("Name: ${name?.toUpperCase()}");
    print("Description: $description");
    print("price: \$${price?.toStringAsFixed(2) ?? 'N/A'}\n");
  }
}

class ProductManager {
  List<Product> products = [];

  addProduct() {
    print("Enter the product name:");
    String? name = stdin.readLineSync();
    print("Enter the product description:");
    var description = stdin.readLineSync();
    print("Enter the product price:");
    var price = double.tryParse(stdin.readLineSync() ?? "");

    if (name == null || description == null || price == null || price < 0) {
      print("Invalid input. Product not added.");
      return;
    }

    Product p = Product(name, description, price);
    products.add(p);
    print("Product has been added successfully!");
  }

  viewAllProducts() {
    if (products.isEmpty) {
      print("No Products Available.");
      return;
    }
    for (var i = 0; i < products.length; i++) {
      products[i].display(i + 1);
    }
  }

  viewSingleProduct() {
  if (products.isEmpty) {
    print("No Products Available.");
    return;
  }

  print("Enter the product number to view:");
  int? index = int.tryParse(stdin.readLineSync() ?? "");

  if (index == null || index < 1 || index > products.length) {
    print("Invalid product number.");
  } else {
    products[index - 1].display(index);
  }
}


  editProduct() {
    if (products.isEmpty) {
      print("No Products to edit.");
      return;
    }

    String? newName, newDescription;
    double? newPrice;
    int? number;

    print("Enter product number to edit:");
    number = int.tryParse(stdin.readLineSync() ?? "-1");

    if (number == null || number < 1 || number > products.length) {
      print("Product not found");
      return;
    }

    print("Enter the new name to be applied or leave it blank space");
    newName = stdin.readLineSync();
    print("Enter the new description to be applied or leave it blank space");
    newDescription = stdin.readLineSync();
    print("Enter the new price to be applied or leave it blank space");
    String? priceInput = stdin.readLineSync();
    newPrice = priceInput == null || priceInput.trim().isEmpty
        ? null
        : double.tryParse(priceInput.trim());

    if (newName != null && newName.isNotEmpty) {
      products[number - 1].name = newName;
    }
    if (newDescription != null && newDescription.isNotEmpty) {
      products[number - 1].description = newDescription;
    }
    if (newPrice != null){
      if(newPrice < 0){
        print("Invalid input.");
      return;
      }
    products[number - 1].price = newPrice;
    }
    

    print("Product $number has been updated successfully.");
  }

  deleteProduct() {
    if (products.isEmpty) {
      print("No Products to delete.");
      return;
    }

    int? number;
    print("Enter product number to delete:");
    number = int.tryParse(stdin.readLineSync() ?? "-1");

    if (number == null || number < 1 || number > products.length) {
      print("Product not found");
      return;
    }

    products.removeAt(number - 1);
    print("Product $number has been deleted successfully.");
  }
}

void main() {
  ProductManager manager = ProductManager();
  bool running = true;

  while (running) {
    print("\n E-Commerce Product Manager");
    print("-----------------------------");
    print("1. Add Product");
    print("2. View All Products");
    print("3. View a single Product");
    print("4. Edit Product");
    print("5. Delete Product");
    print("6. Exit");
    print("Enter your choice from the menu:");
    var choice = stdin.readLineSync();
    switch (choice) {
      case "1":
        manager.addProduct();
        break;
      case '2':
        manager.viewAllProducts();
        break;
      case '3':
        manager.viewSingleProduct();
        break;
      case '4':
        manager.editProduct();
        break;
      case '5':
        manager.deleteProduct();
        break;
      case "6":
        running = false;
        print("Thanks for using the app");
        break;
      default:
        print("Invalid option try again");
    }
  }
}
