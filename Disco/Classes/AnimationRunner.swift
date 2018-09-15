public struct AnimationRunner {
    init(sequence: AnimationSequence) {
        self.sequence = sequence
        animator = selectAnimator(from: sequence)
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

private func selectAnimator(from sequence: AnimationSequence) -> UIViewPropertyAnimator {
    let duration = sequence.totalDuration
    switch sequence.timing {
    case let .predefined(curve):
        return UIViewPropertyAnimator(duration: duration, curve: curve)
    case let .bezier(pt1, pt2):
        return UIViewPropertyAnimator(duration: duration, controlPoint1: pt1, controlPoint2: pt2)
    case let .springBased(dampingRatio):
        return UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio)
    case let .timingParameters(timingParameters):
        return UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
    }
}
