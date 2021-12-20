//
//  FavoritsViewController.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import UIKit

class FavoritsViewController: UIViewController {
    
    //    MARK: - Properrties
    var favoritesView = FavoritesView()
    var viewModel: FavoritesViewModel
    
    //    MARK: - NavController
    private func setupNavController() {
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.sizeToFit()
    }
    
    //    MARK: - Setup UI
    private func setupUI() {
        favoritesView.dataSource = self
        favoritesView.delegate = self
        favoritesView.registerClass(cellClass: FavoritPhotoCell.self, forCellReuseIdentifier: FavoritPhotoCell.reuseId)
    }
    private func refreshUI() {
        favoritesView.reloadTableview()
        let isEmpty = viewModel.checkIsEmpty()
        favoritesView.setupUI(isEmpty: isEmpty)
    }
    // MARK: - Init
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //    MARK: - Life Cycle
    override func loadView() {
        view = favoritesView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupNavController()
        setupUI()
    }
}

// MARK: - Extension UITableViewDataSource
extension FavoritsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFavorites().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.favoritesView.dequeueReusableCellWithIdentifier(identifier: FavoritPhotoCell.reuseId) as? FavoritPhotoCell else { return UITableViewCell() }
        let photos = viewModel.getFavorites()
        cell.setupCell(detail: photos[indexPath.row])
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension FavoritsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photos = viewModel.getFavorites()
        
        //  Prepare parameters for detailVC
        let detail = photos[indexPath.row]
        let viewModel: DetailsViewModel = DetailsViewModelImpl(detail: detail)
        let networkDataFetcher: NetworkDataFetcher = NetworkDataFetcherImpl()
        let detailVC = DetailsViewController(viewModel: viewModel, networkDataFetcher: networkDataFetcher)
        
        //  Refresh Favorites List when detailVC was Changed
        detailVC.delegate = self
        self.navigationController?.present(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

// MARK: - Extension FavoritsWasChangedDelegate
extension FavoritsViewController: FavoritsWasChangedDelegate {
    func didChanged() {
        self.refreshUI()
    }
}

