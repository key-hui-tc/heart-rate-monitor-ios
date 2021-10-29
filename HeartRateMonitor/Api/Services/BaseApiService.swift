//
//  BaseApiService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

class BaseApiService {
    let host = "http://127.0.0.1:8080/"
    let timeoutInterval: Double = 30
    var token: String? = nil

    enum HttpMethod {
        case get, post, put, patch, delete

        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .patch: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }

    func withHost(_ url: String) -> String {
        return "\(host)\(url)"
    }

    func makeRequest<R: BaseModel>(
        _ responseType: R.Type,
        url: String,
        method: HttpMethod,
        parameters: Data? = nil
    ) async throws -> R? {
        guard let url = URL(string: url) else {
            Logger.d("invalid url=\(url) ")
            throw ApiError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.timeoutInterval = timeoutInterval
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let parameters = parameters {
            request.httpBody = parameters
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            Logger.d("statusCode should be 200, but is \(httpStatus.statusCode)")
            Logger.d("response = \(String(describing: response))")
        }

        if let result = try? JSONDecoder().decode(R.self, from: data) {
            Logger.d(result)
            return result
        } else {
            Logger.d("Invalid Response")
            return nil
        }

//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                Logger.d("statusCode should be 200, but is \(httpStatus.statusCode)")
//                Logger.d("response = \(String(describing: response))")
//            }
//            if let data = data {
//                // TODO: response
////                if let books = try? JSONDecoder().decode([Book].self, from: data) {
////                    print(books)
////                } else {
////                    print("Invalid Response")
////                }
//                Logger.d(data)
//            } else if let error = error {
//                Logger.d(error)
//            }
//        }
//        task.resume()
//        return nil
    }
}
