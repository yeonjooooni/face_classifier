import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'uploadScreen.dart';

class ResultScreen extends StatelessWidget {
    List<List<XFile>> _loadedImgs = [];

    @override
    Widget build(BuildContext context) {
        return CupertinoApp(
            title: 'Face Classifier',
            theme: CupertinoThemeData(brightness: Brightness.light),
            home: ResultReporter(loadedImgs : _loadedImgs)
        );
    }
}

class ResultReporter extends StatefulWidget {
    ResultReporter({Key ? key, required this.loadedImgs}) : super(key: key);
    List<List<XFile>> loadedImgs;

    @override
    State<ImgUploader> createState() => ImgUploaderState();
}

class ResultReporterState extends State<ResultReporter> {

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
                middle: Text("Face Classifier"),
            ),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            List.generate(
                                // viewerwidget
                            )
                        ]
                    );
                );
            )
        );
    }
}