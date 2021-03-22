library auto_search;

import 'package:flutter/material.dart';

typedef OnTap = void Function(int index);

///Class for adding AutoSearchInput to your project
class AutoSearchInput extends StatefulWidget {
  ///List of data that can be searched through for the results
  final List<String> data;

  ///The max number of elements to be displayed when the TextField is clicked
  final int maxElementsToDisplay;

  ///The color of text which actually appears in the results for which the text
  ///is typed
  final Color selectedTextColor;

  ///The color of text which actually appears in the results for the
  ///remaining text
  final Color unSelectedTextColor;

  ///Color of the border when the TextField is enabled
  final Color enabledBorderColor;

  ///Color of the border when the TextField is disabled
  final Color disabledBorderColor;

  ///Color of the border when the TextField is being interated with
  final Color focusedBorderColor;

  ///Color of the cursor
  final Color cursorColor;

  ///Border Radius of the TextField and the resultant elements
  final double borderRadius;

  ///Font Size for both the text in the TextField and the results
  final double fontSize;

  ///Height of a single item in the resultant list
  final double singleItemHeight;

  ///Number of items to be shown when the TextField is tapped
  final int itemsShownAtStart;

  ///Hint text to show inside the TextField
  final String hintText;

  ///Boolean to set autoCorrect
  final bool autoCorrect;

  ///Boolean to set whether the TextField is enabled
  final bool enabled;

  ///onSubmitted function
  final Function onSubmitted;

  ///Function to call when a certain item is clicked
  /// Takes in a paramter of the item which was clicked
  final OnTap onItemTap;

  ///onEditingComplete function
  final Function onEditingComplete;

  ///List Background Color
  final Color bgColor;

  final SearchMode searchMode;

  const AutoSearchInput({
    @required this.data,
    @required this.maxElementsToDisplay,
    @required this.onItemTap,
    this.selectedTextColor,
    this.unSelectedTextColor,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.focusedBorderColor,
    this.cursorColor,
    this.borderRadius = 10.0,
    this.fontSize = 20.0,
    this.singleItemHeight = 40.0,
    this.itemsShownAtStart = 10,
    this.hintText = 'Enter a name',
    this.autoCorrect = true,
    this.enabled = true,
    this.onSubmitted,
    this.onEditingComplete,
    this.bgColor = Colors.white,
    this.searchMode = SearchMode.CONTAINS,
  }) : assert(data != null, maxElementsToDisplay != null);

  @override
  _AutoSearchInputState createState() => _AutoSearchInputState();
}

class _AutoSearchInputState extends State<AutoSearchInput> {
  List<String> results = [];
  bool isItemClicked = false;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController..addListener(onSearchTextChanges);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _getRichText(String result) {
    String textSelected = "";
    String textBefore = "";
    String textAfter = "";
    try {
      String lowerCaseResult = result.toLowerCase();
      String lowerCaseSearchText = _textEditingController.text.toLowerCase();
      textSelected = result.substring(
          lowerCaseResult.indexOf(lowerCaseSearchText),
          lowerCaseResult.indexOf(lowerCaseSearchText) +
              lowerCaseSearchText.length);
      String loserCaseTextSelected = textSelected.toLowerCase();
      textBefore =
          result.substring(0, lowerCaseResult.indexOf(loserCaseTextSelected));
      if (lowerCaseResult.indexOf(loserCaseTextSelected) + textSelected.length <
          result.length) {
        textAfter = result.substring(
            lowerCaseResult.indexOf(loserCaseTextSelected) +
                textSelected.length,
            result.length);
      }
    } catch (e) {
      print(e.toString());
    }
    return RichText(
      text: _textEditingController.text.length > 0
          ? TextSpan(
              children: [
                if (_textEditingController.text.length > 0)
                  TextSpan(
                    text: textBefore,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.unSelectedTextColor != null
                          ? widget.unSelectedTextColor
                          : Colors.grey[400],
                    ),
                  ),
                TextSpan(
                  text: textSelected,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: widget.selectedTextColor != null
                        ? widget.selectedTextColor
                        : Colors.black,
                  ),
                ),
                TextSpan(
                  text: textAfter,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: widget.unSelectedTextColor != null
                        ? widget.unSelectedTextColor
                        : Colors.grey[400],
                  ),
                )
              ],
            )
          : TextSpan(
              text: result,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.unSelectedTextColor != null
                    ? widget.unSelectedTextColor
                    : Colors.grey[400],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: TextField(
            autocorrect: widget.autoCorrect,
            enabled: widget.enabled,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            onTap: () {
              setState(() {
                if (isItemClicked) {
                  isItemClicked = !isItemClicked;
                }
              });
            },
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.all(10.0),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.disabledBorderColor != null
                        ? widget.borderRadius
                        : Colors.grey[200]),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.enabledBorderColor != null
                      ? widget.borderRadius
                      : Colors.grey[200],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadius),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.focusedBorderColor != null
                        ? widget.borderRadius
                        : Colors.grey[200]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadius),
                  topRight: Radius.circular(widget.borderRadius),
                ),
              ),
            ),
            style: TextStyle(
              fontSize: widget.fontSize,
            ),
            cursorColor: widget.cursorColor != null
                ? widget.cursorColor
                : Colors.grey[600],
          ),
        ),
        if (!isItemClicked)
          Container(
            height: widget.itemsShownAtStart * widget.singleItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Container(
                  height: widget.singleItemHeight,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    border: Border.all(color: Colors.grey[300]),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        index == (results.length - 1)
                            ? widget.borderRadius
                            : 0.0,
                      ),
                      bottomRight: Radius.circular(
                        index == (results.length - 1)
                            ? widget.borderRadius
                            : 0.0,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      String value = results[index];
                      widget.onItemTap(widget.data.indexOf(value));
                      _textEditingController.text = value;
                      _textEditingController.selection =
                          TextSelection.fromPosition(
                        TextPosition(
                          offset: value.length,
                        ),
                      );
                      setState(() {
                        isItemClicked = !isItemClicked;
                      });
                    },
                    child: _getRichText(results[index]),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void onSearchTextChanges() {
    switch (widget.searchMode) {
      case SearchMode.STARTING_WITH:
        setState(() {
          results = widget.data
              .where(
                (element) => element
                    .toLowerCase()
                    .startsWith(_textEditingController.text.toLowerCase()),
              )
              .toList();
        });
        break;
      case SearchMode.CONTAINS:
        setState(() {
          results = widget.data
              .where(
                (element) => element
                    .toLowerCase()
                    .contains(_textEditingController.text.toLowerCase()),
              )
              .toList();
        });
        break;
      case SearchMode.EXACT_MATCH:
        setState(() {
          results = widget.data
              .where(
                (element) =>
                    element.toLowerCase() ==
                    _textEditingController.text.toLowerCase(),
              )
              .toList();
        });
        break;
    }
    setState(() {
      if (results.length > widget.maxElementsToDisplay) {
        results = results.sublist(0, widget.maxElementsToDisplay);
      }
    });
  }
}

enum SearchMode {
  STARTING_WITH,
  CONTAINS,
  EXACT_MATCH,
}
