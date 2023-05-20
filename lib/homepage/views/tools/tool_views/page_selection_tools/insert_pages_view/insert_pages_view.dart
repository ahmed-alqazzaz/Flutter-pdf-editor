import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../generics/app_bars/generic_app_bar.dart';

class InsertPagesView extends StatefulWidget {
  const InsertPagesView({super.key, required this.file});

  final PdfFile file;

  @override
  State<InsertPagesView> createState() => _InsertPagesViewState();
}

class _InsertPagesViewState extends State<InsertPagesView> {
  static const _title = 'Select Insertion Point';
  late final ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: const Text(
              _title,
              style: TextStyle(color: GenericHomePageAppBar.titleTextColor),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: widget.file.pages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final pages = snapshot.data!;
                  return ListView.separated(
                    controller: _controller,
                    itemCount: pages.length,
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: FloatingActionButton(
                          onPressed: () {},
                          elevation: 3,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      // TODO: implement a getter for the size
                      final page = pages[index + 1]!;
                      final pageSize = page.size;
                      final screenToPdfWidthRatio =
                          screenWidth / pageSize.width;
                      final height = pageSize.height * screenToPdfWidthRatio;
                      return SizedBox.fromSize(
                        size: Size(screenWidth, height),
                        child: Image.file(
                          File(page.path),
                          width: screenWidth,
                          height: height,
                        ),
                      );
                    },
                  );
                }
                return const LinearProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
