import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/address_provider.dart';
import 'map_picker_screen.dart';

class AddressManagerScreen extends ConsumerWidget {
  const AddressManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(savedAddressesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPickerScreen()));
              if (res != null && res is Map) {
                // show dialog to pick label
                final label = await showDialog<String>(
                  context: context,
                  builder: (c) {
                    String chosen = "Home";
                    return AlertDialog(
                      title: const Text("Save Address"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(onChanged: (v) => chosen = v, decoration: const InputDecoration(labelText: "Label (Home/Work/Custom)")),
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, null), child: const Text("Cancel")),
                        TextButton(onPressed: () => Navigator.pop(c, chosen.isEmpty ? "Custom" : chosen), child: const Text("Save")),
                      ],
                    );
                  },
                );

                if (label != null) {
                  ref.read(savedAddressesProvider.notifier).addAddress(
                    label: label,
                    address: res['address'] ?? 'Unknown',
                    lat: res['lat'] as double,
                    lng: res['lng'] as double,
                  );
                }
              }
            },
            icon: const Icon(Icons.add_location),
            label: const Text('Add Address'),
          ),
          const SizedBox(height: 12),
          ...addresses.map((a) => Card(
            child: ListTile(
              title: Text(a.label),
              subtitle: Text(a.address),
              trailing: PopupMenuButton(
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'default',
                    child: const Text('Set Default'),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: const Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Text('Delete'),
                  ),
                ],
                onSelected: (v) {
                  if (v == 'default') {
                    ref.read(savedAddressesProvider.notifier).setDefault(a.id);
                  } else if (v == 'delete') {
                    ref.read(savedAddressesProvider.notifier).removeAddress(a.id);
                  } else if (v == 'edit') {
                    // quick edit label
                    showDialog(
                      context: context,
                      builder: (c) {
                        final ctrl = TextEditingController(text: a.label);
                        return AlertDialog(
                          title: const Text('Edit Label'),
                          content: TextField(controller: ctrl),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                final updated = a.copyWith(label: ctrl.text);
                                ref.read(savedAddressesProvider.notifier).updateAddress(updated);
                                Navigator.pop(c);
                              },
                              child: const Text('Save'),
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ))
        ],
      ),
    );
  }
}
