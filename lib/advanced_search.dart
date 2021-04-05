library advanced_search;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

typedef OnTap = void Function(int index, String value);
typedef SubmitResults = void Function(
    String searchText, List<String> searchResults);

///Class for adding AutoSearchInput to your project
class AdvancedSearch extends StatefulWidget {
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

  ///Color of the border when the TextField is being integrated with
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
  final SubmitResults onSubmitted;

  ///Function to call when a certain item is clicked
  /// Takes in a parameter of the item which was clicked
  final OnTap onItemTap;

  /// Callback to be called when the user clears his search
  final Function onSearchClear;

  /// Function to be called on editing the text field
  final SubmitResults onEditingProgress;

  /// Text Inout Background Color
  final Color inputTextFieldBgColor;

  ///List Background Color
  final Color searchResultsBgColor;

  final SearchMode searchMode;

  final bool caseSensitive;

  final int minLettersForSearch;

  final Color borderColor;

  final bool clearSearchEnabled;

  final bool showListOfResults;

  final double verticalPadding;

  final double horizontalPadding;

  const AdvancedSearch({
    @required this.data,
    @required this.maxElementsToDisplay,
    @required this.onItemTap,
    @required this.onSearchClear,
    this.selectedTextColor,
    this.unSelectedTextColor,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.focusedBorderColor,
    this.cursorColor,
    this.borderRadius = 10.0,
    this.fontSize = 14.0,
    this.singleItemHeight = 45.0,
    this.itemsShownAtStart = 10,
    this.hintText = 'Enter a name',
    this.autoCorrect = false,
    this.enabled = true,
    this.onSubmitted,
    this.onEditingProgress,
    this.inputTextFieldBgColor,
    this.searchResultsBgColor = Colors.white,
    this.searchMode = SearchMode.CONTAINS,
    this.caseSensitive = false,
    this.minLettersForSearch = 0,
    this.borderColor = const Color(0xFFFAFAFA),
    this.clearSearchEnabled = true,
    this.showListOfResults = true,
    this.verticalPadding = 10,
    this.horizontalPadding = 10,
  }) : assert(data != null, maxElementsToDisplay != null);

  @override
  _AdvancedSearchState createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  List<String> results = [];
  bool isItemClicked = false;
  String lastSubmittedText = "";

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController..addListener(onSearchTextChanges);

    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if (!visible) {
          if (_textEditingController.text != null) {
            sendSubmitResults(_textEditingController.text);
          }
          FocusScope.of(context).unfocus();
        }
      });
    });
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
      String lowerCaseResult =
          widget.caseSensitive ? result : result.toLowerCase();
      String lowerCaseSearchText = widget.caseSensitive
          ? _textEditingController.text
          : _textEditingController.text.toLowerCase();
      textSelected = result.substring(
          lowerCaseResult.indexOf(lowerCaseSearchText),
          lowerCaseResult.indexOf(lowerCaseSearchText) +
              lowerCaseSearchText.length);
      String loserCaseTextSelected =
          widget.caseSensitive ? textSelected : textSelected.toLowerCase();
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
    return Container(
      alignment: Alignment.centerLeft,
      child: RichText(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLtr = Directionality.of(context) == TextDirection.ltr;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.inputTextFieldBgColor,
              borderRadius: results.length == 0 || isItemClicked
                  ? BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(widget.borderRadius),
                      topRight: Radius.circular(widget.borderRadius),
                    ),
            ),
            child: Stack(
              children: [
                TextField(
                  autocorrect: widget.autoCorrect,
                  enabled: widget.enabled,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  onTap: () {
                    setState(() {
                      isItemClicked = false;
                    });
                  },
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: widget.verticalPadding,
                        horizontal: widget.horizontalPadding),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.disabledBorderColor != null
                              ? widget.disabledBorderColor
                              : Colors.grey[300]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.borderRadius),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.enabledBorderColor != null
                            ? widget.enabledBorderColor
                            : Colors.grey[300],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.borderRadius),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.focusedBorderColor != null
                              ? widget.focusedBorderColor
                              : Colors.grey[300]),
                      borderRadius: results.length == 0 || isItemClicked
                          ? BorderRadius.all(
                              Radius.circular(widget.borderRadius),
                            )
                          : BorderRadius.only(
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
                widget.clearSearchEnabled &&
                        _textEditingController.text.length > 0
                    ? Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: Align(
                          alignment: isLtr
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              if (_textEditingController.text.length == 0)
                                return;
                              setState(() {
                                _textEditingController.clear();
                                widget.onSearchClear();
                                isItemClicked = true;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.highlight_remove,
                                size: 27,
                                color: _textEditingController.text.length == 0
                                    ? Colors.grey[300]
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          if (!isItemClicked && widget.showListOfResults)
            Container(
              height: results.length * widget.singleItemHeight,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      String value = results[index];
                      widget.onItemTap(widget.data.indexOf(value), value);
                      _textEditingController.text = value;
                      _textEditingController.selection =
                          TextSelection.fromPosition(
                        TextPosition(
                          offset: value.length,
                        ),
                      );
                      setState(() {
                        isItemClicked = true;
                      });
                    },
                    child: Container(
                      height: widget.singleItemHeight,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: widget.searchResultsBgColor,
                        border: Border.all(color: widget.borderColor),
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
                      child: _getRichText(results[index]),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void onSearchTextChanges() {
    if (_textEditingController.text.length < widget.minLettersForSearch) {
      setState(() {
        results = [];
      });
    } else {
      String searchText = widget.caseSensitive
          ? _textEditingController.text
          : _textEditingController.text.toLowerCase();
      switch (widget.searchMode) {
        case SearchMode.STARTING_WITH:
          setState(() {
            results = widget.data
                .where(
                  (element) =>
                      (widget.caseSensitive ? element : element.toLowerCase())
                          .startsWith(searchText),
                )
                .toList();
          });
          break;
        case SearchMode.CONTAINS:
          setState(() {
            results = widget.data
                .where(
                  (element) =>
                      (widget.caseSensitive ? element : element.toLowerCase())
                          .contains(searchText),
                )
                .toList();
          });
          break;
        case SearchMode.EXACT_MATCH:
          setState(() {
            results = widget.data
                .where(
                  (element) =>
                      (widget.caseSensitive
                          ? element
                          : element.toLowerCase()) ==
                      searchText,
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
    // now send the latest updates
    if (widget.onEditingProgress != null) {
      widget.onEditingProgress(_textEditingController.text, results);
    }
  }

  void sendSubmitResults(value) {
    try {
      if (lastSubmittedText == value) {
        return; // Nothing new to Submit
      }
      lastSubmittedText = value;
      setState(() {
        isItemClicked = true;
      });
      if (lastSubmittedText == "")
        widget.onSearchClear();
      else
        widget.onSubmitted(lastSubmittedText, results);
      setState(() {
        results = [];
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

enum SearchMode {
  STARTING_WITH,
  CONTAINS,
  EXACT_MATCH,
}
