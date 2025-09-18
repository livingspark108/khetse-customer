import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomPlaceAutocomplete extends StatefulWidget {
  final Function(LatLng position, String address) onPlaceSelected;

  const CustomPlaceAutocomplete({required this.onPlaceSelected, Key? key})
      : super(key: key);

  @override
  State<CustomPlaceAutocomplete> createState() =>
      _CustomPlaceAutocompleteState();
}

class _CustomPlaceAutocompleteState extends State<CustomPlaceAutocomplete> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _placePredictions = [];
  Timer? _debounce;
  late FocusNode _focusNode;

  final String apiKey = "AIzaSyBdt6B5LE9e7jIrFPG0qmsCNFd9bDiWoAc";

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_controller.text.isNotEmpty) {
        _fetchSuggestions(_controller.text);
      } else {
        setState(() {
          _placePredictions = [];
        });
      }
    });
  }

  Future<void> _fetchSuggestions(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&components=country:in&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        setState(() {
          _placePredictions = json['predictions'];
        });
      } else {
        setState(() {
          _placePredictions = [];
        });
      }
    } else {
      setState(() {
        _placePredictions = [];
      });
    }
  }

  Future<void> _selectPlace(String placeId, String description) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response. statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final location = json['result']['geometry']['location'];
        final latLng = LatLng(location['lat'], location['lng']);

        widget.onPlaceSelected(latLng, description);

        if (mounted) {
          _controller.removeListener(_onSearchChanged);
          _controller.text = description;
          _placePredictions.clear();
          setState(() {});
          _controller.addListener(_onSearchChanged);
          FocusScope.of(context).unfocus();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (mounted) setState(() => _placePredictions.clear());
      }
    });
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.removeListener(_onSearchChanged);
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search box with modern design
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(

              labelText: "Venue",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              fillColor: Color(0xFFedf1f0),
              filled: true,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Animated suggestion list
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _placePredictions.isNotEmpty
              ? Container(
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _placePredictions.length,
              itemBuilder: (context, index) {
                final prediction = _placePredictions[index];
                final desc = prediction['description'] as String;

                // Highlight first part (city/town usually)
                final firstComma = desc.indexOf(',');
                final mainText = firstComma != -1
                    ? desc.substring(0, firstComma)
                    : desc;
                final secondaryText =
                firstComma != -1 ? desc.substring(firstComma + 1) : "";

                return ListTile(
                  leading: const Icon(Icons.location_on,
                      color: Colors.redAccent),
                  title: Text(
                    mainText,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: secondaryText.isNotEmpty
                      ? Text(secondaryText.trim(),
                      style: const TextStyle(fontSize: 12))
                      : null,
                  onTap: () {



                    _selectPlace(
                    prediction['place_id'],
                    prediction['description'],
                  );

                    },
                );
              },
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
