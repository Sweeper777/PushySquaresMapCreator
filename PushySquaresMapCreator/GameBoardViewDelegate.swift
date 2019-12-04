
protocol GameBoardViewDelegate : class {
    func mouseUp(at position: Position)
    func mouseMove(to position: Position)
}
