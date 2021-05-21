import UIKit

class PuzzleView: UIView {
    var image = UIImage() {
        didSet {
            backgroundImageView.image = image.blackAndWhite()
            maskForegroundColouredImage()
        }
    }
    var acquiredPuzzlePieces = Set<Int>() {
        didSet {
            maskForegroundColouredImage()
        }
    }
    var rows = 2 {
        didSet {
            maskForegroundColouredImage()
            puzzleGridView.rows = rows
            puzzleGridView.setNeedsDisplay()
        }
    }
    var columns = 2 {
        didSet {
            maskForegroundColouredImage()
            puzzleGridView.columns = columns
            puzzleGridView.setNeedsDisplay()
        }
    }

    private let backgroundImageView = UIImageView()
    private let foregroundImageView = UIImageView()
    private let puzzleGridView = PuzzleGridView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        createLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        createLayout()
    }

    private func createLayout() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        foregroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(foregroundImageView)
        puzzleGridView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(puzzleGridView)

        puzzleGridView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor),

            foregroundImageView.topAnchor.constraint(equalTo: topAnchor),
            foregroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            foregroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            foregroundImageView.rightAnchor.constraint(equalTo: rightAnchor),

            puzzleGridView.topAnchor.constraint(equalTo: topAnchor),
            puzzleGridView.leftAnchor.constraint(equalTo: leftAnchor),
            puzzleGridView.bottomAnchor.constraint(equalTo: bottomAnchor),
            puzzleGridView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }

    /**
        Masks the foreground according to the acquiredImages, but actually it creates a mask for those that are not acquired yet
     */
    private func maskForegroundColouredImage() {
        let acquiredSet = acquiredPuzzlePieces
        let allSet = Set(0...(rows * columns - 1))
        let notAcquiredPuzzlePieceIndexes = allSet.subtracting(acquiredSet)
        var clippedImage = image
        let paths = Puzzle.puzzlePaths(for: image.size, rows: rows, columns: columns)
        for index in notAcquiredPuzzlePieceIndexes {
            clippedImage = clippedImage.complementer_clip(paths[index])!
        }
        foregroundImageView.image = clippedImage
        foregroundImageView.setNeedsDisplay()
    }
}
