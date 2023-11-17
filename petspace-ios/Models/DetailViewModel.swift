//
//  DetailViewModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/13/23.
//

import SwiftUI
import Foundation
import CoreLocation
import Combine

final class DetailViewModel: ObservableObject {
    @Published var storeDetail: StoreDetail.DetailData.DetailStoreItem?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
        loadStoreDetailData(id: "c89d86e4-6c71-4a90-ad90-c79516c2a77e")
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "detaildummy", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let storeData = try decoder.decode(StoreDetail.self, from: data)
                self.storeDetail = storeData.data.detail
            } catch {
                print("Error while decoding JSON: \(error)")
            }
        }
    }
    
    func loadStoreDetailData(id: String) {
        print("loadStoreListData")
        
        let parameters = "{\"breed\": \"시고르자브\",\"kg\": 7.3\n}"
        let postData = parameters.data(using: .utf8)
        
        guard let url = URL(string: ServerURLCollection.getStoreDetail.rawValue + id) else { return }
        
        var request = URLRequest(url: url, timeoutInterval: 3000)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(validate)
            .decode(type: StoreDetail.self, decoder: JSONDecoder())
            .sink { _ in
            } receiveValue: { [weak self] returnedPost in
                // print("get detail data : \(returnedPost)")
                self?.storeDetail = returnedPost.data.detail
            }
            .store(in: &cancellables)
    }
    
    // 요청이 성공했는지 검사 (http response 200 ~ 299)
    private func validate(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
