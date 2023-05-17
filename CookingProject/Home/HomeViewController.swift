//
//  HomeViewController.swift
//  CookingProject
//
//  Created by Macbook Air on 16.05.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    
    private var searchResponseModel: SearchResponseModel?
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
    super.viewDidLoad()

        addDelegates()
        fechService()
        tableViewRegister()
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        guard let searchText = searchText.text else {return}
        viewModel.fetchService(searchText: searchText)
    }
}
// MARK: - Helpers
private extension HomeViewController {
    
    func addDelegates() {
            tableView.delegate = self
            tableView.dataSource = self
            viewModel.delegate = self
        }
        
        func tableViewRegister() {
            self.tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
        
    func fechService() {
        viewModel.fetchService(searchText: "")
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
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponseModel?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewCell
        cell.titleLabel.text = searchResponseModel?.results[indexPath.row].title
        let urlToImage = searchResponseModel?.results[indexPath.row].image ?? ""
       if let imageUrl = URL(string: urlToImage) {
            loadCellImage(url: imageUrl, cell: cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResultModel = searchResponseModel?.results[indexPath.row]
        let detailsViewController = DetailsViewController()
        detailsViewController.searchResultModel = searchResultModel
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title:  "Add Favorites", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })
        favoriteAction.image = UIImage(named: "favoriteIcon")
        favoriteAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}
    
// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didFetchServiceSuccess(searchResponseModel: SearchResponseModel) {
        self.searchResponseModel = searchResponseModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
    }
}
    
    func didFetchServiceFail(message: String) {
        DispatchQueue.main.async {
            self.makeAlert(tittleInput: "Error", messegaInput: message)
        }
    }
}
