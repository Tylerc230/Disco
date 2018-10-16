public struct AnimationSequence {
    public enum TimingType {
        case predefined(UIViewAnimationCurve)
        case bezier(CGPoint, CGPoint)
        case springBased(CGFloat)
        case timingParameters(UITimingCurveProvider)
    }
    
    public typealias Completion = (UIViewAnimatingPosition) -> ()
    public typealias AnimationBlock = (UIView) -> ()
    
    public func setTiming(_ timing: TimingType) -> AnimationSequence {
        var newSequence = self
        newSequence.timing = timing
        return newSequence
    }
    
    public func duration(_ duration: TimeInterval) -> AnimationSequence {
        var newSequence = self
        newSequence.currentStep.duration = duration
        return newSequence
    }
    
    public func then() -> AnimationSequence {
        var newSequence = self
        newSequence.steps.append(AnimationStep())
        return newSequence
    }
    
    public func updateFrame(to frame: CGRect) -> AnimationSequence {
        return setCurrentStep(property: \AnimationStep.frame, to: frame)
    }
    
    public func updateBounds(to bounds: CGRect) -> AnimationSequence {
        return setCurrentStep(property: \AnimationStep.bounds, to: bounds)
    }
    
    public func moveCenter(to point: CGPoint) -> AnimationSequence {
        return setCurrentStep(property: \AnimationStep.center, to: point)
    }
    
    public func setTransform(to transform: CGAffineTransform) -> AnimationSequence {
        return setCurrentStep(property: \AnimationStep.transform, to: transform)
    }
    
    public func setAlpha(to alpha: CGFloat) -> AnimationSequence {
        return setCurrentStep(property: \AnimationStep.alpha, to: alpha)
    }
    
    public func setBackgroundColor(to backgroundColor: UIColor) -> AnimationSequence {
        return setCurrentStep(property: \AnimationStep.backgroundColor, to: backgroundColor)
    }
    
    public func addAnimationBlock(_ animationBlock: @escaping AnimationBlock) -> AnimationSequence {
        var newSequence = self
        newSequence.currentStep.animationBlocks.append(animationBlock)
        return newSequence
    }
    
    public func addCompletion(_ completion: @escaping Completion) -> AnimationSequence {
        var newSequence = self
        newSequence.completions.append(completion)
        return newSequence
    }
    
    public func paused() -> AnimationRunner {
        let runner = AnimationRunner(sequence: self)
        return runner
    }
    
    @discardableResult
    public func start() -> AnimationRunner {
        let runner = paused()
        runner.start()
        return runner
    }
    
    internal struct AnimationStep {
        var duration: TimeInterval = 0.25
        var frame: CGRect?
        var bounds: CGRect?
        var center: CGPoint?
        var transform: CGAffineTransform?
        var alpha: CGFloat?
        var backgroundColor: UIColor?
        var animationBlocks: [AnimationBlock] = []
    }
    
    internal init(view: UIView) {
        self.view = view
    }
    
    internal mutating func popStep() -> AnimationStep {
        let step = steps.first
        steps.removeFirst()
        return step!
    }

    internal var totalDuration: TimeInterval {
        return steps.map { $0.duration}.reduce(0, +)
    }
    
    internal var isKeyframeAnimation: Bool {
        return steps.count > 1
    }
    
    private func setCurrentStep<P>(property: WritableKeyPath<AnimationStep, P>, to value: P) -> AnimationSequence {
        var newSequence = self
        newSequence.currentStep[keyPath: property] = value
        return newSequence
    }

    private var currentStep: AnimationStep {
        get {
            return steps.last!
        }
        set {
            steps.removeLast()
            steps.append(newValue)
        }
    }
    internal let view: UIView
    internal var timing: TimingType = .predefined(.easeInOut)
    internal var steps = [AnimationStep()]
    internal var completions = [Completion]()
}

