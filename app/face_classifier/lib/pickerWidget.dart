import 'uploadScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';


class PickerWidget extends StatefulWidget{
    PickerWidget({Key? key}): super(key: key);
    List<XFile> pickedImgs = [];

    bool imgEmpty(){
        return pickedImgs.isEmpty;
    }

    void uploadImage() async{
        Dio dio = Dio();
        dio.options.headers["authorization"] = "Access_Token";
        final List<MultipartFile> files = pickedImgs.map((img) => MultipartFile.fromFileSync(img.path,  contentType: MediaType("image", "jpg"))).toList();
        FormData formData = FormData.fromMap({"key": files});
        dio.options.contentType = 'multipart/form-data';
        try {
            final res = await dio.post("/image", data: formData);
            if(res.statusCode == 200){
                // ok
            } else {
                // error
                return;
            }
        } catch (e) {
            Exception(e);
        } finally {
            dio.close();
        }
    }

    @override
    State<PickerWidget> createState() => _PickerState();
}

class _PickerState extends State<PickerWidget>{

    final ImagePicker _picker = ImagePicker();
    List<Widget> boxContents = [];

    Future<void> _pickImg(ImgUploaderState? parent) async {
        final List<XFile> images = await _picker.pickMultiImage();
        parent?.setState(() {
            setState(() {
                widget.pickedImgs = images;
            });
        });
    }

    @override
    Widget build(BuildContext context) {
        ImgUploaderState? parent = context.findAncestorStateOfType();
        boxContents = [
            CupertinoButton(
                onPressed: () {
                  _pickImg(parent);
                },
                child: Container(
                    padding: const EdgeInsets.all(6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle),
                    child: Icon(
                        CupertinoIcons.camera,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary
                    )
                )),
            Container(),
            Container(),
            widget.pickedImgs.length <= 4
                  ? Container()
                  : FittedBox(
              child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle),
                  child: Text(
                    '+${(widget.pickedImgs.length - 4).toString()}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  )
              ),
          )
        ];
        return SizedBox(
            width: 400,
            height: 100,
            child: GridView.count(
                padding: const EdgeInsets.all(2),
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: List.generate(
                    4,
                        (index) => DottedBorder(
                        color: Colors.grey,
                        dashPattern: const [5, 3],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        child: Container(
                            decoration: index <= widget.pickedImgs.length - 1
                                ? BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                    kIsWeb
                                        ? NetworkImage(widget.pickedImgs[index].path)
                                        : FileImage(File(widget.pickedImgs[index].path)) as ImageProvider
                                )
                            )
                                : null,
                            child: Center(child: boxContents[index]),
                        ),
                    )
                )
            )
        );
    }
}