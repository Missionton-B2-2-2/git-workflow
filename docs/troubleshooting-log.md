# Git 트러블슈팅 기록

## Git Revert — 원격에 Push된 Commit 취소

### 참여자
- @jangsoopark-codyssey

### 상황
원격 저장소에 이미 Push된 Commit의 변경 사항을 취소해야 하는 상황을 가정하였습니다.

실습 파일 `jangsoopark-codyssey/src/practice/revert-demo.txt`에 의도적으로 잘못된 내용을 추가한 후 Commit하고 원격 저장소에 Push하였습니다.

- 초기 Commit: `7d4f8b9`
- 잘못된 Commit: `29c8b21`

### 시도한 명령 및 절차

잘못된 Commit을 취소하기 위해 다음 명령어를 실행하였습니다.

```bash
git revert 29c8b21
```

Revert 이후 Commit History를 확인하였습니다.

```bash
git log -3 --oneline --graph
```

초기 Commit과 Revert 이후 파일 상태를 비교하였습니다.

```bash
git diff 7d4f8b9 da7e3b8 -- jangsoopark-codyssey/src/practice/revert-demo.txt
```

이후 원격 저장소에 Push하였습니다.

```bash
git push origin feature/jangsoopark-revert-practice
```

### 결과

- 새로운 Revert Commit `da7e3b8`이 생성되었습니다.
- 기존 Commit `29c8b21`은 History에 유지되었습니다.
- 실습 파일의 내용이 초기 상태로 복구되었습니다.
- `git diff` 결과가 출력되지 않아 초기 Commit과 Revert 이후 파일 내용이 동일함을 확인하였습니다.
- Revert Commit을 원격 저장소에 Push하였습니다.

### 왜 이 방법을 선택하였는가?

`git reset`은 브랜치의 Commit 참조를 이전 상태로 이동시키므로 이미 공유된 History를 변경하려면 추가적인 처리가 필요할 수 있습니다.

반면 `git revert`는 기존 Commit History를 유지하면서 변경 사항을 취소하는 새로운 Commit을 생성합니다.

따라서 원격 저장소에 Push된 변경 사항을 취소하는 이번 상황에서는 `git revert`가 적절하다고 판단하였습니다.

### 주의사항

- Revert 대상 Commit 이후 다른 변경이 발생한 경우 Conflict가 발생할 수 있습니다.
- Revert Commit 역시 원격 저장소에 Push해야 다른 팀원에게 반영됩니다.
- 공유 브랜치에서는 기존 History를 재작성하는 방법보다 변경 취소 이력을 남기는 방법이 안전합니다.

### 증빙

- [Git Revert 학습 노트](../jangsoopark-codyssey/notes/git-revert.md)
- [Git Revert 실습 증빙](../jangsoopark-codyssey/assets/images/git-revert-practice-evidence.png)
- [Revert Commit](https://github.com/Missionton-B2-2-2/git-workflow/commit/da7e3b8)


## git stash 및 git stash pop

### 참여자

- greenable-7: stash 실습 및 기록

### 상황

커밋하지 않은 작업을 임시로 보관하고 다른 브랜치로 이동한 뒤, 원래 브랜치에서 작업을 복원했다.

### 실행 명령

```bash
git stash push -m "greenable stash practice"
git switch main
git switch feature/greenable-stash-practice
git stash pop
```

### 실제 결과

- stash 전: `stash-demo.txt`가 수정된 상태였다.
- stash 후: `working tree clean` 상태가 됐다.
- `git stash list`에서 `greenable stash practice`를 확인했다.
- `git stash pop` 후 수정 내용이 복원됐다.
- `Dropped refs/stash@{0}`가 표시됐고 stash 목록이 비었다.

### 선택 이유

완성되지 않은 작업을 커밋하지 않고 잠시 보관한 상태에서 다른 브랜치로 이동하기 위해 사용했다.

### 주의점

`git stash pop`은 복원에 성공하면 stash 목록에서 해당 항목을 제거한다. 보관 기록을 유지하면서 복원하려면 `git stash apply`를 사용할 수 있다.


## git reset --soft HEAD~1 (로컬 커밋 취소 + 변경 유지)

### 참여자

- hyojun-edu: git soft reset 실습 및 기록

### 상황

로컬에서 커밋을 했는데 다시 읽어보니 추가 수정이 필요한 사항이 있는 것을 발견,
커밋을 취소하고 변경 작업을 마친 후에 다시 커밋하려고 함.

### 실행 명령 및 결과

```
% git log -1
commit e40c776165ce111caf3a89db86e2def42f51db63 (HEAD -> feature/git-reset-study-note)
Author: hyojun <hyojun@knou.ac.kr>
Date:   Wed Oct 14 15:53:18 2026 +0900

    docs: git soft reset 활용 학습노트 작성

% git reset --soft HEAD~1
% git log -1
commit 969f6ca69a0113f5a23fdc93a4e29391d9836ad5 (HEAD -> feature/git-reset-study-note, origin/main, origin/HEAD, main)
Merge: ae5c54b ccd9a10
Author: greenable-7 <dreamitator@naver.com>
Date:   Wed Oct 14 15:34:26 2026 +0900

    Merge pull request #15 from Missionton-B2-2-2/feature/greenable-stash-practice
    
    docs: add git stash learning note and practice record

% git status
On branch feature/git-reset-study-note
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   docs/troubleshooting-log.md

% git add .
% git commit -m "docs: git soft reset 활용 학습노트 작성"
% git log -1
git log -1
commit 03c031b151f82d5f6f2e2d9d4ef442b4be17e33a (HEAD -> feature/git-reset-study-note)
Author: hyojun <hyojun@knou.ac.kr>
Date:   Wed Oct 14 15:55:01 2026 +0900

    docs: git soft reset 활용 학습노트 작성
```

### 선택 이유

그냥 커밋을 한 번 더 해서 누락된 내용을 추가할 수도 있지만, soft reset을 이용해서 각 커밋을 더 완결성 있게 만들면 PR 리뷰를 진행할 때 커밋 단위로 보기 편하고 커밋 히스토리도 간결하게 만들 수 있기 때문에 soft reset을 활용했습니다.

