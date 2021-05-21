import UIKit

class Puzzle: UIView {

    enum PuzzlePieceSide {
        case straight
        case outerCircle
        case innerCircle
    }

    struct PuzzlePieceType {
        let top: PuzzlePieceSide
        let right: PuzzlePieceSide
        let bottom: PuzzlePieceSide
        let left: PuzzlePieceSide
    }

    static func puzzlePieceImages(for image: UIImage, rows: Int, columns: Int) -> [UIImage?] {
        let paths = puzzlePaths(for: image.size, rows: rows, columns: columns)
        let images = paths.map { path in
            image.imageByApplyingClippingBezierPath(path)
        }
        return images
    }

    static func bezierPathForPiece(type: PuzzlePieceType, size: CGSize) -> UIBezierPath {
        // For the explanation of this code check this photo: https://photos.app.goo.gl/5xKR8Q78XXWNFYFG9
        let circleRatio: CGFloat = 1/4
        let shortestSide = size.width < size.height ? size.width : size.height
        let circleRadius = shortestSide * circleRatio * 0.5
        let circleCenterDistance = circleRadius * 2 / 3
        let circleTowardsCenterAngle = acos(circleCenterDistance / circleRadius)
        let circlePortionLength = sin(circleTowardsCenterAngle) * circleRadius

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))

        if type.top != .straight {
            path.addLine(to: CGPoint(x: size.width / 2 - circlePortionLength, y: 0))
            if type.top == .innerCircle {
                path.addArc(withCenter: CGPoint(x: size.width / 2 , y: circleCenterDistance),
                        radius: circleRadius,
                        startAngle: CGFloat.pi + circleTowardsCenterAngle,
                        endAngle: -circleTowardsCenterAngle,
                        clockwise: false)
            } else {
                path.addArc(withCenter: CGPoint(x: size.width / 2 , y: -circleCenterDistance),
                        radius: circleRadius,
                        startAngle: CGFloat.pi - circleTowardsCenterAngle,
                        endAngle: circleTowardsCenterAngle,
                        clockwise: true)
            }
        }
        path.addLine(to: CGPoint(x: size.width, y: 0))

        if type.right != .straight {
            path.addLine(to: CGPoint(x: size.width, y: size.height / 2 - circlePortionLength))
            if type.right == .innerCircle {
                path.addArc(withCenter: CGPoint(x: size.width - circleCenterDistance , y: size.height / 2),
                            radius: circleRadius,
                            startAngle: (CGFloat.pi * 3 / 2) + circleTowardsCenterAngle,
                            endAngle: CGFloat.pi / 2 - circleTowardsCenterAngle,
                            clockwise: false)
            } else {
                path.addArc(withCenter: CGPoint(x: size.width + circleCenterDistance , y: size.height / 2),
                            radius: circleRadius,
                            startAngle: (CGFloat.pi * 3 / 2) - circleTowardsCenterAngle,
                            endAngle: CGFloat.pi / 2 + circleTowardsCenterAngle,
                            clockwise: true)
            }
        }
        path.addLine(to: CGPoint(x: size.width, y: size.height))

        if type.bottom != .straight {
            path.addLine(to: CGPoint(x: size.width - circlePortionLength, y: size.height))
            if type.bottom == .innerCircle {
                path.addArc(withCenter: CGPoint(x: size.width / 2 , y: size.height - circleCenterDistance),
                            radius: circleRadius,
                            startAngle: circleTowardsCenterAngle,
                            endAngle: CGFloat.pi - circleTowardsCenterAngle,
                            clockwise: false)
            } else {
                path.addArc(withCenter: CGPoint(x: size.width / 2 , y: size.height + circleCenterDistance),
                        radius: circleRadius,
                        startAngle: -circleTowardsCenterAngle,
                        endAngle: CGFloat.pi + circleTowardsCenterAngle,
                        clockwise: true)
            }
        }
        path.addLine(to: CGPoint(x: 0, y: size.height))

        if type.left != .straight {
            path.addLine(to: CGPoint(x: 0, y: size.height / 2 + circlePortionLength))
            if type.left == .innerCircle {
                path.addArc(withCenter: CGPoint(x: circleCenterDistance , y: size.height / 2),
                            radius: circleRadius,
                            startAngle: CGFloat.pi / 2 + circleTowardsCenterAngle,
                            endAngle: (CGFloat.pi * 3 / 2) - circleTowardsCenterAngle,
                            clockwise: false)
            } else {
                path.addArc(withCenter: CGPoint(x: -circleCenterDistance , y: size.height / 2),
                            radius: circleRadius,
                            startAngle: CGFloat.pi / 2 - circleTowardsCenterAngle,
                            endAngle: (CGFloat.pi * 3 / 2) + circleTowardsCenterAngle,
                            clockwise: true)
            }
        }
        path.close()

        return path
    }

    /**
        Generates the puzzle grid. The top and the bottom side alternates between columns while the top and bottom side alternates between the rows
     */
    static func puzzlePaths(for size: CGSize, rows: Int, columns: Int) -> [UIBezierPath] {
        var paths = [UIBezierPath]()
        let width = size.width / CGFloat(columns)
        let height = size.height / CGFloat(rows)
        for row in 0..<rows {
            for column in 0..<columns {
                var top: PuzzlePieceSide = .straight
                var right: PuzzlePieceSide = .straight
                var bottom: PuzzlePieceSide = .straight
                var left: PuzzlePieceSide = .straight

                if row % 2 == 1 {
                    if column % 2 == 1 {
                        top = .outerCircle
                        bottom = .innerCircle
                    } else {
                        top = .innerCircle
                        bottom = .outerCircle
                    }
                    left = .innerCircle
                    right = .outerCircle
                } else {
                    if column % 2 == 1 {
                        top = .outerCircle
                        bottom = .innerCircle
                    } else {
                        top = .innerCircle
                        bottom = .outerCircle
                    }
                    left = .outerCircle
                    right = .innerCircle
                }

                if row == 0 {
                    top = .straight
                } else if row == rows-1 {
                    bottom = .straight
                }

                if column == 0 {
                    left = .straight
                } else if column == columns - 1 {
                    right = .straight
                }

                let path = bezierPathForPiece(type: PuzzlePieceType(top: top, right: right, bottom: bottom, left: left), size: CGSize(width: width, height: height))
                path.apply(CGAffineTransform(translationX: width * CGFloat(column), y: height * CGFloat(row)))
                paths.append(path)
            }
        }
        return paths
    }
}



