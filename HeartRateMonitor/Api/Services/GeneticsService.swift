//
//  GeneticsService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

class GeneticsService: BaseApiService {
    enum Path: String {
        case report = "customer/:id/report"
        case genetic = "customer/:id/genetic"
    }

    func getHealthReport(id: Int64) async -> PdfResponse? {
        let url = withHost(Path.report.rawValue.withId(id: id))
        Logger.d(url)
        do {
            let response = try await makeRequest(
                PdfResponse.self,
                url: url,
                method: .get,
                contentType: .pdf
            )
            Logger.d(response)
            return response
        } catch {
            Logger.d("Request failed: \(error)")
        }
        return nil
    }

    func getGeneticDetails(id: Int64) async -> GeneticResponse? {
        let url = withHost(Path.genetic.rawValue.withId(id: id))
        Logger.d(url)
        do {
            let response = try await makeRequest(
                GeneticResponse.self,
                url: url,
                method: .get
            )
            Logger.d(response)
            return response
        } catch {
            Logger.d("Request failed: \(error)")
        }
        return nil
    }
}
