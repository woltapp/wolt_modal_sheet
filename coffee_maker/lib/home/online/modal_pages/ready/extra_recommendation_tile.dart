import 'package:coffee_maker/home/online/modal_pages/ready/extra_recommendation.dart';
import 'package:coffee_maker/home/widgets/coffee_maker_custom_divider.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class ExtraRecommendationTile extends StatefulWidget {
  const ExtraRecommendationTile({
    required this.recommendation,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final ExtraRecommendation recommendation;
  final bool isSelected;
  final ValueChanged<bool> onPressed;

  @override
  State<ExtraRecommendationTile> createState() => _ExtraRecommendationTileState();
}

class _ExtraRecommendationTileState extends State<ExtraRecommendationTile> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onPressed(_isSelected);
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image(
                            image: AssetImage(widget.recommendation.imageAssetPath), fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.recommendation.label,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 1),
                                    Text(widget.recommendation.price,
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              WoltSelectionListTileTrailing(
                                groupType: WoltSelectionListType.multiSelect,
                                isSelected: _isSelected,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 80),
            child: CoffeeMakerCustomDivider(),
          ),
        ],
      ),
    );
  }
}
