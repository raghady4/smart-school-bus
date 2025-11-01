// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class CustomDropDown extends HookConsumerWidget {
//   const CustomDropDown(
//   {super.key,
//   required this.list,
//   required this.label,
//   required this.onChanged,
//   this.hintText,
//   this.value,
//   required this.selected,
//   required this.w,
//   required this.searchB,
//   });
//   final  bool searchB;
//   final String? selected;
//   final double w;
//   final List<DropdownMenuItem<String>>?  list;
//   final String label;
//   final String? hintText;
//   final ValueChanged<dynamic>? onChanged;
//   final  String? value;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     double h = MediaQuery.of(context).size.height;
//     double w = MediaQuery.of(context).size.width;
//     final isMounted = useIsMounted();

//     final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
//         final TextScaler textScaler = MediaQuery.of(context).textScaler;

//     final textEditingController = useTextEditingController();
//     // Define your common decoration for both the input field and the dropdown menu
//     final BoxDecoration commonDecoration = BoxDecoration(
//       borderRadius: BorderRadius.circular(10.0),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withValues(alpha:0.25), // Shadow color
//           spreadRadius: 0, // Spread radius
//           blurRadius: 2, // Blur radius
//           offset: const Offset(0, 1), // Offset of the shadow
//         ),
//       ],
//       color: Colors.grey, // Background color
//     );
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 0.065,
//       margin:  EdgeInsets.symmetric(
//         vertical: MediaQuery.of(context).size.height * 0.01,
//       ),

//       decoration: commonDecoration,

//       child: DropdownButtonFormField2<String>(
//         buttonStyleData:const ButtonStyleData(
//           padding: EdgeInsets.symmetric(horizontal: 0), // removes left and right padding
//         ),
//         // isExpanded: true,
//         hint: Text(
//             hintText!,
//             style: const TextStyle(
//                 fontSize:18.0  ,// w * 0.065,//0.08
//             ),
//              textScaler: textScaler, 
//           overflow: TextOverflow.ellipsis, // Add this line
//           // maxLines: 1,
//         ),
//         items: list,
//         value: value,
//         onChanged: onChanged,
//         dropdownStyleData:  DropdownStyleData(
//           maxHeight: MediaQuery.of(context).size.height * 0.5,
//          decoration: commonDecoration,
//       ),
//         selectedItemBuilder: (BuildContext context) {
//           return list!.map((DropdownMenuItem<dynamic> item) {
//             return Container(
//               // width: MediaQuery.of(context).size.width,
//               // width: w * 0.5,
//               alignment: Alignment.centerRight,
//               child: Text(
//                 selected ?? '', // Display the selected item's text
//                 style:const TextStyle(
                 
//                   fontSize: 18.0  ,//w * 0.07,// Change this to your desired color
//                 ),
//                  textScaler: textScaler, 
//                 overflow: TextOverflow.ellipsis, // Add this line
//                 maxLines: 1,
//               ),
//             );
//           }).toList();
//         },
//         // onMenuStateChange: (isOpen) {
//         //   if (!isOpen) {
//         //     textEditingController.clear();
//         //   }
//         // },
//         // --- ADD OR MODIFY THIS SECTION ---
//         onMenuStateChange: (isOpen) {
//           if (isOpen) {
//             // Dismiss the keyboard when the dropdown menu is about to open
//             FocusScope.of(context).unfocus();
//           } else {
//             // Clear the search controller when the menu closes
//            if (isMounted()) {
//       textEditingController.clear();
//     }
//           }
//         },
//         // ---------------------------------
//         dropdownSearchData:  searchB ?  DropdownSearchData(
//           searchController: textEditingController,
//           searchInnerWidgetHeight: MediaQuery.of(context).size.height * 0.2,
//           searchInnerWidget: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: TextFormField(
//               controller: textEditingController,
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 labelText: label,

//                 border:const OutlineInputBorder(),
//               ),

//             ),
//           ),
//           searchMatchFn: (item, searchValue) {
//             return (item.value?.toString() ?? "")
//                 .toLowerCase()
//                 .contains(searchValue.toLowerCase());
//           },
//         ): null,
//         decoration: InputDecoration(
//           border:InputBorder.none,
//         filled:true,
//           fillColor: Colors.transparent,
//           // fillColor: greyContainerColor,
//           labelText: label,
//           hintText: hintText,
//           hintStyle: TextStyle(
            
//             fontSize:18.0 / textScaleFactor ,// w * 0.035,// Change this to your desired color
//           ),
          
//           labelStyle: TextStyle(
        
//             fontSize:  w * 0.04,//w * 0.065,// Change this to your desired color
//           ),

//           contentPadding: EdgeInsets.only(right: w * 0.02, bottom: h * 0.015), // Add left and bottom padding
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           enabledBorder: InputBorder.none, // Remove default border
//           focusedBorder: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDropDown extends HookConsumerWidget {
  const CustomDropDown({
    super.key,
    required this.list,
    required this.label,
    required this.onChanged,
    this.hintText,
    this.value,
    required this.selected,
    required this.w,
  });

  final String? selected;
  final double w;
  final List<DropdownMenuItem<String>>? list;
  final String label;
  final String? hintText;
  final ValueChanged<dynamic>? onChanged;
  final String? value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final TextScaler textScaler = MediaQuery.of(context).textScaler;

    final BoxDecoration commonDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(64),
          spreadRadius: 0,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
      color: Colors.grey,
    );

    return Container(
      width: w,
      height: h * 0.065,
      margin: EdgeInsets.symmetric(vertical: h * 0.01),
      decoration: commonDecoration,
      child: DropdownButtonFormField2<String>(
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 0),
        ),
        hint: Text(
          hintText ?? '',
          style: const TextStyle(fontSize: 18.0),
          textScaler: textScaler,
          overflow: TextOverflow.ellipsis,
        ),
        items: list,
        value: value,
        onChanged: onChanged,
        dropdownStyleData: DropdownStyleData(
          maxHeight: h * 0.5,
          decoration: commonDecoration,
        ),
        selectedItemBuilder: (BuildContext context) {
          return list!.map((DropdownMenuItem<dynamic> item) {
            return Container(
              alignment: Alignment.centerRight,
              child: Text(
                selected ?? '',
                style: const TextStyle(fontSize: 18.0),
                textScaler: textScaler,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          labelText: label,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 18.0 / textScaleFactor),
          labelStyle: TextStyle(fontSize: w * 0.04),
          contentPadding: EdgeInsets.only(right: w * 0.02, bottom: h * 0.015),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}




