import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    WishlistScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.white,
            selectedItemColor: AppTheme.primary,
            unselectedItemColor: AppTheme.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              // Tab 0 — Beranda
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              // Tab 1 — Wishlist
              BottomNavigationBarItem(
                icon: Consumer<ProductProvider>(
                  builder: (ctx, pp, _) {
                    final count = pp.wishlistedProducts.length;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.favorite_border),
                        if (count > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppTheme.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  count.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                activeIcon: const Icon(Icons.favorite),
                label: 'Wishlist',
              ),
              // Tab 2 — Keranjang
              BottomNavigationBarItem(
                icon: Consumer<CartProvider>(
                  builder: (ctx, cart, _) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppTheme.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                cart.itemCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                activeIcon: const Icon(Icons.shopping_bag),
                label: 'Keranjang',
              ),
              // Tab 3 — Akun
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Akun',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
