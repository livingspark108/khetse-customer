import 'package:flutter/material.dart';

import '../controllers/order_controller.dart';
import '../models/businessLayer/baseRoute.dart';
import '../models/orderModel.dart';

class OrderTrackingScreen extends BaseRoute {
  final Order? order;
  final OrderController? orderController;
  OrderTrackingScreen(this.order, this.orderController, {super.analytics, super.observer, super.routeName = 'MapScreen'});


  @override
  _OrderTrackingScreenState createState() => new _OrderTrackingScreenState(this.order, this.orderController);
}

class _OrderTrackingScreenState extends BaseRouteState {
  // Available order statuses
  final List<String> _processes = [
    'Pending',
    'Placed',
    'Confirmed',
    'Out for Delivery',
    'Completed',
  ];

  // Example: Change this to see progress (0–3)
  int _processIndex = 0;

  Color _getColor(int index) {
    if (index < _processIndex) return Colors.green;
    if (index == _processIndex) return Colors.orange;
    return Colors.grey.shade400;
  }
  Order? order;
  OrderController? orderController;
  _OrderTrackingScreenState(this.order, this.orderController) : super();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Status card
          Container(
            width: width,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.local_shipping, size: 50, color: Colors.indigo),
                const SizedBox(height: 10),
                Text(
                  "Your order is ${_processes[_processIndex]}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "We’re processing your order. Please wait for the next update.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Timeline progress
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_processes.length, (index) {
                final bool isCompleted = index < _processIndex;
                final bool isCurrent = index == _processIndex;

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: isCompleted
                              ? Colors.green
                              : (isCurrent ? Colors.orange : Colors.grey.shade300),
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white)
                              : (isCurrent
                              ? const Icon(Icons.check, color: Colors.white)
                              : null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 80,
                      child: Text(
                        _processes[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _getColor(index),
                          fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          // Action button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                setState(() {
                  if (_processIndex < _processes.length - 1) {
                    _processIndex++;
                  }
                });
              },
              child: Text(
                _processIndex < _processes.length - 1
                    ? "Next Step"
                    : "Completed",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
