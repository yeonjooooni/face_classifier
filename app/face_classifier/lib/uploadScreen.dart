import 'package:flutter/cupertino.dart';
import 'pickerWidget.dart';
import 'resultScreen.dart';

class UploadScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return const CupertinoApp(
            title: 'Face Classifier',
            theme: CupertinoThemeData(brightness: Brightness.light),
            home: ImgUploader()
        );
    }
}

class ImgUploader extends StatefulWidget {
    const ImgUploader({Key ? key}) : super(key: key);

    @override
    State<ImgUploader> createState() => ImgUploaderState();
}

class ImgUploaderState extends State<ImgUploader> {
    int curstate = 0;

    PickerWidget picker = PickerWidget();
    PickerWidget pickerInd = PickerWidget();

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("Face Classifier"),
            ),
            child: Center(
                child: Column(
                    children: <Widget>[
                      Container(height: 50),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('분류할 사진 업로드'),
                            Container(height: 15),
                            picker,
                            Container(height: 10),
                            CupertinoButton.filled(
                                onPressed: !picker.imgEmpty() ?
                                    () {
                                  setState(() {
                                    curstate = 1 > curstate ? 1 : curstate;
                                  });
                                } :
                                null
                                ,
                                child: const Text("다음")
                            ),
                            Container(height: 30)
                          ]
                      )
                      ,
                      AnimatedContainer(
                          height: curstate >= 1 ? 210 : 0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                          child: SingleChildScrollView(
                            child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text('한 명씩 있는 사진 업로드'),
                                  Container(height: 15),
                                  pickerInd,
                                  Container(height: 10),
                                  CupertinoButton.filled(
                                      onPressed: !picker.imgEmpty() && !pickerInd.imgEmpty() ?
                                          () async {
                                        picker.uploadImage();
                                        pickerInd.uploadImage();
                                      }
                                          : null
                                      ,
                                      child: const Text("분류하기!")
                                  )
                                ]
                            ),
                          )
                      )
                    ]
                )
            ),
        );
    }
}
