

import UIKit

class FileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var playViewController: PlayViewController!
    
    private var _tableView: UITableView!
    private var lottieFiles:[LottieFile]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1.0)
        
        //タイトル
        title = "LottieFile List"
        //キャンセルボタン追加
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.onTapCancel(sender:)))
        cancelButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
        
        //データ取得
        self.lottieFiles = getLottieFiles()
        // TableView
        _tableView = UITableView(frame: CGRect(x: 0,
                                               y: UIApplication.shared.statusBarFrame.size.height,
                                               width: self.view.frame.width,
                                               height: self.view.frame.height-UIApplication.shared.statusBarFrame.size.height))
        _tableView.register(UITableViewCell.self,
                            forCellReuseIdentifier: "Cell")
        _tableView.dataSource = self//データソースの設定
        _tableView.delegate = self
        _tableView.tableFooterView = UIView(frame: .zero)
        _tableView.rowHeight = 50
        _tableView.separatorInset = .init(top: 0, left: 30, bottom: 0, right: 10)//線
        self.view.addSubview(_tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //データ取得
        self.lottieFiles = getLottieFiles()
        self._tableView.reloadData()
    }
    
    //戻る
    @objc internal func onTapCancel(sender: UIButton){
        self.dismiss(animated: true, completion: {
            self.playViewController.reloadView()
        })
    }
    
    //ドキュメントファイル取得
    private func getLottieFiles()->[LottieFile]{
        var lottieFiles:[LottieFile] = []
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            var contentUrls = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil)
            contentUrls = contentUrls.filter{ $0.absoluteString.contains(".json") }
            for contentUrl in contentUrls {
                let lottieFile = LottieFile()
                lottieFile.filename = contentUrl.lastPathComponent
                lottieFile.json = try! String(contentsOf: contentUrl, encoding: .utf8)
                lottieFiles.append(lottieFile)
            }
        } catch {
            print(error)
        }
        return lottieFiles
    }
    
    /*-------------------------------------------------------------------------
     TableCell
     -------------------------------------------------------------------------*/
    /*Cellの総数を返す*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lottieFiles.count
    }
    /*Cellに値を設定する*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? // nilになることがあるので、Optionalで宣言
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath as IndexPath)// 再利用するCellを取得する.
        }
        cell?.accessoryType = .disclosureIndicator //右側の >
        cell?.textLabel!.text = lottieFiles[indexPath.row].filename
        cell?.textLabel?.numberOfLines = 0
        //cell?.detailTextLabel?.text = "POSコード: " + historys[indexPath.row].ean13code
        
        return cell!
    }
    /*Cellが選択された際に呼び出される*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(lottieFiles[indexPath.row].filename, forKey: "filename")
        self.dismiss(animated: true, completion: {self.playViewController.reloadView()})
        
        //cellの選択解除
        if let indexPathForSelectedRow = _tableView.indexPathForSelectedRow {
            _tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    
//    /*スワイプ削除アクション*/
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            //
//            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            try? FileManager.default.removeItem(at: documentDirectoryURL.appendingPathComponent( lottieFiles[indexPath.row].filename ))
//            self.lottieFiles.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .left)
//        }
//    }
    
    /*-------------------------------------------------------------------------
     tabelView スワイプメソッド
     -------------------------------------------------------------------------*/
    // trueを返すことでCellのアクションを許可しています
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action1 =  UIContextualAction(style: .normal, title: "Share", handler: { (action:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //共有処理
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentDirectoryURL.appendingPathComponent( self.lottieFiles[indexPath.row].filename )
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activity, animated: true, completion: nil)
            
            success(true)
        })
        action1.backgroundColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        
        let confrigation = UISwipeActionsConfiguration(actions: [action1])
        confrigation.performsFirstActionWithFullSwipe = false
        return confrigation
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action1 =  UIContextualAction(style: .destructive, title: "Delete", handler: { (action:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //削除処理
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            try? FileManager.default.removeItem(at: documentDirectoryURL.appendingPathComponent( self.lottieFiles[indexPath.row].filename ))
            self.lottieFiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            success(true)
        })
        action1.backgroundColor = UIColor.red
        let confrigation = UISwipeActionsConfiguration(actions: [action1])
        return confrigation
    }


}

