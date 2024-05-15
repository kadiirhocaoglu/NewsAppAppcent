//
//  FavoriteNewsViewController.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 13.05.2024.
//

import UIKit
import SafariServices

final class FavoriteNewsViewController: UIViewController {
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        prepareTableView()
        setupNav()
        setupSubviews()
        fetchFavoriteNews()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteNews()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    private func setupNav(){
        self.navigationItem.title = "Favorites"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        }
    private func setupSubviews(){
        self.view.addSubview(tableView)
    }
    private func setupLayout(){
        tableView.frame = self.view.bounds
    }
    private func fetchFavoriteNews(){
        let article = FavoritesManager.shared.getFavorites()
        self.articles = article
        self.viewModels = article.compactMap({
            NewsTableViewCellViewModel( title: $0.title ?? "", subtitle: $0.description ?? "No description", publishedAt: $0.publishedAt ?? "  ", imageURL: URL(string: $0.urlToImage ?? ""))})
    }
    @objc private func refreshTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("Test: Gülümsemeyi unutma")
    }
}

extension FavoriteNewsViewController: ConfigureTableView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        let viewModel = viewModels[indexPath.row]
        DispatchQueue.main.async { [weak self] in
            let vc = NewsPreviewViewController()
            vc.configure(viewModel, article)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
