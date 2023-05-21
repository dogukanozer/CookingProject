//
//  FavoriteViewController.swift
//  CookingProject
//
//  Created by Macbook Air on 18.05.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var resultModels: [ResultModel] = []
    private let favoriteviewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        addDelegates()
        tableViewRegister()
        getFavorite()
    }
}

// MARK: - Helpers
private extension FavoriteViewController {
    
    func addDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        favoriteviewModel.delegate = self
        }
    
    func getFavorite() {
        favoriteviewModel.getData()
    }
        
    func tableViewRegister() {
        self.tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    
    func makeAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func loadCellImage(url: URL, cell: HomeViewCell) {
            
        DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.cellImageView.image = image
                        }
                    }
                } catch {
                    print("Image data couldn't be loaded: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewCell
        cell.titleLabel.text = self.resultModels[indexPath.row].title
        let urlToImage = self.resultModels[indexPath.row].image
        if let imageUrl = URL(string: urlToImage) {
             loadCellImage(url: imageUrl, cell: cell)
         }
        return cell
    }
}

// MARK: - FavoriteViewModelDelegate
extension FavoriteViewController : FavoriteViewModelDelegate {
    
    func favoriteSuccess(resultModel: [ResultModel]) {
        self.resultModels = resultModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
    }
}
    
    func favoriteFail(message: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: message)
    }
}
