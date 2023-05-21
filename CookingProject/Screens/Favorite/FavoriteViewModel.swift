//
//  FavoriteViewModel.swift
//  CookingProject
//
//  Created by Macbook Air on 18.05.2023.
//

import Foundation
import CodableFirebase
import FirebaseFirestore
import FirebaseAuth

protocol FavoriteViewModelDelegate: AnyObject {
    func favoriteSuccess(resultModel: [ResultModel])
    func favoriteFail(message: String)
}

class FavoriteViewModel {
    
    // MARK: - Delegate
    weak var delegate : FavoriteViewModelDelegate?
    
    // MARK: - Properties
    private var resultModel: [ResultModel] = []
    
    func getData() {
        let fireStore = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email else { return }
        fireStore.collection("Favorite").document(email).collection(userId).getDocuments(completion: { snapShot, error in
        
            if let error = error {
                self.delegate?.favoriteFail(message: error.localizedDescription)
                return
            }

            guard let snapShot = snapShot else {
                self.delegate?.favoriteFail(message: "Your favorites are currently empty.")
                return
            }
            
            for document in snapShot.documents {
                if let model = try? FirestoreDecoder().decode(ResultModel.self, from: document.data()) {
                    self.resultModel.append(model)
                }
            }
            self.delegate?.favoriteSuccess(resultModel: self.resultModel)
        })
    }
}
