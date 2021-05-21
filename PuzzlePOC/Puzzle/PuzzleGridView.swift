import UIKit

class PuzzleGridView: UIView {
    var rows = 2
    var columns = 2

    override func draw(_ rect: CGRect) {
        let paths = Puzzle.puzzlePaths(for: self.bounds.size, rows: rows, columns: columns)
        paths.forEach { path in
            path.lineWidth = 1.0
            UIColor.white.setStroke()
            path.stroke()
        }
    }
}
