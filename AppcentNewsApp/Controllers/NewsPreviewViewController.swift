//
//  NewsPreviewViewController.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 14.05.2024.
//

import UIKit
import WebKit

class NewsPreviewViewController: UIViewController,ConfigureWebKit {
    private var article: Article?

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18 , weight: .bold)
        label.numberOfLines = 3
        label.text = "No Signal"
        return label
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .bitWidth
        label.text = " "
        return label
    }()
    private let newsDetailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitle("Detail", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupBarButtonItems()
        setupSubviews()
        configureConstraints()
    }
    private func setupViewController(){
        view.backgroundColor = .systemBackground
        newsDetailButton.addTarget(self, action: #selector(didTapNewsDetailButton), for: .touchUpInside)
    }
    private func setupBarButtonItems(){
        let favoriteButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addToFavorites))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        self.navigationItem.rightBarButtonItems = [favoriteButton, shareButton]
    }
    private func setupSubviews(){
        view.addSubview(newsImageView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(newsDetailButton)
    }
    func configure( _ withmodel: NewsTableViewCellViewModel, _ witharticle: Article ) {
        self.article = witharticle
        titleLabel.text = withmodel.title
        overViewLabel.text = article?.description
        guard let data = withmodel.imageData else {return}
        newsImageView.image = UIImage(data: data)
    }
    @objc func addToFavorites() {
        guard let article = article else { return }
        if FavoritesManager.shared.isArticleFavorited(article) {
            let alert = UIAlertController(title: "Remove Favorite", message: "Are you sure you want to remove this news item from favorites?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (_) in
                FavoritesManager.shared.removeFavorite(article)
                let removalAlert = UIAlertController(title: "Removed Favorite", message: "The article has been removed from favorites.", preferredStyle: .alert)
                removalAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(removalAlert, animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            FavoritesManager.shared.addFavorite(article)
            let alert = UIAlertController(title: "Added Favorite", message: "The news has been added to favorites.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    @objc func shareButtonTapped() {
   
        guard let shareURL = article?.url else {
            return         }
        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    @objc func didTapNewsDetailButton() {
        if let articleURL = article?.url, let url = URL(string: articleURL) {
            let webView = WKWebView(frame: view.bounds)
            webView.navigationDelegate = self
            view.addSubview(webView)
            
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("No URL available.")
        }
    }
}

//MARK: Constraints
extension NewsPreviewViewController {
    func configureConstraints() {
        let newsImageViewconstraints = [
            newsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            newsImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            newsImageView.heightAnchor.constraint(equalToConstant: 250)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        let newDetailButtonConstraints = [
            newsDetailButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 20),
            newsDetailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newsDetailButton.widthAnchor.constraint(equalToConstant: 120)
            
        ]
        NSLayoutConstraint.activate(newsImageViewconstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(newDetailButtonConstraints)
        
    }
}
