public struct AnimationRunner {
    init(sequence: AnimationSequence) {
        self.sequence = sequence
        animator = selectAnimator(from: sequence)
        if sequence.isKeyframeAnimation {
            animator.addAnimations(keyframeAnimations())
        } else {
            animator.addAnimations(singleStepAnimation())
        }
        sequence.completions.forEach (animator.addCompletion)
    }
    
    var isRunning: Bool {
        return animator.isRunning
    }
    
    public func start() {
        animator.startAnimation()
    }
    
    public func pause() {
        animator.pauseAnimation()
    }
    
    public func stop() {
        animator.stopAnimation(true)
    }
    
    public func setFractionComplete(_ fractionComplete: CGFloat) {
        animator.fractionComplete = fractionComplete
    }
    
    public func reverse(_ reverse: Bool) {
        animator.isReversed = reverse
    }
    
    private func singleStepAnimation() -> () -> () {
        return animations(for: sequence.steps.first!)
    }

    private func keyframeAnimations() -> () -> () {
        return {
            UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [], animations: {
                var relativeStartTime = 0.0
                self.sequence.steps.forEach { step in
                    let relativeDuration = step.duration/self.sequence.totalDuration
                    UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration, animations: self.animations(for: step))
                    relativeStartTime += relativeDuration
                }
            }, completion: nil)
        }
    }
    
    private func animations(for step: AnimationSequence.AnimationStep) -> (() -> ()) {
        return {
            step.animationBlocks.forEach { $0(self.sequence.view) }
            self.setProperty(viewProp: \.frame, stepProp: step.frame)
            self.setProperty(viewProp: \.bounds, stepProp: step.bounds)
            self.setProperty(viewProp: \.center, stepProp: step.center)
            self.setProperty(viewProp: \.transform, stepProp: step.transform)
            self.setProperty(viewProp: \.alpha, stepProp: step.alpha)
            if let color = step.backgroundColor {
                self.sequence.view.backgroundColor = color
            }
//            self.setProperty(viewProp: \.backgroundColor, stepProp: step.backgroundColor)//Ends up being Optional<Optional<UIColor>> since UIView.backgroundColor is UIColor?
        }
    }
    
    private func setProperty<T>(viewProp: ReferenceWritableKeyPath<UIView, T>, stepProp: T?) {
        guard let stepProp = stepProp else {
            return
        }
        sequence.view[keyPath: viewProp] = stepProp
    }
    public let animator: UIViewPropertyAnimator
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
