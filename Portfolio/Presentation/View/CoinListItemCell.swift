//
//  CoinListItemCell.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//


import UIKit
import RxSwift

final class CoinListItemCell: UITableViewCell {

    static let id: String = "CoinListItemCell"
    private let containerView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    private let favoriteImageView = UIImageView()
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let priceChangePercentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let priceChangeLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let changeStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    private let quoteVolumeLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    private func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(favoriteImageView)

        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(changeStackView)
        containerView.addSubview(quoteVolumeLabel)
        changeStackView.addArrangedSubview(priceChangePercentLabel)
        changeStackView.addArrangedSubview(priceChangeLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(88)
            make.bottom.equalTo(-16)
        }
        favoriteImageView.snp.makeConstraints { make in
            make.leading.equalTo(14)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(favoriteImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(12)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        changeStackView.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(12)
            make.width.equalTo(50)
            make.centerY.equalToSuperview()
        }
        quoteVolumeLabel.snp.makeConstraints { make in
            make.leading.equalTo(changeStackView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.trailing.equalToSuperview().offset(-16)
        }
        
    }
    
    func apply(item: CoinListItem) {
        favoriteImageView.image = UIImage(named: "selectFavorite")
        nameLabel.text = item.symbol.replacingOccurrences(of: "_", with: "/").uppercased()
        
        priceLabel.text = formatPrice(price: item.close)
        priceChangeLabel.text = formatPrice(price: item.priceChange)

        setPriceChangePercentLabel(percent: item.priceChangePercent)
        
    
        quoteVolumeLabel.text = formatNumberWithCommas(Int(item.quoteVolume))
        
    }
    
    private func formatPrice(price: Double) -> String {
        if price > 100 {
            return formatNumberWithCommas(Int(price))
        } else {
            return formatDecimal(price, decimalPlaces: 2)
        }
    }
    
    private func setPriceChangePercentLabel(percent: Double) {
        if percent > 0 {
            priceChangePercentLabel.text = "+\(formatDecimal(percent, decimalPlaces: 2))%"
            priceChangePercentLabel.textColor = .red
        } else if percent < 0 {
            priceChangePercentLabel.text = "\(formatDecimal(percent, decimalPlaces: 2))%"
            priceChangePercentLabel.textColor = .blue
        } else {
            priceChangePercentLabel.text = "0%"
            priceChangePercentLabel.textColor = .black
        }
    }
    
    func formatNumberWithCommas(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    func formatDecimal(_ number: Double, decimalPlaces: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
