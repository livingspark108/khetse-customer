import 'package:flutter/material.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/constants/strings.dart';
import 'package:user/models/faqModal.dart';
import 'package:user/screens/data/settings_data.dart';
import 'package:user/widgets/screen_header.dart';
import 'package:user/models/businessLayer/apiHelper.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  late APIHelper apiHelper;

  @override
  void initState() {
    // TODO: implement initState
    apiHelper = APIHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: ColorConstants.getForegroundColor(context),
          ),
        ),
        body: FutureBuilder<List<FAQ>>(
          future: apiHelper.faqList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading FAQs'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No FAQs available'));
            }

            final faqList = snapshot.data!;

            return ListView(
              children: [
                ScreenHeader(title: Strings.faqs),
                Divider(
                    color: ColorConstants.getForegroundColor(context)
                        .withOpacity(0.3)),
                ...faqList.map((faq) => CustomExpansionPanel(
                      title: faq.title,
                      subtitle: faq.subtitle,
                    )),
              ],
            );
          },
        ));
  }
}

class CustomExpansionPanel extends StatefulWidget {
  const CustomExpansionPanel({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  State<CustomExpansionPanel> createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;



  @override
  Widget build(BuildContext context) {
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  child: InkWell(
  borderRadius: BorderRadius.circular(12),
  onTap: () {
  setState(() => isCollapsed = !isCollapsed);
  },
  child: Container(
  decoration: BoxDecoration(
  color: Colors.green.shade50, // light green background
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.green.shade200), // thin border
  ),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  /// Header Row
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Expanded(
  child: Text(
  widget.title,
  style: const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  ),
  ),
  ),
  AnimatedRotation(
  turns: isCollapsed ? 0 : 0.5,
  duration: const Duration(milliseconds: 300),
  child: const Icon(
  Icons.keyboard_arrow_down,
  size: 24,
  ),
  ),
  ],
  ),

  /// Collapsible Content
  AnimatedSize(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: isCollapsed
  ? const SizedBox.shrink()
      : Padding(
  padding: const EdgeInsets.only(top: 12),
  child: Text(
  widget.subtitle,
  style: const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  ),
  ),
  ),
  ),
  ],
  ),
  ),
  ),
  );
  }
}
