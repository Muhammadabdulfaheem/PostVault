import UIKit


final class PostListTVCell: UITableViewCell {

    private enum Symbol {
        static let heart = "heart"
        static let heartFill = "heart.fill"
    }

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var imageCheck: UIImageView!
    @IBOutlet private weak var parentUIView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        applyCard()
    }

    func configurePostingListCell(_ post: PostData) {
        lblTitle.text = post.title
        lblDesc.text = post.subtitle
        imageCheck.image = UIImage(systemName: post.isFavorite ? Symbol.heartFill : Symbol.heart)
        imageCheck.tintColor = post.isFavorite ? .systemRed : .tertiaryLabel
    }

    private func applyCard() {
        parentUIView.layer.cornerRadius = 16
        parentUIView.layer.masksToBounds = true
        parentUIView.layer.borderWidth = 1
        parentUIView.layer.borderColor = AppColor.outlineColor.color.cgColor
    }
}
