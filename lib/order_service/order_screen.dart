// ✅ 이 파일은 발주 화면(OrderScreen)에서 외부에서 부족한 품목을 받아와 자동으로 수량(count)을 반영할 수 있도록 확장된 버전입니다.

import 'package:flutter/material.dart';
import 'package:refill/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'stocks_screen.dart';

class OrderScreen extends StatefulWidget {
  final Map<String, int>? prefilledCounts; // 🔹 외부에서 전달되는 품목:수량 데이터
  const OrderScreen({super.key, this.prefilledCounts});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isAuto = false;
  int selectedCategory = 0;
  final List<String> categories = ['시럽', '원두/우유', '파우더', '디저트', '티', '기타'];

  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrderData();
    _searchController.addListener(_filterItemsByCategory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrderData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final storeId = userDoc['storeId'];

    final orderTemplateSnap = await FirebaseFirestore.instance.collection('orderTemplates').get();
    final stockSnap = await FirebaseFirestore.instance
        .collection('stocks')
        .doc(storeId)
        .collection('items')
        .get();

    final stockMap = {
      for (var doc in stockSnap.docs) doc.id: doc.data()
    };

    final combined = orderTemplateSnap.docs.map((doc) {
      final name = doc.id;
      final template = doc.data();
      final stock = stockMap[name];

      return {
        'name': name,
        'unit': template['unit'] ?? '',
        'defaultQuantity': template['defaultQuantity'] ?? 1,
        'stock': stock?['quantity'] ?? 0,
        'min': stock?['minQuantity'] ?? 0,
        'count': 0, // 이후에 prefilled로 덮어씀
        'category': template['category'] ?? '기타',
      };
    }).toList();

    // 🔹 외부에서 전달된 count 반영
    if (widget.prefilledCounts != null) {
      for (final item in combined) {
        final name = item['name'];
        if (widget.prefilledCounts!.containsKey(name)) {
          item['count'] = widget.prefilledCounts![name]!;
        }
      }
    }

    setState(() {
      items = combined;
      _filterItemsByCategory();
    });
  }

  void _filterItemsByCategory() {
    final selected = categories[selectedCategory];
    final keyword = _searchController.text.trim();

    setState(() {
      filteredItems = items.where((item) {
        final matchCategory = item['category'] == selected;
        final matchSearch = item['name'].toString().contains(keyword);
        return matchCategory && matchSearch;
      }).toList();
    });
  }

  Future<void> _placeOrder() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final storeId = userDoc['storeId'];
    final batch = FirebaseFirestore.instance.batch();

    for (var item in items) {
      final count = item['count'];
      final itemName = item['name'];
      final currentQty = item['stock'];

      if (count <= 0) continue;

      final newQty = currentQty + count;
      final docId = itemName;

      final docRef = FirebaseFirestore.instance
          .collection('stocks')
          .doc(storeId)
          .collection('items')
          .doc(docId);

      batch.set(docRef, {
        'quantity': newQty,
      }, SetOptions(merge: true));
    }

    try {
      await batch.commit();
      Navigator.pop(context, true);
      await _loadOrderData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("발주가 완료되었습니다.")),
      );
    } catch (e) {
      print("발주 중 오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("발주 실패. 다시 시도해주세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '발주',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StocksScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('재고', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '검색',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: AppColors.primary),
              children: [
                TableRow(children: List.generate(3, (i) => _buildCategoryCell(i))),
                TableRow(children: List.generate(3, (i) => _buildCategoryCell(i + 3))),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: filteredItems.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isShort = item['stock'] < item['min'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '현재재고 ${item['stock']} / 최소 ${item['min']}',
                            style: TextStyle(
                              color: isShort ? Colors.red : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: AppColors.primary),
                            onPressed: () {
                              setState(() {
                                if (item['count'] > 0) item['count']--;
                              });
                            },
                          ),
                          Text('${item['count']}', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add, color: AppColors.primary),
                            onPressed: () {
                              setState(() {
                                item['count']++;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: _placeOrder,
                child: const Text('발주하기', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCell(int index) {
    final isSelected = selectedCategory == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
        _filterItemsByCategory();
      },
      child: Container(
        height: 48,
        alignment: Alignment.center,
        color: isSelected ? AppColors.primary : Colors.white,
        child: Text(
          categories[index],
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
