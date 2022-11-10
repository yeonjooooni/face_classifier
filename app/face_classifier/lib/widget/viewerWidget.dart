import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';


class ViewerWidget extends StatefulWidget{
    ViewerWidget({Key? key, required this.loadedImgs, required this.size, required this.printnum}): super(key: key);
    List<XFile> loadedImgs;
    double size;
    double printnum;

    @override
    State<ViewerWidget> createState() => _ViewerState();
}

class _ViewerState extends State<ViewerWidget>{

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width : widget.size * widget.printnum,
            height : widget.size,
            child : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: widget.loadedImgs.isNotEmpty?
                SizedBox(
                    width: widget.size * widget.loadedImgs.length,
                    height : widget.size,
                    child: GridView.count(
                        padding: const EdgeInsets.all(2),
                        crossAxisCount: widget.loadedImgs.length,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        children: List.generate(
                            widget.loadedImgs.length,
                                (index) => DottedBorder(
                                color: Colors.grey,
                                dashPattern: const [5, 3],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                            kIsWeb
                                                ? NetworkImage(widget.loadedImgs[index].path)
                                                : FileImage(File(widget.loadedImgs[index].path)) as ImageProvider
                                            )
                                        )
                                    ),
                                )
                            )
                    )
                )
                : Container(
                    alignment: Alignment.center,
                    width: widget.size * widget.printnum,
                    height: widget.size,
                    child: const Text('없어요..')
                )
            )
        );
    }
}