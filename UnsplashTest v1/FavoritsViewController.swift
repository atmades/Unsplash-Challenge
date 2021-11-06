//
//  FavoritsViewController.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import UIKit

class FavoritsViewController: UIViewController {
    
    //    MARK: - Properrties
    var singleton = Favorites.sharedInstance
    private var photos: [Detail] = []
    
    //    MARK: - UIViews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoritPhotoCell.self, forCellReuseIdentifier: FavoritPhotoCell.reuseId)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "There is no favorits"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - NavController
    private func setupNavController() {
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }
    
    //    MARK: - Private Functions
    private func setupLayout() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func checkFavorites() {
        if photos.isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func refreshUI() {
        photos = singleton.itemsArray
        tableView.reloadData()
        checkFavorites()
    }

    //    MARK: - Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupNavController()
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        photos = singleton.itemsArray
        tableView.dataSource = self
        tableView.delegate = self
        checkFavorites()
    }
}

// MARK: - Extension UITableViewDataSource
extension FavoritsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritPhotoCell.reuseId, for: indexPath) as? FavoritPhotoCell else { return UITableViewCell() }
    
        cell.setupCell(detail: photos[indexPath.row])
        print(photos[indexPath.row].name)
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension FavoritsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = photos[indexPath.row]
        let detailVC = DetailsViewController(detail: detail)
        self.navigationController?.present(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        Rrefresh TableView after Deinit detailVC
        detailVC.onWillDismiss = { [weak self] in
            guard let self = self else { return }
            self.refreshUI()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
