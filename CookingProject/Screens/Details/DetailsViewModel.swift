//
//  DetailsViewModel.swift
//  CookingProject
//
//  Created by Macbook Air on 17.05.2023.
//

import Foundation

protocol DetailsViewModelDelegate: AnyObject {
    func didFetchServiceSuccess(detailResponseModel: DetailResponseModel)
    func didFetchServiceFail(message: String)
}

class DetailsViewModel {
    
    // MARK: Delegate
    weak var delegate: DetailsViewModelDelegate?
    
    func fetchService(id: String?) {
        ApiManager().fetchDetailService(id: id ?? "") { result in
            switch result {
            case .success(let detailResponseModel):
                self.delegate?.didFetchServiceSuccess(detailResponseModel: detailResponseModel)
            case .failure(let error):
                self.delegate?.didFetchServiceFail(message: error.localizedDescription)
            }
        }
    }
}
