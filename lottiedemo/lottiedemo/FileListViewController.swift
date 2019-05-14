

import UIKit

class FileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var _tableView: UITableView!
    private var lottieFiles:[LottieFile]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(COLOR.BASE, alpha: 1.0)
        
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
        //cell?.detailTextLabel?.text = "POSコード: " + historys[indexPath.row].ean13code
        
        return cell!
    }
    /*Cellが選択された際に呼び出される*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //cellの選択解除
        if let indexPathForSelectedRow = _tableView.indexPathForSelectedRow {
            _tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    
    /*スワイプ削除アクション*/
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            try? FileManager.default.removeItem(at: documentDirectoryURL.appendingPathComponent( lottieFiles[indexPath.row].filename ))
            self.lottieFiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    

}

