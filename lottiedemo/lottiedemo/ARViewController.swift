
import UIKit
import ARKit
import SceneKit
import Lottie

class ARViewController: UIViewController {
    
    private var arScnView: ARSCNView!
    private var animationView:AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //タイトル
        title = "ARView"
        //キャンセルボタン追加
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.onTapCancel(sender:)))
        cancelButton.tintColor = UIColor.hex(COLOR.ACCENT, alpha: 1)
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
        
        arScnView = ARSCNView(frame: view.frame)
        arScnView.scene = SCNScene()
        //arScnView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        arScnView.allowsCameraControl = false
        view.addSubview(arScnView)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(self.tapped(_:)))
        arScnView.addGestureRecognizer(tapGesture)
        
        print("viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        arScnView.session.run(configuration)

        animationSet()
        
        arScnView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        arScnView.session.pause()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        //https://qiita.com/chino_tweet/items/a8a3f68cdadaf2e307ba
        guard let currentFrame = arScnView.session.currentFrame else { return  }
        
        let rate = animationView.animation!.size.height/animationView.animation!.size.width
        let w = 0.08 as CGFloat
        let h = w * rate
        let geometry = SCNPlane(width: CGFloat(w), height: CGFloat(h))
        
        let material = SCNMaterial()
        animationView.isOpaque = false
        material.diffuse.contents = animationView
        geometry.materials = [material]
        
        //geometry.firstMaterial?.diffuse.contents = animationView
        
        let node = SCNNode(geometry: geometry)
        arScnView.scene.rootNode.addChildNode(node)
        
        //前方2m
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.2
        node.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
    }
    
    private func animationSet(){
        //json パス取得
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documentDirectoryURL.appendingPathComponent( UserDefaults.standard.object(forKey: "filename") as! String)
        //アニメ
        animationView = AnimationView()
        animationView.animation = Animation.filepath(path.path)
        animationView.frame = CGRect(x: 0, y: 0, width: animationView.animation!.size.width, height: animationView.animation!.size.height)
        //animationView.layer.position = CGPoint(x: UIScreen.main.bounds.size.width*1/2,y: view.bounds.width*1/2)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        animationView.backgroundColor = .clear
        animationView.play()
    }
    //戻る
    @objc internal func onTapCancel(sender: UIButton){
        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {self.view.alpha = 0.0},
                       completion: { _ in
                        let del = UIApplication.shared.delegate as! AppDelegate
                        del.popMain()})
    }
}
