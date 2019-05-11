
import Foundation

struct GetJson:Codable {
    let Status: String
    let ShopName: String?
    
    //レスポンス -> Error or Login
    static func from(response: Response) -> Either<TransformError, GetJson> {
        switch response.statusCode {
        case .ok:
            do {
                let jsonDecoder = JSONDecoder()
                print(String(data: response.payload, encoding: .utf8)!)
                let login = try jsonDecoder.decode(GetJson.self, from: response.payload)
                return .right(login)
            }
            catch {
                return .left(.malformedData(debugInfo: "\(error)"))
            }
        default:
            return .left(.unexpectedStatusCode(
                debugInfo: "\(response.statusCode)")
            )
        }
    }
    
    // - 接続エラーの場合     → .left(.left(ConnectionEither))
    // - 変換エラーの場合     → .left(.right(TransformError))
    // - 正常に取得できた場合 → .right(response)
    static func fetch(
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, GetJson>) -> Void
        ) {

        let urlString = "https://logococo.club/json/001.json"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            block(.left(.left(.malformedURL(debugInfo: urlString))))
            return
        }
        
        let input: Input = (
            url: url,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                block(.left(.left(connectionError)))// 接続エラー
                
            case let .hasResponse(response):
                let errorOrLogin = GetJson.from(response: response)
                
                switch errorOrLogin {
                case let .left(error):
                    block(.left(.right(error)))
                    
                case let .right(GetJson):
                    block(.right(GetJson))
                }
            }
        }
    }
}
