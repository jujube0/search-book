# 스크린샷

<img src="https://github.com/jujube0/search-book/assets/60654009/f1aa6b68-1bb3-4d82-a69e-4d9c0fdd76d1" width=20%> <img src="https://github.com/jujube0/search-book/assets/60654009/58bf56ef-efdd-4874-8a78-9a49e9c349c8" width=20%> <img src="https://github.com/jujube0/search-book/assets/60654009/eb77b6e9-8cc0-4cf1-bb86-0cd8637e303a" width=20%>


# 화면 및 주요 기능, 구현
## 1. 검색화면
<img src="https://github.com/jujube0/search-book/assets/60654009/f1aa6b68-1bb3-4d82-a69e-4d9c0fdd76d1" width=20%>

- UICollectionView, FlowLayout 사용
- itbookAPI 사용
- pagination

## 2. 상세화면
<img src="https://github.com/jujube0/search-book/assets/60654009/58bf56ef-efdd-4874-8a78-9a49e9c349c8" width=20%>

- 아래 형태의 데이터를 파싱하기 위해 DynamicCodingKeys를 추가하여 이용
```
{
  "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
  "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
}
```
```
// 사전에 정의되지 않은 임의의 문자열을 키로 이용하기 위해 추가됨
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

```

## 3. PDF 화면
<img src="https://github.com/jujube0/search-book/assets/60654009/eb77b6e9-8cc0-4cf1-bb86-0cd8637e303a" width=20%>

- PDFKit 사용
