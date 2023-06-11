//
//  HomeViewController.swift
//  CookingProject
//
//  Created by Macbook Air on 16.05.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchText: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchingButton: UIButton!
    
    // MARK: - Properties
    private var searchResponseModel: SearchResponseModel?
    private let viewModel = HomeViewModel()
    private var animationView = LottieAnimationView(name: "anime")
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
    super.viewDidLoad()

        addDelegates()
        fechService()
        tableViewRegister()
        setAnimationView()
        setProperties()
    }
    
    // MARK: - Actions
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
    
    func setAnimationView() {
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.isHidden = false
        view.addSubview(animationView)
    }
    
    func setProperties() {
        searchTextField.layer.cornerRadius = 10
        searchingButton.layer.cornerRadius = 10
    }

        
    func fechService() {
        animationView.play()
        animationView.isHidden = false
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
    
    func saveFirebase(index: IndexPath) {
        guard let userID = Auth.auth().currentUser?.uid,
              let email = Auth.auth().currentUser?.email,
              let title = self.searchResponseModel?.results[index.row].title,
              let urlToImage = self.searchResponseModel?.results[index.row].image,
              let id = self.searchResponseModel?.results[index.row].id else {
            self.makeLoginAlert(tittleInput: "Error", messegaInput: "Please login.")
            return
        }
        let fireStore = Firestore.firestore().collection("Favorite").document(email)
        guard let fireStoreDictionary = ["title": title, "image": urlToImage, "id": id] as? [String : Any] else { return }
        
        fireStore.collection(userID).document().setData(fireStoreDictionary, merge: true) { error in
            if let error = error {
                self.makeAlert(tittleInput: "Error", messegaInput: error.localizedDescription)
            }
        }
    }
    
    func makeLoginAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let loginButton = UIAlertAction(title: "Login", style: UIAlertAction.Style.default) { _ in
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController = loginViewController
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        alert.addAction(loginButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
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
        let imageUrl = searchResponseModel?.results[indexPath.row].image
        let detailsViewController = DetailsViewController()
        detailsViewController.searchResultModel = searchResultModel
        detailsViewController.imageUrl = imageUrl
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title:  "Add Favorites", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.saveFirebase(index: indexPath)
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
            self.animationView.stop()
            self.animationView.isHidden = true
    }
}
    
    func didFetchServiceFail(message: String) {
        DispatchQueue.main.async {
            self.makeAlert(tittleInput: "Error", messegaInput: message)
            self.animationView.stop()
            self.animationView.isHidden = true
        }
    }
}
