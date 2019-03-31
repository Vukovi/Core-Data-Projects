//
//  SaleHistoryTableViewCell.swift
//  Home Report
//
//  Created by Vuk Knezevic on 3/28/19.
//

import UIKit

class SaleHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var soldDateLabel: UILabel!
    @IBOutlet weak var soldPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(saleHistory: SaleHistory) {
        soldDateLabel.text = saleHistory.soldDate?.toString
        soldPriceLabel.text = saleHistory.soldPrice.currencyFormatter
    }
}
