//
//  AddViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import UIKit
import Firebase
import FirebaseAuth


class AddViewController: UIViewController {

    private let cellid = "cellid"
   
    var enterRoom: String!
    var roomNumber: String!
    var roomEnterNum: String!
    var enterArray = [Rooms]()
    var enterUserName = [Rooms]()
    var enterNameCopy = [Rooms]()
    var enterNumArray = [Rooms]()
    var roomsArray = [Rooms]()
    var EnterUser: String!
    var enterFlag: Int = 0
    var iconArray = [Int]()
    var num: Int = 0
    var flag: Int = 0
    
    
    @IBOutlet weak var addTableView: UITableView!
    
    @IBOutlet weak var enterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTableView.delegate = self
        addTableView.dataSource = self

        //addTableView.backgroundColor = UIColor.white
        
        self.navigationItem.title = enterRoom
      
        let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
        //let Room = Firestore.firestore().collection("room")
        
        self.enterArray = [Rooms]()
        self.roomsArray = [Rooms]()
        
        Firestore.firestore().collection("room").getDocuments{ (snapshots, err) in
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
               // let dic = snapshot.data()
                let room = Rooms(document: snapshot)
                self.roomsArray.append(room)
                print("ICON:\(room.iconNameArray)")
            })
        }
        
        //enterArrayに(部屋に入室しているユーザーの情報)を格納
        RoomData.getDocuments{ (snapshots, err) in
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let room = Rooms(document: snapshot)
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    if uid == room.enterUser{
                        self.enterArray.insert(room, at: 0)
                    }
                    else{
                        self.enterArray.append(room) //ユーザを追加
                    }
                }
                //self.enterArray.append(room) //ユーザを追加
            })
            DispatchQueue.main.async {
                self.addTableView.reloadData() //TableViewの更新
            }
            //部屋の詳細画面に遷移した時にを入室・退室ボタンを表示する
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                for data in self.enterArray{ //入室している部屋の中にユーザーがいるかどうか確認
                    if data.enterUser == uid{ //もし, ユーザーが入室していたら
                        //self.enterButton.title = "退出" //退出ボタンを表示
                        //self.enterButton.barButtonSystemItem =
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onClickEnterButton))
                        break
                    }
                    else{ //ユーザが退出していたら
                        //self.enterButton.title = "入室" //入室ボタンを表示
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.checkmark"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onClickEnterButton))
                        //break
                    }
                    //print("配列:\(self.enterArray)")
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

        
    }
    
    @objc func enterAction() {
           print("Push searchButton")
       }
    
    @IBAction func onClickEnterButton() {
        print("押された！")
        var enterTimer: Timer!
        let enterTime: NSDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var iconName: String!
        let user = Auth.auth().currentUser
        if let user = user {//もし, ユーザー本人だったらFireStoreの部屋にユーザーを追加
            
            let uid = user.uid //ユーザーのID
            let userName = user.displayName
            for num in userName! {
                //print("数字:\(num)")
                iconName = String(num) //ユーザ名の頭文字を代入
                break
            }
            //print("ユーザー名：\(userName)")
            let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
            let Room = Firestore.firestore().collection("room")
            //もし, 部屋に誰もいなかったら
            if enterArray.isEmpty == true{
                self.enterArray = [Rooms]()
                //新しい部屋に入室したら, 前いた部屋からユーザーを消去
                for roomData in roomsArray{ //roomsArray(部屋が格納されてる), 各部屋にユーザーがいるかチェック
                    for name in roomData.iconNameArray{ //部屋に入室しているユーザーの中から
                        if name == iconName{ //本人の名前があったら(本人が入室していたら)
                            print("消去") //その部屋からユーザーを消去
                            
                            Room.document(roomData.roomName).collection("enterUser").document(uid).delete() { err in //FireStoreの部屋からユーザー本人を消去
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else { //消去に成功
                                    print("FireStore消去")
                                    Firestore.firestore().collection("room").document(roomData.roomName).updateData(["iconNameArray": FieldValue.arrayRemove([iconName])])
                                    Firestore.firestore().collection("room").document(roomData.roomName).updateData(["roomEnterNum": String(Int(roomData.roomEnterNum)! - 1)])
                                    //部屋にいるユーザーをenterArrayに格納し直し, TableViewを更新
                                    //self.EnterArray1(name: roomData.roomName)
                                }
                            }
                        }
                    }
                }
                
                //10s後に処理する
                Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
                
                //通知機能
                self.message(enter: enterTime)
                //新しく入る部屋にユーザーを追加
                RoomData.document(uid).setData(["enterUserID": uid, "enterUserName": userName, "iconName": iconName, "enterTime": formatter.string(from: enterTime as Date)]){ err in //FireStoreにユーザー本人を追加(入室)
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("入室")
                        //self.enterButton.title = "退出"
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onClickEnterButton))
                        //頭文字を追加
                        Firestore.firestore().collection("room").document(self.enterRoom).updateData(["iconNameArray": FieldValue.arrayUnion([iconName])])
                        //部屋にいるユーザーをenterArrayに格納し直し, TableViewを更新
                        self.EnterArray()
                        //通知機能
                        //self.message(enter: enterTime)
                    }
                }
            }
            
            //部屋に入室しているユーザーの中に本人がいるかどうか確認
            for data in enterArray{ //enterArray(部屋に入室しているユーザー)
                //print("配列：\(enterArray)")
                if data.enterUser == uid{ //部屋に本人のidがあったら消去
                    print("消去")
                    alert1()
                    //通知の解除
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["CalendarNotification"])
                    RoomData.document(uid).delete() { err in //FireStoreの部屋からユーザー本人を消去
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else { //消去に成功
                            print("FireStore消去")
                            //self.enterButton.title = "入室"
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.checkmark"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onClickEnterButton))
                            //部屋にいるユーザーをenterArrayに格納し直し, TableViewを更新
                            self.EnterArray()
                        }
                    }
                    //print("数字:\(iconName)")
                    Firestore.firestore().collection("room").document(enterRoom).updateData(["iconNameArray": FieldValue.arrayRemove([iconName])])
                    break
                }
                else{ //部屋に本人のidがなかったらidを追加
                    //self.EnterArray()
                    print("RN:\(roomNumber)")
                    print("EN:\(roomEnterNum)")
                    print("CN:\(enterArray.count)")
                    //定員人数を達して入室ボタンを押すと警告を表示
                    if Int(roomNumber) == enterArray.count {
                        print("一緒")
                        let alert: UIAlertController = UIAlertController(title:"警告", message: "定員人数を達しています", preferredStyle: .alert)
                        
                        //OKボタン
                        alert.addAction(
                            UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: {action in
                                    //self.navigationController?.popViewController(animated: true) //ボタンが押された時の動作
                                    print("OKボタンが押されました！")
                                })
                        )
                        present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        //新しい部屋に入室したら, 前いた部屋からユーザーを消去
                        for roomData in roomsArray{ //roomsArray(部屋が格納されてる), 各部屋にユーザーがいるかチェック
                            for name in roomData.iconNameArray{ //部屋に入室しているユーザーの中から
                                if name == iconName{ //本人の名前があったら(本人が入室していたら)
                                    print("ELSE消去") //その部屋からユーザーを消去
                                    Room.document(roomData.roomName).collection("enterUser").document(uid).delete() { err in //FireStoreの部屋からユーザー本人を消去
                                        if let err = err {
                                            print("Error removing document: \(err)")
                                        } else { //消去に成功
                                            print("FireStore消去")
                                            Firestore.firestore().collection("room").document(roomData.roomName).updateData(["iconNameArray": FieldValue.arrayRemove([iconName])])
                                            
                                            Firestore.firestore().collection("room").document(roomData.roomName).updateData(["roomEnterNum": String(Int(roomData.roomEnterNum)! - 1)])
                                            //部屋にいるユーザーをenterArrayに格納し直し, TableViewを更新
                                        }
                                    }
                                }
                            }
                        }
                        //10s後に処理
                        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
                        
                        //新しく入る部屋にユーザーを追加
                        RoomData.document(uid).setData(["enterUserID": uid, "enterUserName": userName, "iconName": iconName, "enterTime": formatter.string(from: enterTime as Date)]){ err in //Firestoreの部屋にユーザー本人を追加
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("FireStore追加")
                                //self.enterButton.title = "退出"
                                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onClickEnterButton))
                            
                               Firestore.firestore().collection("room").document(self.enterRoom).updateData(["iconNameArray": FieldValue.arrayUnion([iconName])])
                                //部屋にいるユーザーをenterArrayに格納し直し, TableViewに反映
                                self.EnterArray()
                            }
                        }
                        //通知機能
                        self.message(enter: enterTime)
                        //Firestore.firestore().collection("room").document(enterRoom).updateData(["iconNameArray": FieldValue.arrayUnion([iconName])])
                    }
                    //break
                }
            }//for文終わり
            
        }//if文終わり
        
    }
    
    //enterArrayに(部屋に入室しているユーザー)を格納、TableViewの更新
    func EnterArray(){
        
        let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
        RoomData.getDocuments{ (snapshots, err) in
            self.enterArray = [Rooms]()
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let room = Rooms(document: snapshot)
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    if uid == room.enterUser{
                        self.enterArray.insert(room, at: 0)
                    }
                    else{
                        self.enterArray.append(room) //ユーザを追加
                    }
                }
                //self.enterArray.append(room)
                //print("名前：\(room.enterName)")
            })
            DispatchQueue.main.async {
                self.addTableView.reloadData() //TableViewの更新
            }
        }
    }

    func alert1(){
        let alert: UIAlertController = UIAlertController(title:"お疲れ様！！", message: "ゆっくり休んで、良い夢見てね〜〜！", preferredStyle: .alert)
        //OKボタン
        alert.addAction(
            UIAlertAction(
                title: "うん！",
                style: .default,
                handler: {action in
                    //self.navigationController?.popViewController(animated: true) //ボタンが押された時の動作
                    print("OKボタンが押されました！")
                })
        )
        present(alert, animated: true, completion: nil)
    }
    
    @objc func timerUpdate(){
        print("time時間だよ！")
    }
    
    func message(enter: NSDate){
        print("通知")
        let date2 = Date(timeInterval: 3600 * 8, since: enter as Date)
        // 年月日時分秒をそれぞれまとめて取得
        let targetDate = Calendar.current.dateComponents([.hour, .minute, .second], from: date2)
        // トリガーの作成
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
        // 通知コンテンツの作成
        let content = UNMutableNotificationContent()
        content.title = "滞在時間が８時間を超えたよ！"
        content.body = "過労には注意！しっかり休憩をとってね！！"
        content.sound = UNNotificationSound.default
         
        // 通知リクエストの作成
        let request = UNNotificationRequest.init(
                        identifier: "CalendarNotification",
                        content: content,
                        trigger: trigger)
        
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}


extension AddViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        Firestore.firestore().collection("room").document(enterRoom).updateData(["roomEnterNum": String(enterArray.count)])
     
        return enterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! AddCustomTableViewCell
        var icon: String!
        var iconName: String!
        
        cell.backgroundColor = UIColor.init(red: 0.933, green: 0.941, blue: 0.984, alpha: 1)
        addTableView.backgroundColor = UIColor.init(red: 0.933, green: 0.941, blue: 0.984, alpha: 1)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:"
        cell.timeLabel.text  = "入室　" + enterArray[indexPath.row].enterTime//formatter.string(from: NSDate() as Date)
        cell.timeLabel.textColor = UIColor.darkGray
        
        switch indexPath.row{
        case 0:
            print("orange")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.972, green: 0.792, blue: 0.6, alpha: 0.6)
        case 1:
            print("green")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.749, green: 0.972, blue: 0.58, alpha: 0.6)
        case 2:
            print("blue")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.737, green: 0.972, blue: 0.956, alpha: 0.6)
        case 3:
            print("pink")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.945, green: 0.803, blue: 0.972, alpha: 0.6)
        case 4:
            print("yellow")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.972, green: 0.937, blue: 0.545, alpha: 0.6)
        case 5:
            print("green")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.749, green: 0.972, blue: 0.58, alpha: 0.6)
        case 6:
            print("orange")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.972, green: 0.792, blue: 0.6, alpha: 0.6)
        case 7:
            print("yellow")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.972, green: 0.937, blue: 0.545, alpha: 0.6)
        case 8:
            print("blue")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.737, green: 0.972, blue: 0.956, alpha: 0.6)
        case 9:
            print("pink")
            cell.nameIconLabel.backgroundColor = UIColor(red: 0.945, green: 0.803, blue: 0.972, alpha: 0.6)
        default:
            print("その他")
            cell.nameIconLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        }
    
        icon = enterArray[indexPath.row].enterName //ユーザー名
        for num in icon {
            //print(num)
            iconName = String(num) //ユーザ名の頭文字を代入
            break
        }
        // セルに値を設定
        cell.nameLabel.text = enterArray[indexPath.row].enterName
        cell.nameIconLabel.text = iconName //頭文字を表示
       
        
        //頭文字をFireStoreに保存
        //Firestore.firestore().collection("room").document(enterRoom).collection("enterUser").document(enterArray[indexPath.row].enterUser).updateData(["iconName": iconName])
        
       // Firestore.firestore().collection("room").document(enterRoom).updateData(["iconNameArray": FieldValue.arrayUnion([iconName])])
        
        return cell
    }
    
    //セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           // performSegue(withIdentifier: "toAdd", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier=="toHome") {
                let vcHome = segue.destination as! HomeViewController;
                
                //iconArray = [Int]()
                //iconArray.append(enterArray.count)
                //vcHome.num = enterArray.count
                vcHome.setupMethod();
            }
        }
}


