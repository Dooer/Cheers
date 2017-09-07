import UIKit

/// The view to show particles
open class CheerView: UIView {
    public var configs = [Config()]
    var emitter: CAEmitterLayer?
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        isUserInteractionEnabled = false
    }
    
    
    public class func animateInView(_ view: UIView, coinIcon: UIImage, billIcon: UIImage) -> Void {
        let cheerView = CheerView(frame: view.bounds)
        view.addSubview(cheerView)
        cheerView.start(coinIcon: coinIcon, billIcon: billIcon)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            cheerView.stop()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            cheerView.removeFromSuperview()
        }
    }
    
    open func start(coinIcon: UIImage, billIcon: UIImage) {
        stop()
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: bounds.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: bounds.width, height: 1)
        emitter.renderMode = kCAEmitterLayerBackToFront
        let config = self.configs.first ?? Config()
        let colors = config.colors.shuffled()
        var cells = [CAEmitterCell]()
        
        zip(pickImages(type: .image([billIcon])), colors.shuffled()).forEach { image, color in
            let cell = CAEmitterCell()
            cell.birthRate = 15
            cell.lifetime = 20.0
            cell.lifetimeRange = 10
            cell.velocity = 250
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi * 0.2
            cell.spinRange = 5
            cell.scale = 0.25
            cell.scaleRange = 0.2
            cell.alphaSpeed = 0
            cell.contents = image.cgImage
            cell.xAcceleration = 20
            cell.yAcceleration = 30
            
            cells.append(cell)
        }
        
        zip(pickImages(type: .image([coinIcon])), colors.shuffled()).forEach { image, color in
            let cell = CAEmitterCell()
            cell.birthRate = 15
            cell.lifetime = 20.0
            cell.lifetimeRange = 10
            cell.velocity = 250
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi * 0.2
            cell.spinRange = 5
            cell.scale = 0.3
            cell.scaleRange = 0.2
            cell.alphaSpeed = 0
            cell.contents = image.cgImage
            cell.xAcceleration = 50
            cell.yAcceleration = 30
            cells.append(cell)
        }
        
        zip(pickImages(type: .confetti), colors.shuffled()).forEach { image, color in
            let cell = CAEmitterCell()
            cell.birthRate = 20
            cell.lifetime = 20.0
            cell.lifetimeRange = 10
            cell.velocity = 250
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi * 0.2
            cell.spinRange = 5
            cell.scale = 0.3
            cell.scaleRange = 0.2
            cell.color = color.cgColor
            cell.alphaSpeed = -0.1
            cell.contents = image.cgImage
            cell.xAcceleration = 20
            cell.yAcceleration = 50
            cell.redRange = 0.8
            cell.greenRange = 0.8
            cell.blueRange = 0.8
            
            cells.append(cell)
        }
        emitter.emitterCells = cells.shuffled()
        emitter.beginTime = CACurrentMediaTime()
        
        config.customize?(cells)
        
        layer.addSublayer(emitter)
        self.emitter = emitter
        
    }
    
    
    /// Stop animation
    public func stop() {
        emitter?.birthRate = 0
    }
    
    open func pickImages(type: Particle) -> [UIImage] {
        let generator = ImageGenerator()
        
        switch type {
        case .confetti:
            return [generator.rectangle(),
                    generator.triangle(), generator.curvedQuadrilateral()]
                .flatMap({ $0 })
        case .image(let images):
            return images
        case .text(let size, let strings):
            return strings.flatMap({ generator.generate(size: size, string: $0) })
        }
    }
}
