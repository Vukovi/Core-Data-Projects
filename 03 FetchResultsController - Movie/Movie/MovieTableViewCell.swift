//
//  MovieTableViewCell.swift
//  Movie
//
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieFormatLabel: UILabel!
    @IBOutlet weak var userRating: UserRating!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    internal func configureCell(movie: Movie) {
        movieTitleLabel.text = movie.title
        movieFormatLabel.text = movie.format
        userRating.rating = Int(movie.userRating)
        
        let imageData = movie.image
        movieImageView.image = UIImage(data: imageData!)
    }
}
