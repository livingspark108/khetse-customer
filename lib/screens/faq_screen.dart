import 'package:flutter/material.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/constants/strings.dart';
import 'package:user/screens/data/settings_data.dart';
import 'package:user/widgets/screen_header.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: ColorConstants.getForegroundColor(context),
        ),
      ),
      body: ListView(
        children: [
          ScreenHeader(title: Strings.faqs),
          Divider(color: ColorConstants.getForegroundColor(context).withOpacity(0.3)),
          ...List.generate(
            5,
                (index) {
              final Map<String, String> faq = SettingsData.faqData[index];
              return CustomExpansionPanel(
                title: faq['title']!,
                subtitle: faq['subtitle']!,
              );
            },
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          setState(() {
            isCollapsed = !isCollapsed;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: ColorConstants.getForegroundColor(context).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: isCollapsed ? 0 : 0.5, // Rotates 180 degrees
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isCollapsed
                    ? const SizedBox.shrink()
                    : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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
