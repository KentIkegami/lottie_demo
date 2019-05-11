

import Foundation

////////////////////////////////////////////////////////////
//Input                                                   //
////////////////////////////////////////////////////////////
typealias Input = Request

typealias Request = (
    // リクエストの向き先の URL
    url: URL,
    // クエリ文字列
    queries: [URLQueryItem],
    // HTTP ヘッダー。ヘッダー名と値の辞書
    headers: [String:String],
    // HTTP メソッドとペイロードの組み合わせ
    // GET にはペイロードがなく、PUT や POST にはペイロードがあることを 表現するために、後述する enum を使っている
    methodAndPayload: HTTPMethodAndPayload
)

enum HTTPMethodAndPayload {
    
    case get
    case post(payload: Data?)
    
    // メソッドの文字列表現
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
    
    // ペイロード。ペイロードがないメソッドの場合は nil。
    var body: Data? {
        switch self {
        case .get:
            return nil
        case .post(let data):
            return data
        }
    }
}

enum WebAPI {
    // コールバックつきの call 関数を用意する。
    // コールバック関数に与えられる引数は、Output 型（レスポンスか通信エラーのどちらか）。
    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
        // URLSession へ渡す URLRequest を作成する。
        let urlRequest = self.createURLRequest(by: input)
        
        // レスポンス受信後のコールバックを登録する。
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            // 受信したレスポンスまたは通信エラーを Output オブジェクトへ変換する。
            let output = self.createOutput(
                data: data,
                urlResponse: urlResponse as? HTTPURLResponse,
                error: error
            )
            
            // コールバックに Output オブジェクトを渡す。
            block(output)
        }
        task.resume()
    }
    
    static func call(with input: Input) {
        self.call(with: input) { _ in
            // NOTE: コールバックでは何もしない
        }
    }
    
    // Input から URLRequest を作成する関数。
    static private func createURLRequest(by input: Input) -> URLRequest {
        // URL から URLRequeast を作成する。
        var request = URLRequest(url: input.url)
        
        // HTTP メソッドを設定する。
        request.httpMethod = input.methodAndPayload.method
        
        // リクエストの本文を設定する。
        request.httpBody = input.methodAndPayload.body
        
        // HTTP ヘッダを設定する。
        request.allHTTPHeaderFields = input.headers
        
        //キャッシュを設定する。
        request.cachePolicy = .reloadIgnoringLocalCacheData //キャッシュを使わない設定
        
        return request
    }
    
    // URLSession.dataTask のコールバック引数から Output オブジェクトを作成する関数。
    static private func createOutput(
        data: Data?,
        urlResponse: HTTPURLResponse?,
        error: Error?
        ) -> Output {
        // データと URLResponse がなければ通信エラー。
        guard let data = data, let response = urlResponse else {
            // エラーの内容を debugInfo に格納して通信エラーを返す。
            return .noResponse(.noDataOrNoResponse(debugInfo: error.debugDescription))
        }
        
        // HTTP ヘッダーを URLResponse から取り出して Output 型の
        // HTTP ヘッダーの型 [String: String] と一致するように変換する。
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields.enumerated() {
            headers[key.description] = String(describing: value)
        }
        
        // Output オブジェクトを作成して返す。
        return .hasResponse((
            // HTTP ステータスコードから HTTPStatus を作成する。
            statusCode: .from(code: response.statusCode),
            
            // 変換後の HTTP ヘッダーを返す。
            headers: headers,
            
            // レスポンスの本文をそのまま返す。
            payload: data
        ))
    }
}


////////////////////////////////////////////////////////////
//Output                                                  //
////////////////////////////////////////////////////////////

enum Output {
    case hasResponse(Response)
    case noResponse(ConnectionError)
}

/// 通信エラー
enum ConnectionError {
    case noDataOrNoResponse(debugInfo: String)    /// データまたはレスポンスが存在しない場合のエラー。
    case malformedURL(debugInfo: String)    /// 不正な URL の場合のエラー。
    case dontVPN(debugInfo: String)    /// VPNじゃない場合のエラー
}

///変換エラー
enum TransformError {
    case unexpectedStatusCode(debugInfo: String)/// HTTP ステータスコードが OK 以外だった場合のエラー。
    case malformedData(debugInfo: String)/// ペイロードが壊れた文字列だった場合のエラー。
}

typealias Response = (
    // レスポンスの意味をあらわすステータスコード。
    statusCode: HTTPStatus,
    // HTTP ヘッダー。
    headers: [String: String],
    // レスポンスの本文。
    payload: Data
)


/// HTTPステータスコードを読みやすくする型。
enum HTTPStatus {
    
    case ok
    case notFound
    case unsupported(code: Int)
    
    // HTTP ステータスコードから HTTPステータス型を作る関数。
    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            return .ok
        case 404:
            return .notFound
        default:
            return .unsupported(code: code)
        }
    }
}
