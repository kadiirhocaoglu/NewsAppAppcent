//
//  HomeViewController.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 13.05.2024.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController{
    //MARK: UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    private let searchController: UISearchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.placeholder = "Search for a News"
            controller.searchBar.searchBarStyle = .minimal
            return controller
        }()
    // MARK: - Properties
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    private var article: Article?
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red

        prepareTableView()
        setupNav()
        setupSubviews()
        setupSearchBar()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    //MARK: Functions
    private func setupNav(){
        self.navigationItem.title = "Appcent NewsApp"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        fetchTopHeadlinesData()
    }
    private func setupSubviews(){
        self.view.addSubview(tableView)
    }
    private func setupLayout(){
        tableView.frame = self.view.bounds
    }
    private func setupSearchBar(){
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
    }
    private func fetchSearchNewsData(_ query: String){
        NetworkManager.shared.getSearch(with: query, page: 1, pageSize: 30) { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                self.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel( title: $0.title ?? "", subtitle: $0.description ?? "No description", publishedAt: $0.publishedAt ?? "  ", imageURL: URL(string: $0.urlToImage ?? ""))})
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            default:
                break
            }
        }
    }
    private func fetchTopHeadlinesData(){
        NetworkManager.shared.getTopHeadlines( completion: { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                self.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel( title: $0.title ?? "", subtitle: $0.description ?? "No description", publishedAt: $0.publishedAt ?? "  ", imageURL: URL(string: $0.urlToImage ?? ""))})
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            default:
                break
            }
        }
    )}
}
// MARK: - Extensions
extension HomeViewController: ConfigureTableView {
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
        self.article = article
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
//MARK: SearchController

extension HomeViewController: ConfigureSearchBar {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else { return }
        fetchSearchNewsData(query)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchTopHeadlinesData()
    }
}
