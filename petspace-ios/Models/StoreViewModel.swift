//
//  StoreViewModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import SwiftUI
import CoreLocation
import Foundation
import Combine

class StoreViewModel: ObservableObject {
    @Published var store: [Store.Data.StoreItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    // 데이터를 불러오는 방식 선택
    init() {
        // 임시 데이터 불러옴
        loadData()
        
        // 서버에서 데이터 받아옴
        loadStoreListData()
    }
    
    // 내부 local 파일에서 데이터를 불러옴
    func loadData() {
        if let url = Bundle.main.url(forResource: "dummy", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let storeData = try decoder.decode(Store.self, from: data)
                self.store = storeData.data.items
            } catch {
                print("Error while decoding JSON: \(error)")
            }
        }
    }
    
    func loadStoreListData() {
        print("loadStoreListData")
        
        let parameters = "{\"breed\": \"시고르자브\",\"kg\": 7.3\n}"
        let postData = parameters.data(using: .utf8)
        
        guard let url = URL(string: ServerURLCollection.getStoreList.rawValue) else { return }
        
        var request = URLRequest(url: url, timeoutInterval: 3000)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(validate)
            .decode(type: Store.self, decoder: JSONDecoder())
            .sink { _ in
            } receiveValue: { [weak self] returnedPost in
                print("get data : \(returnedPost)")
                self?.store = returnedPost.data.items
                print("num of data: \(String(describing: self?.store.count))")
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

// ViewModel을 테스트하기 위한 View
struct ViewModelTestView: View {
    
    @StateObject var viewModel = StoreViewModel()
    @State var isPresented: Bool = false
    
    var body: some View {
        Text("count: \(viewModel.store.count)")
        Text(viewModel.store[0].isSaved ?? false ? "TRUE" : "FALSE")
        Text("Hello World")
        
        Button("sheet") {
            isPresented = true
        }
        .sheet(isPresented: $isPresented, content: {
            ViewModelTestSubView(store: $viewModel.store[0])
        })
    }
}

// SubView
struct ViewModelTestSubView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var store: Store.Data.StoreItem
    
    var body: some View {
        Text(store.isSaved ?? false ? "TRUE" : "FALSE")
        Button("toggle") {
            if store.isSaved == nil {
                store.isSaved = true
            } else if store.isSaved == false {
                store.isSaved = true
            } else {
                store.isSaved = false
            }
        }
        
        Button("close") {
            dismiss()
        }
    }
}

#Preview {
    ViewModelTestView()
}
