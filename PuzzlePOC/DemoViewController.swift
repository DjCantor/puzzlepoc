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
        let images = Puzzle.puzzlePieceImages(for: image, rows: rows, columns: columns)
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

    @IBAction func puzzleViewTap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: puzzleView)
        let onePieceSize = CGSize(width: puzzleView.bounds.width / CGFloat(columns), height: puzzleView.bounds.height / CGFloat(rows))
        let row = Int(tapPoint.x / onePieceSize.width)
        let column = Int(tapPoint.y / onePieceSize.height)
        let element = column * columns + row
        if puzzleView.acquiredPuzzlePieces.contains(element) {
            var newSet = puzzleView.acquiredPuzzlePieces
            newSet.remove(element)
            puzzleView.acquiredPuzzlePieces = newSet
        } else {
            puzzleView.acquiredPuzzlePieces.insert(element)
        }
    }
}

