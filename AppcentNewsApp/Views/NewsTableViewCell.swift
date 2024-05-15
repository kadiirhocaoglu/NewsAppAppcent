//
//  NewsTableViewCell.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 13.05.2024.
//

import UIKit
class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label // Metin rengini ayarla
        return label
    }()
    
    private let newsSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label // Metin rengini ayarla
        return label
    }()
    private let newsPublishAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 7, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label // Metin rengini ayarla
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemRed
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10 // Kenar yuvarlaklığı ekle
        imageView.layer.borderWidth = 1.0 // Görüntü kenarlık kalınlığı
        imageView.layer.borderColor = UIColor.lightGray.cgColor // Görüntü kenarlık rengi
        imageView.layer.shadowColor = UIColor.black.cgColor // Gölge rengi
        imageView.layer.shadowOpacity = 0.5 // Gölge opaklığı
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2) // Gölge boyutu
        imageView.layer.shadowRadius = 2.0 // Gölge yarıçapı
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier reuseIdentifer: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifer)
        
        // Arkaplan rengini ayarla
        contentView.backgroundColor = .systemBackground
        
        //MARK: AddSubviews
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsSubtitleLabel)
        contentView.addSubview(newsPublishAtLabel)
        contentView.addSubview(newsImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyConstraints()
    }
    private func applyConstraints() {
        let ElementsConstraints = [
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            newsTitleLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -8), // newsImageView'dan 8 birim önce
            newsTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,constant: 8),

            newsSubtitleLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 8),
            newsSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            newsSubtitleLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -8),
            newsSubtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,constant: -8),
            newsPublishAtLabel.topAnchor.constraint(equalTo: newsSubtitleLabel.bottomAnchor, constant: 8),
            newsPublishAtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            newsPublishAtLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,constant: -8),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
            
            NSLayoutConstraint.activate(ElementsConstraints)
        
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsSubtitleLabel.text = viewModel.subtitle
        newsPublishAtLabel.text = formatDateString(date: viewModel.publishedAt)
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) {[weak self] data,_,error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                        self?.newsImageView.image = image
                        
                }
            }.resume()
        }
    }
}

extension NewsTableViewCell {
    func formatDateString(date: String?) -> String {
        guard let date = date else {return "null"}
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withTimeZone, .withDashSeparatorInDate, .withColonSeparatorInTime]
        if let date = dateFormatter.date(from: date) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "tr_TR") // Türkçe ay isimleri için
            dateFormatter.dateFormat = "d MMMM yyyy HH:mm"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        else {
            return "unknown"
         }
    }

}
