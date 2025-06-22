import 'package:pockaw/features/category/data/model/category_model.dart';

final List<CategoryModel> categories = [
  CategoryModel(
    id: 1,
    title: 'Food & Drinks',
    description: 'Groceries, dining out, beverages, snacks.',
    subCategories: [
      CategoryModel(
        id: 101,
        parentId: 1,
        title: 'Groceries',
        description: 'Supermarket and grocery store expenses.',
      ),
      CategoryModel(
        id: 102,
        parentId: 1,
        title: 'Restaurants',
        description: 'Dining at restaurants.',
      ),
      CategoryModel(
        id: 103,
        parentId: 1,
        title: 'Coffee',
        description: 'Coffee shops and cafés.',
      ),
      CategoryModel(
        id: 104,
        parentId: 1,
        title: 'Snacks',
        description: 'Small bites and treats.',
      ),
      CategoryModel(
        id: 105,
        parentId: 1,
        title: 'Takeout',
        description: 'Food delivery and takeout orders.',
      ),
    ],
  ),
  CategoryModel(
    id: 2,
    title: 'Transportation',
    description: 'Public transport, fuel, ride-sharing, vehicle costs.',
    subCategories: [
      CategoryModel(
        id: 201,
        parentId: 2,
        title: 'Public Transport',
        description: 'Bus, train, subway, tram fares.',
      ),
      CategoryModel(
        id: 202,
        parentId: 2,
        title: 'Fuel/Gas',
        description: 'Petrol, diesel, EV charging.',
      ),
      CategoryModel(
        id: 203,
        parentId: 2,
        title: 'Taxi & Rideshare',
        description: 'Uber, Lyft, taxi fares.',
      ),
      CategoryModel(
        id: 204,
        parentId: 2,
        title: 'Vehicle Maintenance',
        description: 'Repairs, servicing, tires.',
      ),
      CategoryModel(
        id: 205,
        parentId: 2,
        title: 'Parking',
        description: 'Paid parking fees.',
      ),
    ],
  ),
  CategoryModel(
    id: 3,
    title: 'Housing',
    description: 'Rent, mortgage, utilities, property maintenance.',
    subCategories: [
      CategoryModel(
        id: 301,
        parentId: 3,
        title: 'Rent',
        description: 'Monthly rent payments.',
      ),
      CategoryModel(
        id: 302,
        parentId: 3,
        title: 'Mortgage',
        description: 'Mortgage payments for owned property.',
      ),
      CategoryModel(
        id: 303,
        parentId: 3,
        title: 'Utilities',
        description: 'Electricity, water, gas, etc.',
      ),
      CategoryModel(
        id: 304,
        parentId: 3,
        title: 'Maintenance',
        description: 'Repairs, renovations, upkeep.',
      ),
      CategoryModel(
        id: 305,
        parentId: 3,
        title: 'Property Tax',
        description: 'Annual property taxes.',
      ),
    ],
  ),
  CategoryModel(
    id: 4,
    title: 'Entertainment',
    description: 'Leisure, games, streaming, subscriptions.',
    subCategories: [
      CategoryModel(
        id: 401,
        parentId: 4,
        title: 'Movies',
        description: 'Cinema and film purchases.',
      ),
      CategoryModel(
        id: 402,
        parentId: 4,
        title: 'Streaming',
        description: 'Netflix, Spotify, etc.',
      ),
      CategoryModel(
        id: 403,
        parentId: 4,
        title: 'Gaming',
        description: 'Video games and apps.',
      ),
      CategoryModel(
        id: 404,
        parentId: 4,
        title: 'Events',
        description: 'Concerts, shows, festivals.',
      ),
      CategoryModel(
        id: 405,
        parentId: 4,
        title: 'Subscriptions',
        description: 'Ongoing entertainment subscriptions.',
      ),
    ],
  ),
  CategoryModel(
    id: 5,
    title: 'Health',
    description: 'Medical, pharmacy, fitness, wellness.',
    subCategories: [
      CategoryModel(
        id: 501,
        parentId: 5,
        title: 'Doctor Visits',
        description: 'Consultations and checkups.',
      ),
      CategoryModel(
        id: 502,
        parentId: 5,
        title: 'Pharmacy',
        description: 'Medicine and supplies.',
      ),
      CategoryModel(
        id: 503,
        parentId: 5,
        title: 'Insurance',
        description: 'Health insurance premiums.',
      ),
      CategoryModel(
        id: 504,
        parentId: 5,
        title: 'Fitness',
        description: 'Gym memberships, classes.',
      ),
      CategoryModel(
        id: 505,
        parentId: 5,
        title: 'Dental',
        description: 'Dentist visits, treatments.',
      ),
    ],
  ),
  CategoryModel(
    id: 6,
    title: 'Shopping',
    description: 'Clothing, online shopping, accessories.',
    subCategories: [
      CategoryModel(
        id: 601,
        parentId: 6,
        title: 'Clothing',
        description: 'Apparel and fashion.',
      ),
      CategoryModel(
        id: 602,
        parentId: 6,
        title: 'Electronics',
        description: 'Phones, gadgets, tech.',
      ),
      CategoryModel(
        id: 603,
        parentId: 6,
        title: 'Shoes',
        description: 'Footwear of all types.',
      ),
      CategoryModel(
        id: 604,
        parentId: 6,
        title: 'Accessories',
        description: 'Bags, jewelry, watches.',
      ),
      CategoryModel(
        id: 605,
        parentId: 6,
        title: 'Online Shopping',
        description: 'eCommerce expenses.',
      ),
    ],
  ),
  CategoryModel(
    id: 7,
    title: 'Education',
    description: 'School, tuition, books, training.',
    subCategories: [
      CategoryModel(
        id: 701,
        parentId: 7,
        title: 'Tuition',
        description: 'School or university tuition.',
      ),
      CategoryModel(
        id: 702,
        parentId: 7,
        title: 'Books',
        description: 'Textbooks and materials.',
      ),
      CategoryModel(
        id: 703,
        parentId: 7,
        title: 'Online Courses',
        description: 'Skill-building and e-learning.',
      ),
      CategoryModel(
        id: 704,
        parentId: 7,
        title: 'Workshops',
        description: 'Training and development.',
      ),
      CategoryModel(
        id: 705,
        parentId: 7,
        title: 'School Supplies',
        description: 'Stationery and equipment.',
      ),
    ],
  ),
  CategoryModel(
    id: 8,
    title: 'Travel',
    description: 'Trips, transport, lodging, vacation spending.',
    subCategories: [
      CategoryModel(
        id: 801,
        parentId: 8,
        title: 'Flights',
        description: 'Airfare and plane tickets.',
      ),
      CategoryModel(
        id: 802,
        parentId: 8,
        title: 'Hotels',
        description: 'Accommodation and lodging.',
      ),
      CategoryModel(
        id: 803,
        parentId: 8,
        title: 'Tours',
        description: 'Excursions, sightseeing.',
      ),
      CategoryModel(
        id: 804,
        parentId: 8,
        title: 'Transport',
        description: 'Travel transport and fares.',
      ),
      CategoryModel(
        id: 805,
        parentId: 8,
        title: 'Souvenirs',
        description: 'Memorabilia and gifts.',
      ),
    ],
  ),
  CategoryModel(
    id: 9,
    title: 'Finance',
    description: 'Investments, savings, loan payments.',
    subCategories: [
      CategoryModel(
        id: 901,
        parentId: 9,
        title: 'Loan Payments',
        description: 'Debt and loan repayments.',
      ),
      CategoryModel(
        id: 902,
        parentId: 9,
        title: 'Savings',
        description: 'Deposits and saving goals.',
      ),
      CategoryModel(
        id: 903,
        parentId: 9,
        title: 'Investments',
        description: 'Stocks, crypto, and funds.',
      ),
      CategoryModel(
        id: 904,
        parentId: 9,
        title: 'Credit Card',
        description: 'Monthly card expenses.',
      ),
      CategoryModel(
        id: 905,
        parentId: 9,
        title: 'Bank Fees',
        description: 'Charges, fees, and interest.',
      ),
    ],
  ),
  CategoryModel(
    id: 10,
    title: 'Utilities',
    description: 'Recurring household bills and essentials.',
    subCategories: [
      CategoryModel(
        id: 1001,
        parentId: 10,
        title: 'Electricity',
        description: 'Monthly electric bill.',
      ),
      CategoryModel(
        id: 1002,
        parentId: 10,
        title: 'Water',
        description: 'Water supply charges.',
      ),
      CategoryModel(
        id: 1003,
        parentId: 10,
        title: 'Gas',
        description: 'Gas usage charges.',
      ),
      CategoryModel(
        id: 1004,
        parentId: 10,
        title: 'Internet',
        description: 'Home or mobile internet.',
      ),
      CategoryModel(
        id: 1005,
        parentId: 10,
        title: 'Phone',
        description: 'Mobile/cellphone plans.',
      ),
    ],
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
