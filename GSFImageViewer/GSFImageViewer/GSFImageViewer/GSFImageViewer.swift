//
//  GSFImageViewer.swift
//  GSFImageViewer
//
//  Created by wwa-ios-taione on 2018/12/11.
//  Copyright © 2018 com.163.ws2103916. All rights reserved.
//

import UIKit

class GSFImageViewer: UIView {
    enum MoveState {
        case none
        case top
        case left
        case bottom
        case right
        case center
    }
    
    let mainImageView: UIImageView = UIImageView()
    let border = CAShapeLayer()
    /// 边的识别区域
    fileprivate(set) var moveLineWidth: CGFloat
    fileprivate var moveState: MoveState = .none
    fileprivate var touchPoints: [CGPoint] = []
    
    convenience init(imageFrame: CGRect, moveLineWidth: CGFloat = 30) {
        self.init(frame: CGRect(x: imageFrame.origin.x - moveLineWidth, y: imageFrame.origin.y - moveLineWidth, width: imageFrame.size.width + moveLineWidth * 2, height: imageFrame.size.height + moveLineWidth * 2))
        self.moveLineWidth = moveLineWidth
        setup()
    }
    override init(frame: CGRect) {
        self.moveLineWidth = 30
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
}
private extension GSFImageViewer {
    func setup() {
        setView()
        setGesture()
    }
    func setView() {
        
        mainImageView.image = #imageLiteral(resourceName: "image1.png")
        self.addSubview(mainImageView)
        mainImageView.frame = CGRect(x: moveLineWidth/2, y: moveLineWidth/2, width: self.bounds.width - moveLineWidth , height: self.bounds.height - moveLineWidth)
        
        //虚线的颜色
        border.strokeColor = UIColor.red.cgColor
        //填充的颜色
        border.fillColor = UIColor.clear.cgColor
        //设置路径
        
        border.frame = self.mainImageView.bounds
        border.path = UIBezierPath(rect: self.mainImageView.bounds).cgPath
        //虚线的宽度
        border.lineWidth = 1.0
        //设置线条的样式
//        border.lineCap = @"square";
        //虚线的间隔
        border.lineDashPattern = [4, 2]
        self.mainImageView.layer.addSublayer(border)
        
    }
    func setGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
        
    }
}

private extension GSFImageViewer {
    @objc func panGesture(gesture: UIGestureRecognizer) {
        let superLocation = gesture.location(in: self.superview)
        self.touchPoints.append(superLocation)
        if (self.touchPoints.count > 2) {
            self.touchPoints.removeFirst()
        }
        switch gesture.state {
        case .began:
            let selfLocation = gesture.location(in: self)
//            print("selfLocation: ",selfLocation,"self.frame: ",self.frame,"imageLocation:", gesture.location(in: self.mainImageView))
            if selfLocation.x > 0
                && selfLocation.x < moveLineWidth
                && selfLocation.y > moveLineWidth
                && selfLocation.y < self.bounds.size.height - moveLineWidth {
                print("left")
                self.moveState = .left
            } else if selfLocation.x > self.bounds.size.width - moveLineWidth
                && selfLocation.x < self.bounds.size.width
                && selfLocation.y > moveLineWidth
                && selfLocation.y < self.bounds.size.height - moveLineWidth {
                print("right")
                self.moveState = .right
            } else if selfLocation.x > moveLineWidth
                && selfLocation.x < self.bounds.size.width  - moveLineWidth
                && selfLocation.y > 0
                && selfLocation.y < moveLineWidth {
                print("top")
                self.moveState = .top
            } else if selfLocation.x > moveLineWidth//0
                && selfLocation.x < self.bounds.size.width - moveLineWidth
                && selfLocation.y > self.bounds.size.height - moveLineWidth
                && selfLocation.y < self.bounds.size.height {
                print("bottom")
                self.moveState = .bottom
            }else if selfLocation.x > moveLineWidth
                && selfLocation.x < self.bounds.size.width - moveLineWidth
                && selfLocation.y > moveLineWidth
                && selfLocation.y < self.bounds.size.height - moveLineWidth {
                self.moveState = .center
            } else {
                self.moveState = .none
            }
        case .changed:
            let fPoint = self.touchPoints.first ?? CGPoint.zero
            let lPoint = self.touchPoints.last ?? CGPoint.zero
            switch self.moveState {
            case .none:
                return
            case .top:
                let moveY = fPoint.y - lPoint.y
                var frame: CGRect = self.frame
                frame = CGRect(x: frame.origin.x, y: frame.origin.y - moveY, width: frame.size.width, height: frame.size.height + moveY)
                if frame.size.height < moveLineWidth {
                    frame.size.height = moveLineWidth
                    frame.origin.y = self.frame.origin.y + self.frame.size.height - moveLineWidth
                }
                self.frame = frame
            case .left:
                let moveX = fPoint.x - lPoint.x
                var frame: CGRect = self.frame
                frame = CGRect(x: frame.origin.x - moveX, y: frame.origin.y, width: frame.size.width + moveX, height: frame.size.height)
                if frame.size.width < moveLineWidth {
                    frame.size.width = moveLineWidth
                    frame.origin.x = self.frame.origin.x + self.frame.size.width - moveLineWidth
                }
                self.frame = frame
            case .bottom:
                let moveY = fPoint.y - lPoint.y
                var frame: CGRect = self.frame
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - moveY)
                if frame.size.height < moveLineWidth {
                    frame.size.height = moveLineWidth
                }
                self.frame = frame
            case .right:
                let moveX = fPoint.x - lPoint.x
                var frame: CGRect = self.frame
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width - moveX, height: frame.size.height)
                if frame.size.width < moveLineWidth {
                    frame.size.width = moveLineWidth
                }
                self.frame = frame
            case .center:
                var center = self.center
                let moveX = lPoint.x - fPoint.x
                center.x += moveX
                let moveY = lPoint.y - fPoint.y
                center.y += moveY
                self.center = center
            }
            self.mainImageView.frame = CGRect(x: moveLineWidth/2, y: moveLineWidth/2, width: self.bounds.width - moveLineWidth, height: self.bounds.height - moveLineWidth)
            border.frame = self.mainImageView.bounds
            border.path = UIBezierPath(rect: self.mainImageView.bounds).cgPath
        case .ended:
            self.moveState = .none
        case .possible,.cancelled,.failed:
            self.moveState = .none
        }
    }
}
