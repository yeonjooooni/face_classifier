import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'pickerWidget.dart';
import 'resultScreen.dart';
import 'package:dio/dio.dart';

class MainApp extends StatelessWidget {
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
            child: SafeArea(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                                              Dio dio = Dio();
                                              String id = '';

                                              try {
                                                  Response res = await dio.get('userid');
                                                  if (res.statusCode == 200) {
                                                      id = res.data;
                                                  }
                                              } catch (e) {
                                                  Exception(e);
                                              } finally {
                                                  dio.close();
                                              }

                                              picker.uploadImage('/$id/image');
                                              pickerInd.uploadImage('/$id/imageInd');

                                              List<List<int>> indexes = [[]];

                                              try {
                                                  Response res = await dio.get('$id/index');
                                                  if (res.statusCode == 200) {
                                                      indexes = res.data;
                                                  }
                                              } catch (e) {
                                                  Exception(e);
                                              } finally {
                                                  dio.close();
                                              }

                                              List<List<XFile>> images = List.generate(indexes.length,
                                                  (index) => picker.getImageAtIndex(indexes[index])
                                              );
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(builder: (context) => ResultReporter(loadedImgs: images, loadedImgsInd: pickerInd.pickedImgs))
                                              );
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
                )
            )
        );
    }
}
