import UIKit

protocol PrintDelegate : NSObjectProtocol {
    func goPrintVC()
}



class MainViewController: UIViewController {
    private let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    @IBAction func navigationBtnClick(_ sender: Any) {
        //show
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollectionView()
        settingActionSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        albumCollectionView.reloadData()
    }
    
    func settingCollectionView(){
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.reloadData()
    }
    
    func settingActionSheet(){
        //옵션 메뉴 설정
        let newAlbum = UIAlertAction(title: "새로운 앨범", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let albumSettingVC = self.storyboard?.instantiateViewController(identifier: "albumSettingVC") as! AlbumSettingController
            albumSettingVC.shareIndex = false
            self.navigationController?.pushViewController(albumSettingVC, animated: true)
        })
        
        let newShareAlbum = UIAlertAction(title: "새로운 공유 앨범", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let albumSettingVC = self.storyboard?.instantiateViewController(identifier: "albumSettingVC") as! AlbumSettingController
            albumSettingVC.shareIndex = true
            self.navigationController?.pushViewController(albumSettingVC, animated: true)
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        
        //action sheet에 옵션 추가
        optionMenu.addAction(newAlbum)
        optionMenu.addAction(newShareAlbum)
        optionMenu.addAction(cancel)
    }
    
}


extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    //item의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 2) - 15
        let height = self.view.frame.height / 4.5
        return CGSize(width: width, height: height)
    }
    
    //cell 클릭시 엑션
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let data = AlbumModel.albumList[indexPath.row]
        
        //cell 클릭 시 넘어갈 화면 분기
        //앨범 설정값이 nil -> AlbumSettingVC
        //앨범 설정값이 있고 테마값이 nil -> AlbumThemeVC
        //다 있으면 -> AlbumDetailVC
        
        if(data.period == nil){
            let albumSettingVC = storyboard?.instantiateViewController(identifier: "albumSettingVC") as! AlbumSettingController
            albumSettingVC.albumIndex = index
            navigationController?.pushViewController(albumSettingVC, animated: true)
        }else if(data.selectTheme == nil){
            let albumThemeVC = storyboard?.instantiateViewController(identifier: "albumThemeVC") as! AlbumThemeController
            albumThemeVC.albumIndex = index
            navigationController?.pushViewController(albumThemeVC, animated: true)
        }else {
            let albumDetailVC = storyboard?.instantiateViewController(identifier: "albumDetailVC") as! AlbumDetailController
            albumDetailVC.albumIndex = index
            navigationController?.pushViewController(albumDetailVC, animated: true)
        }
        
        
    }
    
    
}

extension MainViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumModel.albumList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let data = AlbumModel.albumList[indexPath.row]
        if let photoNum = data.numOfPhotos {
            if(photoNum == data.photos.count){
                cell.isFull = true
            }
        }else {
            cell.isFull = false
        }
        
        cell.albumImageView.image =  data.photos.first ?? UIImage()
        cell.albumNameLabel.text = data.albumName
        cell.delegate = self
    
        return cell
    }
    
    
}

extension MainViewController : PrintDelegate {
    func goPrintVC(){
        let albumPrintVC = storyboard?.instantiateViewController(identifier: "albumPrintVC") as! AlbumPrintController
        
        navigationController?.pushViewController(albumPrintVC, animated: true)
    }
    
}
