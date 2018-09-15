public struct AnimationRunner {
    init(sequence: AnimationSequence) {
        self.sequence = sequence
        animator = UIViewPropertyAnimator(duration: sequence.totalDuration, curve: .linear)
        animator.addAnimations(animations())
    }
    public func start() {
        animator.startAnimation()
    }
    
    private func animations() -> (() -> ()) {
        var sequence = self.sequence
        let step = sequence.popStep()
        return {
            self.setProperty(viewProp: \.frame, stepProp: step.frame)
            self.setProperty(viewProp: \.bounds, stepProp: step.bounds)
            self.setProperty(viewProp: \.center, stepProp: step.center)
            self.setProperty(viewProp: \.transform, stepProp: step.transform)
            self.setProperty(viewProp: \.alpha, stepProp: step.alpha)
            self.setProperty(viewProp: \.backgroundColor, stepProp: step.backgroundColor)
        }
    }
    
    private func setProperty<T>(viewProp: ReferenceWritableKeyPath<UIView, T>, stepProp: T?) {
        if let stepProp = stepProp {
            sequence.view[keyPath: viewProp] = stepProp
        }
    }
    private let animator: UIViewPropertyAnimator
    private let sequence: AnimationSequence
}
