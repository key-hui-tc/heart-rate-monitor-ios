//
//  BaseApiService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

class BaseApiService {
    private let host = AppConfig.host
    private let timeoutInterval: Double = 30
    private var token: String? = nil

    init(token: String? = nil) {
        self.token = token
    }

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

    enum ContentType: String {
        case json = "application/json"
        case pdf = "application/pdf"
    }

    func withHost(_ url: String) -> String {
        return "\(host)\(url)"
    }

    func makeRequest<R: BaseModel>(
        _ responseType: R.Type,
        url: String,
        method: HttpMethod,
        parameters: Data? = nil,
        contentType: ContentType? = .json
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

        if let contentType = contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Accept")
        }

        if let parameters = parameters {
            request.httpBody = parameters
        }

//        Logger.d(request.allHTTPHeaderFields)
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            Logger.d("statusCode should be 200, but is \(httpStatus.statusCode)")
            Logger.d("response = \(String(describing: response))")
        }

        // dirty fix, suppose to change the API response format better
        if R.self == GeneticResponse.self {
            if let array = try? JSONDecoder().decode([GenotypeModelForApi].self, from: data) {
                Logger.d(array)
                let genotypes = array.map { item in
                    return GenotypeModel(name: item.name, symbol: item.symbol)
                }
                return GeneticResponse(genotypes: genotypes) as? R
            } else {
                return nil
            }
        }

        if let result = try? JSONDecoder().decode(R.self, from: data) {
            Logger.d(result)
            return result
        } else {
            Logger.d("Invalid Response")
            return nil
        }
    }
}
