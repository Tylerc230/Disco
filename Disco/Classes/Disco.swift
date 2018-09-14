public struct AnimationSequence {
    public enum TimingType {
        case predefined(UIViewAnimationCurve)
        case bezier(CGPoint, CGPoint)
        case springBased(CGFloat)
        case timingParameters(UITimingCurveProvider)
    }
    
    public func duration(_ duration: TimeInterval) -> AnimationSequence {
        var newSequence = self
        newSequence.currentStep.duration = duration
        return newSequence
    }
    
    public func moveCenter(to point: CGPoint) -> AnimationSequence {
        var newSequence = self
        newSequence.currentStep.center = point
        return newSequence
    }
    
    public func start() -> AnimationRunner {
        let runner = AnimationRunner(sequence: self)
        runner.start()
        return runner
    }
    
    internal struct AnimationStep {
        var duration: TimeInterval = 0.25
        var center: CGPoint?
    }
    
    internal init(view: UIView) {
        self.view = view
    }
    
    internal mutating func popStep() -> AnimationStep {
        let step = steps.first
        steps.removeFirst()
        return step!
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
    private var steps = [AnimationStep()]
}

