import UIKit

class DemoViewController: UIViewController {

    @IBOutlet private weak var puzzleView: PuzzleView!
    @IBOutlet private weak var rowLabel: UILabel!
    @IBOutlet private weak var columnLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!

    private var rows = 2
    private var columns = 2
    private let image = UIImage(named: "test")!

    override func viewDidLoad() {
        super.viewDidLoad()

        puzzleView.image = image
        puzzleView.acquiredPuzzlePieces = [1, 3]
        createClippedImages()
    }

    @IBAction func rowStepperValueChanged(_ sender: UIStepper) {
        rows = Int(sender.value)
        rowLabel.text = String(rows)
        puzzleView.rows = rows
        createClippedImages()
    }

    @IBAction func columnStepperValueChanged(_ sender: UIStepper) {
        columns = Int(sender.value)
        columnLabel.text = String(columns)
        puzzleView.columns = columns
        createClippedImages()
    }

    private func createClippedImages() {
        let images = PuzzleGrid.puzzlePieceImages(for: image, rows: rows, columns: columns)
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        images.forEach { image in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(imageView)
        }
    }
}

