
import Foundation

struct GetJson {
    //レスポンス -> Error or Login
    static func from(response: Response) -> Either<TransformError, String> {
        switch response.statusCode {
        case .ok:
            let json = String(data: response.payload, encoding: .utf8)!
            return .right(json)
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
        url: String,
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, String>) -> Void
        ) {

        let urlString = url
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
