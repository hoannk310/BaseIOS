//
//  NetworkManager.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/5/25.
//

import RxSwift

class NetworkManager {
    static let shared = NetworkManager()
    
//    func request<T: Decodable>(_ request: APIRequest) -> Observable<T> {
//        .create { observer in
//            guard let urlRequest =  request.asURLRequest() else {
//                observer.onError(APIError.invalidRequest)
//                return Disposables.create()
//            }
//            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//                if error != nil {
//                    observer.onError(APIError.unknown)
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    observer.onError(APIError.unknown)
//                    return
//                }
//                guard (200...299).contains(httpResponse.statusCode) else {
//                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
//                    observer.onError(APIError.serverError(httpResponse.statusCode, message))
//                    return
//                }
//                guard let data = data else {
//                    observer.onError(APIError.unknown)
//                    return
//                }
//                do {
//                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
//                    observer.onNext(decodedObject)
//                    observer.onCompleted()
//                } catch(let error) {
//                    observer.onError(APIError.decodingError(error))
//                }
//            }
//            task.resume()
//            return Disposables.create { task.cancel() }
//        }
//    }
    
    func request<T: Decodable>(_ request: APIRequest) -> Observable<T> {
        return self.makeRequest(request)
            .catch { error in
                if let apiError = error as? APIError, apiError == .unauthorized {
                    return TokenManager.shared.refreshAccessToken()
                        .flatMap {[weak self] _ in
                            guard let self = self else { return Observable<T>.empty() }
                            return self.makeRequest(request)
                        }
                }
                return Observable.error(error)
            }
    }
       
       private func makeRequest<T: Decodable>(_ request: APIRequest) -> Observable<T> {
           guard let urlRequest = request.asURLRequest() else {
               return Observable.error(APIError.invalidRequest)
           }
           
           return Observable.create { observer in
               let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                   if let error = error {
                       observer.onError(APIError.networkError(error))
                       return
                   }
                   
                   guard let httpResponse = response as? HTTPURLResponse else {
                       observer.onError(APIError.unknown)
                       return
                   }
                   
                   guard (200...299).contains(httpResponse.statusCode) else {
                       if httpResponse.statusCode == 401 {
                           observer.onError(APIError.unauthorized)
                       } else {
                           let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                           print(httpResponse)
                           observer.onError(APIError.serverError(httpResponse.statusCode, message))
                       }
                       return
                   }
                   
                   guard let data = data else {
                       observer.onError(APIError.unknown)
                       return
                   }
                   
                   do {
                       let decodedObject = try JSONDecoder().decode(T.self, from: data)
                       observer.onNext(decodedObject)
                       observer.onCompleted()
                   } catch(let error) {
                       observer.onError(APIError.decodingError(error))
                   }
               }
               task.resume()
               return Disposables.create { task.cancel() }
           }
       }
    
    func uploadData<T: Decodable>(_ request: APIRequest, data: Data, fieldName: String, fileName: String, mimeType: String) -> Observable<T> {
        return Observable.create { observer in
            guard var urlRequest = request.asURLRequest() else {
                observer.onError(APIError.invalidRequest)
                return Disposables.create()
            }
            
            let boundary = "Boundary-\(UUID().uuidString)"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.httpBody = body
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    observer.onError(APIError.networkError(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(APIError.unknown)
                    return
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    observer.onError(APIError.serverError(httpResponse.statusCode, message))
                    return
                }
                guard let data = data else {
                    observer.onError(APIError.unknown)
                    return
                }
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedObject)
                } catch {
                    observer.onError(APIError.decodingError(error))
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}

