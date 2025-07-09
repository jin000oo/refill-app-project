# Re:fill

## ✅ 개발 전 필독

### 긴가민가한 코드는 ChatGPT에게 검토받기!

### 📌 개발 순서
1. **개발 전, Github에서 변경 사항 확인 먼저!**
    - 변경 사항을 반영하지 않고 커밋하면 충돌이 발생할 수 있음
2. **개발은 반드시 자신의 브랜치에서 진행**
    - `master`에서 직접 개발하면 오류 발생 시 전체에 영향
3. **작업 완료 후 Pull Request 보내기**
    - “내가 이렇게 개발했는데 master에 적용해도 될까요?” 요청
4. **PR 승인(Merge Confirm)되면 master에 반영**
    - 리뷰 결과 문제가 없다면 `master`에 병합
5. **master 변경사항을 다시 자신의 브랜치로 가져와서 작업 이어가기**
    - 최신 상태 유지 필수!
  
  
## 🔀 Git 브랜치 전략 안내

### ✅ 1. 개인 브랜치 작업 구분

- **UI 작업 브랜치**
  - `yuna/` : 곽유나 UI 개발 브랜치
  - `seoyoung/` : 김서영 UI 개발 브랜치
  - → 최종적으로 `UI_merged` 브랜치에 병합

- **Backend 작업 브랜치**
  - `yujin/` : 전유진 Backend 개발 브랜치
  - `jinyoung/` : 양진영 Backend 개발 브랜치
  - → 최종적으로 `firebase_sub_merged` 브랜치에 병합

---

### ✅ 2. 병합 흐름 (Merge Flow)

```plaintext
[yuna]    ──┐
            ├──▶    UI_merged      ───┐
[seoyoung] ─┘                         │
                                      ├──▶ sub_main ───▶ main
[yujin]  ───┐                         │
            ├──▶ firebase_sub_merged ─┘
[jinyoung] ─┘



### 📝 Commit 규칙
1. 커밋 후 `push` 까지 완료할 것!
2. 커밋 메시지는 **구체적**이고 **의미 있게** 작성
3. 검토 후 오류가 없으면 `pull request` 생성

### 🧾 Commit 메시지 작성법
1. **제목과 본문은 한 줄 띄워 구분**
2. **제목은 50자 이내**, 마침표 ❌
3. **본문 각 줄은 72자 이내**
4. **무엇을** 하고 **왜** 했는지 작성 (어떻게는 X)

---

## 📚 참고자료
For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
