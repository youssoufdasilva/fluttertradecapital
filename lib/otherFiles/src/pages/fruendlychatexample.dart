//// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
//// for details. All rights reserved. Use of this source code is governed by a
//// BSD-style license that can be found in the LICENSE file.
//
//part of tradecapital;
//
//
//final ThemeData kIOSTheme = new ThemeData(
//  primarySwatch: Colors.orange,
//  primaryColor: Colors.grey[100],
//  primaryColorBrightness: Brightness.light,
//);
//
//final ThemeData kDefaultTheme = new ThemeData(
//  primarySwatch: Colors.purple,
//  accentColor: Colors.orangeAccent[400],
//);
//
//final googleSignIn = new GoogleSignIn();
//final analytics = new FirebaseAnalytics();
//final auth = FirebaseAuth.instance;
//final reference = FirebaseDatabase.instance.reference().child('messages');
//
//void main() {
//  runApp(new FriendlychatApp());
//}
//
//Future<Null> _ensureLoggedIn() async {
//  GoogleSignInAccount user = googleSignIn.currentUser;
//  if (user == null)
//    user = await googleSignIn.signInSilently();
//  if (user == null) {
//    user = await googleSignIn.signIn();
//    analytics.logLogin();
//  }
//  if (await auth.currentUser() == null) {
//    GoogleSignInAuthentication credentials =
//    await googleSignIn.currentUser.authentication;
//    await auth.signInWithGoogle(
//      idToken: credentials.idToken,
//      accessToken: credentials.accessToken,
//    );
//  }
//}
//
//class FriendlychatApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: "Friendlychat",
//      theme: defaultTargetPlatform == TargetPlatform.iOS
//          ? kIOSTheme
//          : kDefaultTheme,
//      home: new ChatScreen(),
//    );
//  }
//}
//
//@override
//class ChatMessage extends StatelessWidget {
//  ChatMessage({this.snapshot, this.animation});
//  final DataSnapshot snapshot;
//  final Animation animation;
//
//  Widget build(BuildContext context) {
//    return new SizeTransition(
//      sizeFactor: new CurvedAnimation(
//          parent: animation, curve: Curves.easeOut),
//      axisAlignment: 0.0,
//      child: new Container(
//        margin: const EdgeInsets.symmetric(vertical: 10.0),
//        child: new Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            new Container(
//              margin: const EdgeInsets.only(right: 16.0),
//              child: new CircleAvatar(backgroundImage: new NetworkImage(snapshot.value['senderPhotoUrl'])),
//            ),
//            new Expanded(
//              child: new Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  new Text(
//                      snapshot.value['senderName'],
//                      style: Theme.of(context).textTheme.subhead),
//                  new Container(
//                    margin: const EdgeInsets.only(top: 5.0),
//                    child: snapshot.value['imageUrl'] != null ?
//                    new Image.network(
//                      snapshot.value['imageUrl'],
//                      width: 250.0,
//                    ) :
//                    new Text(snapshot.value['text']),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class ChatScreen extends StatefulWidget {
//  @override
//  State createState() => new ChatScreenState();
//}
//
//class ChatScreenState extends State<ChatScreen> {
//  final TextEditingController _textController = new TextEditingController();
//  bool _isComposing = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("Friendlychat"),
//          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
//        ),
//        body: new Column(children: <Widget>[
//          new Flexible(
//            child: new FirebaseAnimatedList(
//              query: reference,
//              sort: (DataSnapshot a, DataSnapshot b) =>
//                  b.key.compareTo(a.key),
//              padding: new EdgeInsets.all(8.0),
//              reverse: true,
//              itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                  Animation<double> animation, int index) {
//                return new ChatMessage(snapshot: snapshot, animation: animation);
//              },
//            ),
//          ),
//          new Divider(height: 1.0),
//          new Container(
//            decoration:
//            new BoxDecoration(color: Theme.of(context).cardColor),
//            child: _buildTextComposer(),
//          ),
//        ]));
//  }
//
//  Widget _buildTextComposer() {
//    return new IconTheme(
//      data: new IconThemeData(color: Theme.of(context).accentColor),
//      child: new Container(
//          margin: const EdgeInsets.symmetric(horizontal: 8.0),
//          child: new Row(children: <Widget>[
//            new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 4.0),
//              child: new IconButton(
//                  icon: new Icon(Icons.photo_camera),
//                  onPressed: () async {
//                    await _ensureLoggedIn();
//                    File imageFile = await ImagePicker.pickImage();
//                    int random = new Random().nextInt(100000);
//                    StorageReference ref =
//                    FirebaseStorage.instance.ref().child("image_$random.jpg");
//                    StorageUploadTask uploadTask = ref.put(imageFile);
//                    Uri downloadUrl = (await uploadTask.future).downloadUrl;
//                    _sendMessage(imageUrl: downloadUrl.toString());
//                  }
//              ),
//            ),
//            new Flexible(
//              child: new TextField(
//                controller: _textController,
//                onChanged: (String text) {
//                  setState(() {
//                    _isComposing = text.length > 0;
//                  });
//                },
//                onSubmitted: _handleSubmitted,
//                decoration:
//                new InputDecoration.collapsed(hintText: "Send a message"),
//              ),
//            ),
//            new Container(
//                margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                child: Theme.of(context).platform == TargetPlatform.iOS
//                    ? new CupertinoButton(
//                  child: new Text("Send"),
//                  onPressed: _isComposing
//                      ? () => _handleSubmitted(_textController.text)
//                      : null,
//                )
//                    : new IconButton(
//                  icon: new Icon(Icons.send),
//                  onPressed: _isComposing
//                      ? () => _handleSubmitted(_textController.text)
//                      : null,
//                )),
//          ]),
//          decoration: Theme.of(context).platform == TargetPlatform.iOS
//              ? new BoxDecoration(
//              border:
//              new Border(top: new BorderSide(color: Colors.grey[200])))
//              : null),
//    );
//  }
//
//  Future<Null> _handleSubmitted(String text) async {
//    _textController.clear();
//    setState(() {
//      _isComposing = false;
//    });
//    await _ensureLoggedIn();
//    _sendMessage(text: text);
//  }
//
//  void _sendMessage({ String text, String imageUrl }) {
//    reference.push().set({
//      'text': text,
//      'imageUrl': imageUrl,
//      'senderName': googleSignIn.currentUser.displayName,
//      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
//    });
//    analytics.logEvent(name: 'send_message');
//  }
//
//}
