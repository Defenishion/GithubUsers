import UIKit

class SBAnimatedLoaderView: UIView {

    init(frame: CGRect, color: UIColor, spriteName: String, numberOfSprites: Int, animationDuration: NSTimeInterval, labelString: String, labelTextColor: UIColor) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.CGColor
        self.alpha = 0.0
        self.layer.cornerRadius = 10
        
        let imageView = UIImageView(frame:frame)
        imageView.contentMode = .ScaleAspectFit
        var spriteArray = [UIImage]()
        for i in 0 ..< numberOfSprites {
            if let image = UIImage(named: "\(spriteName)\(i)") {
                image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                spriteArray.append(image)
            }
        }
        
        imageView.animationImages = spriteArray
        imageView.animationDuration = animationDuration
        self.addSubview(imageView)
        imageView.startAnimating()
        
        let loadingLabel = UILabel(frame: CGRectMake(0, self.frame.height - 30, self.frame.size.width, 20))
        loadingLabel.text = labelString
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .Center
        loadingLabel.textColor = labelTextColor
        self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);

        self.addSubview(loadingLabel)
    }
    
    func show() {
        UIView.animateWithDuration(0.3, animations: {
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1
        })
    }
    
    func hide() {
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);
            }, completion: { (done: Bool) -> Void in
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

