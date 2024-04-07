# BeatCoin
나만의 실시간 코인 관리 매니저 BeatCoin!<br>
실시간 인기 코인을 조회하고, 나만의 코인으로 즐겨찾기하세요.<br>
그래프로 한눈에 알 수 있는 코인 동향까지<br>
<br>

## 📱스크린샷
<img src="https://github.com/thekoon0456/BeatCoin/assets/106993057/91e28e85-62e3-4cb5-9f86-1072a512b940" width="150" style="padding-left: 40px;"></img>
<img src="https://github.com/thekoon0456/BeatCoin/assets/106993057/25553be9-29df-4159-8f5d-5af1431ad54c" width="150" style="padding-left: 40px;"></img>
<img src="https://github.com/thekoon0456/BeatCoin/assets/106993057/1ede37ea-543a-46f7-b532-7e7237993f6e" width="150" style="padding-left: 40px;"></img>
<img src="https://github.com/thekoon0456/BeatCoin/assets/106993057/8b5202fd-c17a-4c33-9080-5cb89145416d" width="150" style="padding-left: 40px;"></img>
<img src="https://github.com/thekoon0456/BeatCoin/assets/106993057/d14e214e-80de-44e6-86e5-bffc5f0cbd38" width="150" style="padding-left: 40px;"></img>
<br>

## 📌 주요 기능
- 현재 인기 코인과 NFT의 순위와 실시간 가격 확인 가능
- 코인을 검색하고 즐겨찾기 저장 가능
- 선택한 Coin의 가격, 동향을 Chart로 확인 가능
- 사용자의 프로필 사진 저장 가능
<br>

## 기술스택
- UIKit, MVVM-C, Input-Output, Singleton, Repository
- Alamofire, CustomObservable
- DGCharts, Realm
- Kingfisher, SnapKit
<br>

## 개발 환경
- 개발 인원 : 1인 개발
- 개발 기간 : 2024.03 ~ 2024.03 (6일)
- 최소 버전 : iOS 15.0
- iPhone SE3 ~ iPhone 15 Pro Max 전 기종 호환 가능
<br>

## 구현 기술
- MVVM의 Input-Output Pattern과 CustomObservableClass를 활용한 데이터 바인딩
- Coordinator Pattern으로 ViewController의 화면 전환 코드 분리와 의존성 관리
- CoinAPI의 다양한 DTO를 Entity로 변환하여 네트워크 계층과 뷰 계층 분리
- Alamofire의 URLRequestConvertible를 활용한 RouterPattern으로 네트워크 추상화
- API와 Realm을 Repository Pattern을 활용하여 구조화, 데이터 계층과 뷰 계층 분리
- Compositional Layout을 활용해 한 화면에서 복잡한 구조의 Layout 구현
- DGCharts 라이브러리를 활용해 코인 Chart 그래프 화면 구현
- 접근제어자를 활용한 코드의 은닉화 및 컴파일 최적화를 통한 성능 개선
- Network ErrorHandling과 Alert 구현
- Data, Coordinator, Repository, ViewModel Protocol을 채택해 구조화된 코드 구현
- CustomToast를 구현해 사용자에게 직관적이고 반응성 있는 피드백 제공
- BaseUI 상속으로 일관된 ViewController 구조 형성
<br>

## ✅ 트러블 슈팅
### 다양한 Type의 Data를 앱 내에서 관리하기 위해 DTO와 Entity 사용
<div markdown="1">
CoinAPI를 통해 가져온 Data를 앱 내에서 가공해서 사용해서 사용해야 했습니다.<br>
ViewModel에서 데이터를 변환하려면 DTO를 ViewModel이 알고 있기 때문에 유지보수가 어려워지는 문제가 있었습니다.<br>
DTO에서 toEntity 연산프로퍼티를 만들어 바로 Entity로 변환해주고,<br>
CoinData를 가져오는 Repository를 활용해서 요청을 하면<br>
ViewModel에서는 DTO는 모른채로 Entity만 가지고 활용하도록 구현했습니다.<br>
서버에서 내려주는 Data가 바뀌어도 유지보수하기 쉽도록 구현했습니다.<br>
<br>

```swift
//TrendingDTO
struct TrendingDTO: DTO {
    let coins: [Coin]
    let nfts: [Nft]
    let categories: [Category]
    
    // MARK: - ToEntity
    
    var toEntity: TrendingEntity {
        let coins = self.coins.map { $0.toEntity }
        let nfts = self.nfts.map { $0.toEntity }
        return TrendingEntity(coins: coins, nfts: nfts)
    }
}

//TrendingRepository
final class TrendingRepository: Repository {
    func fetch(router: APIRouter, completionHandler: @escaping ((Result<TrendingEntity, Error>) -> Void)) {
        APIService.shared.callRequest(router: router,
                                      type: TrendingDTO.self) { data in
            switch data {
            case .success(let success):
                print(success)
                completionHandler(.success(success.toEntity))
            case .failure(let failure):
                print(failure.localizedDescription)
                completionHandler(.failure(failure))
            }
        }
    }
}
```
</div>
<br>

### 한정된 무료 API 콜수로 연결이 끊기는 문제가 빈번하게 발생
<div markdown="1">
꼼꼼한 상황별 Error처리를 통해<br>
사용자에게 현재 Server상황을 알려주고, 연결 재시도를 요청할 수 있도록 구현<br>
<br>

```swift
//CCError
enum CCError: Int, CaseIterable, Error {
    case badRequest = 400
    case Unauthorised = 401
    case tooManyRequests = 429
    case serviceUnavailable = 503
    case internalServerError = 500
    case apiKeyMissing = 10002
    case notEndPoint = 0005
    case forbidden = 403
    case accessDenied = 1020
    case unKnown
    
    var description: String {
        switch self {
        case .badRequest:
            "유효하지 않은 요청입니다. 재시도 해주세요."
        case .Unauthorised:
            "승인되지 않은 계정입니다. 계정을 확인해주세요."
        case .tooManyRequests:
            "요청이 너무 많습니다. 잠시 후 재시도 해주세요."
        case .serviceUnavailable:
            "현재 이용할 수 없는 서비스입니다. 다른 기능을 사용해주세요."
        //...
        }
    }
}

//TrendingViewModel
private func callRequest(group: DispatchGroup) {
    group.enter()
    trendingRepository.fetch(router: .trending) { [weak self] trending in
        defer { group.leave() }
        guard let self else { return }
        switch trending {
        case .success(let success):
            output.trendingCoinData.onNext(success.coins)
            output.trendingNFTData.onNext(success.nfts)
        case .failure(let failure):
            output.error.onNext(checkError(error: failure))
        }
    }
}

func checkError(error: Error) -> CCError {
    guard let code = error.asAFError?.responseCode,
          let error = CCError(rawValue: code)
    else { return .unKnown }
    return error
}
```
</div>
<br>

### Toast와 Alert을 다양한 Tab과 화면에서 사용하면서 발생하는 관리의 어려움과 중복코드 발생
<div markdown="1">
Toast뷰와 Alert뷰는 다양한 Tab과 화면에서 나오게 되는데<br>
그때마다 초기화하면 관리가 힘들고, 중복된 코드가 발생하게 되는 문제가 있었습니다.<br>
Coordinator를 도입하고, Extension으로 alert과 toast 뷰를 추가해<br>
어떤 Coordinator에서도 alert과 toast뷰를 바로 사용할 수 있도록 한 곳에서 관리했습니다.<br>
<br>

```swift
//Coordinator+
extension Coordinator {
    func showAlert(title: String = "오류가 발생했어요",
                   message: String,
                   okButtonTitle: String = "확인",
                   primaryButtonTitle: String,
                   okAction: (() -> Void)? = nil,
                   primaryAction: (() -> Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        //...
        navigationController?.present(alert, animated: true)
    }
    
    func showToast(_ type: Toast) {
        let vc = ToastViewController(inputMessage: type.message)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            vc.dismiss(animated: true)
        }
    }
}

//CoinSearchViewModel
func showToast(_ type: Toast) {
  coordinator?.showToast(type)
}

//FavoriteViewModel
func showAlert(error: CCError) {
    coordinator?.showAlert(message: error.description,
                           okButtonTitle: CCConst.Ments.dismiss.text,
                           primaryButtonTitle: CCConst.Ments.retry.text) { [weak self] in
        guard let self else { return }
        input.viewWillAppear.onNext(())
    }
}
```
</div>
<br>
