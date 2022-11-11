import 'package:face_classifier/widget/viewerWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class ResultReporter extends StatefulWidget {
    ResultReporter({Key ? key, required this.loadedImgs, required this.loadedImgsInd}) : super(key: key);
    List<List<XFile>> loadedImgs;
    List<XFile> loadedImgsInd;

    @override
    State<ResultReporter> createState() => ResultReporterState();
}

class ResultReporterState extends State<ResultReporter> {

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
                middle: Text("Face Classifier"),
            ),
            child: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(
                            children: <Widget>[...
                                List.generate(
                                    widget.loadedImgs.length,
                                    (index) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                            Container(height: 20),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                    ViewerWidget(loadedImgs: List.generate(1, (index_) => widget.loadedImgsInd[index]), size : 80, printnum: 1),
                                                    Container(
                                                        width: 30,
                                                    ),
                                                    const Text('이 사람이 들어간 사진은')
                                                ]
                                            ),
                                            Container(height: 15),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                    ViewerWidget(loadedImgs: widget.loadedImgs[index], size : 80, printnum: kIsWeb?6:3.5),
                                                    Container(width: 15),
                                                    widget.loadedImgs[index].isNotEmpty ? SizedBox(height: 50,
                                                        width: 50,
                                                        child: CupertinoButton.filled(
                                                            padding: const EdgeInsets.all(0),
                                                            onPressed: kIsWeb
                                                                ?  (){
                                                                    Share.shareXFiles(widget.loadedImgs[index]);
                                                                    // download files ( web ) 다운로드 해야하지만 일단 share,,
                                                                }
                                                                : (){
                                                                    Share.shareXFiles(widget.loadedImgs[index]);
                                                                    // share files ( mobile )
                                                                }
                                                            ,
                                                            child: const Icon(CupertinoIcons.share,
                                                                color: Colors.white,
                                                                size: 24.0,
                                                            )
                                                        )
                                                    ) : Container()
                                                ]
                                            ),
                                            Container(height: 20),
                                            const SizedBox(
                                              width: 600,
                                              child: Divider( thickness: 2.0))
                                        ]
                                    )
                                ),
                                CupertinoButton.filled(
                                onPressed: (){
                                    Navigator.pop(context);
                                },
                                child: const Text('다시 하기!')
                                )
                            ]
                        )
                    )
                )
            )
        );
    }
}