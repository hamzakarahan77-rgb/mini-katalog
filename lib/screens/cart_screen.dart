import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../services/cart_provider.dart';

class CartScreen extends StatefulWidget {
  final CartProvider cartProvider;

  const CartScreen({super.key, required this.cartProvider});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    widget.cartProvider.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    widget.cartProvider.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final items = widget.cartProvider.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Sepetim', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Sepeti Temizle'),
                    content: const Text('Tüm ürünler sepetten kaldırılsın mı?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
                      TextButton(
                        onPressed: () {
                          widget.cartProvider.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text('Temizle', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Temizle', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: items.isEmpty ? _buildEmpty() : _buildCartList(items),
      bottomNavigationBar: items.isEmpty ? null : _buildCheckout(context),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Sepetiniz boş', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Ürün eklemek için alışverişe devam edin.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCartList(items) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Ürün Görseli
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(4),
                    child: CachedNetworkImage(
                      imageUrl: item.product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Ürün Bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Miktar Kontrolü
                Column(
                  children: [
                    Row(
                      children: [
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: () => widget.cartProvider.decreaseQuantity(item.product.id),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () => widget.cartProvider.addToCart(item.product),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toplam: \$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }

  Widget _buildCheckout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Toplam Ürün:', style: TextStyle(color: Colors.grey)),
              Text('${widget.cartProvider.totalCount} adet'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Genel Toplam:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '\$${widget.cartProvider.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('🎉 Sipariş Verildi!'),
                    content: Text(
                      'Toplam \$${widget.cartProvider.totalPrice.toStringAsFixed(2)} tutarında siparişiniz alındı.\n\n(Bu bir simülasyondur)',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          widget.cartProvider.clearCart();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Tamam'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Siparişi Tamamla', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
