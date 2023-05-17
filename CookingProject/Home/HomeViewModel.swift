//
//  HomeViewModel.swift
//  CookingProject
//
//  Created by Macbook Air on 16.05.2023.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchServiceSuccess(searchResponseModel: SearchResponseModel)
    func didFetchServiceFail(message: String)
}

class HomeViewModel {
    
    // MARK: Delegate
    weak var delegate: HomeViewModelDelegate?
    
    func fetchService(searchText: String) {
        
        ApiManager().fetchSearchService(searchText: searchText) { result in
            switch result {
            case .success(let searchResponseModel):
                self.delegate?.didFetchServiceSuccess(searchResponseModel: searchResponseModel)
            case .failure(let error):
                self.delegate?.didFetchServiceFail(message: error.localizedDescription)
            }
        }
    }
}
