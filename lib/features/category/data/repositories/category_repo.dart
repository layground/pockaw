import 'package:pockaw/features/category/data/model/category_model.dart';

// --- Top Level Category IDs (for easy reference when creating sub-categories) ---
const int _foodAndDrinksId = 1;
const int _transportationId = 2;
const int _housingId = 3;
const int _shoppingId = 4;
const int _entertainmentId = 5;
const int _healthId = 6;

final List<CategoryModel> categories = [
  // --- Top Level Categories ---
  CategoryModel(
    id: _foodAndDrinksId,
    title: 'Food & Drinks',
    iconName: 'HugeIcons.strokeRoundedRestaurantMenu', // Example icon name
    description: 'Expenses related to eating out, groceries, coffee, etc.',
    subCategories: [
      CategoryModel(
        id: 101,
        title: 'Groceries',
        iconName:
            'HugeIcons.strokeRoundedShoppingBasket01', // Example icon name
        parentId: _foodAndDrinksId,
        description: 'Weekly grocery shopping.',
      ),
      CategoryModel(
        id: 102,
        title: 'Restaurants',
        iconName: 'HugeIcons.strokeRoundedPlate', // Example icon name
        parentId: _foodAndDrinksId,
      ),
      CategoryModel(
        id: 103, // Giving it an ID for consistency in mock data, can be null if intended
        title: 'Coffee Shops',
        iconName: 'HugeIcons.strokeRoundedCoffee', // Example icon name
        parentId: _foodAndDrinksId,
      ),
    ],
  ),
  CategoryModel(
    id: _transportationId,
    title: 'Transportation',
    iconName: 'HugeIcons.strokeRoundedBus', // Example icon name
    description: 'Costs for public transport, fuel, ride-sharing, etc.',
    subCategories: [
      CategoryModel(
        id: 201,
        title: 'Fuel',
        iconName: 'HugeIcons.strokeRoundedGasStation', // Example icon name
        parentId: _transportationId,
      ),
    ],
  ),
  CategoryModel(
    id: _housingId,
    title: 'Housing',
    iconName: 'HugeIcons.strokeRoundedHome02', // Example icon name
    description: 'Rent, mortgage, utilities, home maintenance.',
    subCategories: [], // Explicitly empty if no sub-categories
  ),
  CategoryModel(
    id: _shoppingId,
    title: 'Shopping',
    iconName: 'HugeIcons.strokeRoundedShoppingBag01', // Example icon name
    description: 'Purchases for clothing, electronics, gifts, etc.',
    subCategories: [
      CategoryModel(
        id: 401,
        title: 'Clothing',
        iconName: 'HugeIcons.strokeRoundedTShirt', // Example icon name
        parentId: _shoppingId,
        description: 'New clothes and accessories.',
      ),
    ],
  ),
  CategoryModel(
    id: _entertainmentId,
    title: 'Entertainment',
    iconName: 'HugeIcons.strokeRoundedCinema', // Example icon name
    description: 'Movies, concerts, hobbies, subscriptions.',
    subCategories: [],
  ),
  CategoryModel(
    id: _healthId,
    title: 'Health & Wellness',
    iconName: 'HugeIcons.strokeRoundedMedicalCrossCircle', // Example icon name
    subCategories: [],
  ),
];

extension CategoriesExtension on List<CategoryModel> {
  /// Returns a flat list of all categories, including sub-categories.
  List<CategoryModel> getAllCategories() {
    final List<CategoryModel> allCategories = [];
    // Helper function to recursively add categories
    void addCategoriesRecursively(List<CategoryModel>? categoryList) {
      if (categoryList == null) return;
      for (final category in categoryList) {
        allCategories.add(category);
        if (category.hasSubCategories) {
          addCategoriesRecursively(category.subCategories);
        }
      }
    }

    addCategoriesRecursively(
      this,
    ); // 'this' refers to the list of top-level categories
    return allCategories;
  }
}
