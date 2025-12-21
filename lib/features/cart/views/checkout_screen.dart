import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_colors.dart';
import '../../location/views/map_picker_screen.dart';
import '../../location/providers/address_provider.dart';
import '../../notification/notification_service.dart';
import '../../cart/providers/cart_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController promoController = TextEditingController();

  String selectedDeliveryTime = '30–40 mins';
  String selectedPayment = 'Khalti';
  bool promoApplied = false;
  double discountPercent = 0.0;

  @override
  void initState() {
    super.initState();
    NotificationService.init(); // init notifications
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartNotifierProvider);
    final total = ref.watch(cartTotalProvider); // provider from cart_providers.dart
    final addresses = ref.watch(savedAddressesProvider);

    double deliveryFee = 2;
    double subtotal = total;
    double tax = subtotal * 0.02;
    double discount = promoApplied ? subtotal * (discountPercent / 100) : 0.0;
    double grandTotal = subtotal + deliveryFee + tax - discount;

    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      appBar: AppBar(
        backgroundColor: AppColors.deepMidnight,
        title: Text('Checkout', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Receiver Details', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 12),
          _inputField('Full name', nameController),
          const SizedBox(height: 12),
          _inputField('Phone number', phoneController, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          _inputField('Notes (optional)', notesController, maxLines: 2),
          const SizedBox(height: 18),

          // Address chooser
          Text('Delivery Address', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 12),
          addresses.isEmpty
              ? Card(
            color: Colors.white12,
            child: ListTile(
              title: const Text('No saved addresses', style: TextStyle(color: Colors.white70)),
              trailing: ElevatedButton(
                onPressed: () async {
                  final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPickerScreen()));
                  if (res != null && res is Map) {
                    ref.read(savedAddressesProvider.notifier).addAddress(
                      label: 'Home',
                      address: res['address'] ?? 'Unknown',
                      lat: res['lat'] as double,
                      lng: res['lng'] as double,
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ),
          )
              : Column(
            children: addresses.map((a) {
              return Card(
                color: a == addresses.first ? Colors.white10 : Colors.white12,
                child: ListTile(
                  title: Text(a.label, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(a.address, style: const TextStyle(color: Colors.white70)),
                  trailing: a == addresses.first ? const Text('Default', style: TextStyle(color: Colors.greenAccent)) : null,
                  onTap: () {
                    ref.read(savedAddressesProvider.notifier).setDefault(a.id);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPickerScreen()));
              if (res != null && res is Map) {
                ref.read(savedAddressesProvider.notifier).addAddress(
                  label: 'Custom',
                  address: res['address'] ?? 'Unknown',
                  lat: res['lat'] as double,
                  lng: res['lng'] as double,
                );
              }
            },
            icon: const Icon(Icons.map),
            label: const Text('Choose on Map'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricGreen),
          ),

          const SizedBox(height: 20),
          // Promo
          Text('Promo Code', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _inputField('Enter code', promoController)),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final code = promoController.text.trim().toUpperCase();
                if (code == 'FOOD10') {
                  setState(() {
                    promoApplied = true;
                    discountPercent = 10.0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Promo applied: 10% off')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid promo code')));
                }
              },
              child: const Text('Apply'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricGreen),
            )
          ]),

          const SizedBox(height: 20),

          // Delivery time selection
          Text('Delivery Time', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Card(
            color: Colors.white12,
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('20–30 mins'),
                  value: '20–30 mins',
                  groupValue: selectedDeliveryTime,
                  onChanged: (v) => setState(() => selectedDeliveryTime = v!),
                ),
                RadioListTile<String>(
                  title: const Text('30–40 mins'),
                  value: '30–40 mins',
                  groupValue: selectedDeliveryTime,
                  onChanged: (v) => setState(() => selectedDeliveryTime = v!),
                ),
                RadioListTile<String>(
                  title: const Text('45–60 mins'),
                  value: '45–60 mins',
                  groupValue: selectedDeliveryTime,
                  onChanged: (v) => setState(() => selectedDeliveryTime = v!),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Payment method
          Text('Payment Method', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Card(
            color: Colors.white12,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet, color: Colors.white),
                  title: const Text('Khalti', style: TextStyle(color: Colors.white)),
                  trailing: Radio<String>(value: 'Khalti', groupValue: selectedPayment, onChanged: (v) => setState(() => selectedPayment = v!)),
                ),
                ListTile(
                  leading: const Icon(Icons.money, color: Colors.white),
                  title: const Text('Cash on Delivery', style: TextStyle(color: Colors.white)),
                  trailing: Radio<String>(value: 'COD', groupValue: selectedPayment, onChanged: (v) => setState(() => selectedPayment = v!)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Order summary
          Text('Order Summary', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Card(
            color: Colors.white12,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ...cartItems.map((c) => ListTile(
                    title: Text(c.item.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('x${c.quantity}', style: const TextStyle(color: Colors.white70)),
                    trailing: Text('\$${(c.totalPrice).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                  )),
                  const Divider(color: Colors.white24),
                  _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                  _summaryRow('Delivery', '\$${deliveryFee.toStringAsFixed(2)}'),
                  _summaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                  if (promoApplied) _summaryRow('Discount', '- \$${discount.toStringAsFixed(2)}', color: Colors.greenAccent),
                  const Divider(color: Colors.white24),
                  _summaryRow('Total', '\$${grandTotal.toStringAsFixed(2)}', bold: true),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              // perform validations
              if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty || addresses.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill name, phone and select address')));
                return;
              }

              // MOCK: place order (call to backend would go here)
              // Clear cart, show notification, go to order success
              ref.read(cartNotifierProvider.notifier).clearCart();

              await NotificationService.showOrderPlaced(
                title: 'Order Confirmed',
                body: 'Your order is confirmed and being prepared.',
              );

              // navigate to payment or success screen
              if (selectedPayment == 'Khalti') {
                // go to payment flow
                context.push('/payment');
              } else {
                context.push('/order-success');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricGreen, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text('Place Order', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w700)),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
        Text(value, style: GoogleFonts.poppins(color: color ?? Colors.white, fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
      ]),
    );
  }
}
