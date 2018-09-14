public struct AnimationRunner {
    init(sequence: AnimationSequence) {
        var sequence = sequence
        let step = sequence.popStep()
        animator = UIViewPropertyAnimator(duration: step.duration, curve: .linear) {
            if let center = step.center {
                sequence.view.center = center
            }
        }
    }
    public func start() {
        animator.startAnimation()
    }
    private let animator: UIViewPropertyAnimator
    
}

