# Git 트러블슈팅 기록

## git commit --amend

### 참여자

- wow2658: commit --amend 실습 및 기록

### 상황

가장 최근 커밋의 메시지에 오타가 발생했거나 누락된 변경 사항이 있어, 새로운 커밋을 추가하지 않고 직전 커밋을 수정했다.

### 실행 명령

```bash
# 오타가 있는 커밋 생성
git commit -m "docs: add amend demo textt"

# 커밋 메시지 수정
git commit --amend -m "docs: add amend demo text"

# 누락된 파일 추가 반영 (메시지 유지)
git add wow2658/src/practice/amend-demo.txt
git commit --amend --no-edit
```

### 실제 결과

- `git commit --amend` 실행 후 최근 커밋 메시지가 `docs: add amend demo text`로 수정됐다.
- amend는 직전 커밋과 같은 부모를 가진 새 커밋을 만들어 직전 커밋을 대체했다.
- `git log -1`을 통해 커밋 메시지와 변경 사항이 정상 반영된 것을 확인했다.

`git reflog`로 확인한 amend 전후의 실제 커밋 해시는 다음과 같다.

| 단계 | 커밋 해시 | 커밋 메시지 | 변경 내용 |
| --- | --- | --- | --- |
| 최초 커밋 | `344b67a` | `docs: add amend demo textt` | 메시지에 `textt` 오타가 있는 실습 커밋 생성 |
| 메시지 수정 후 | `362872a` | `docs: add amend demo text` | `git commit --amend -m`으로 메시지만 수정 |
| 누락된 내용 추가 후 | `976f377` | `docs: add amend demo text` | `git commit --amend --no-edit`으로 메시지는 유지하고 파일 내용 추가 |

해시는 `344b67a → 362872a → 976f377` 순서로 바뀌었다. 세 커밋의 부모는 모두 `969f6ca`로 동일하므로, 각각 직전 커밋 다음에 추가된 것이 아니라 같은 위치의 커밋을 대체한 것을 확인했다. 대체 전 커밋도 로컬 reflog에서 확인할 수 있었다.

실습에 해당하는 reflog 기록만 조회한 명령:

```bash
git reflog show feature/wow2658-amend-practice --format="%h %gs" --grep-reflog="amend demo"
```

실제 출력은 최근 기록부터 표시된다.

```text
976f377 commit (amend): docs: add amend demo text
362872a commit (amend): docs: add amend demo text
344b67a commit: docs: add amend demo textt
```

![01-초기 커밋](../wow2658/images/01-initial-commit-typo.png)
![02-메시지 수정](../wow2658/images/02-amend-commit-message.png)
![03-no-edit 반영](../wow2658/images/03-amend-no-edit.png)

### 선택 이유

사소한 오타나 파일 누락 때문에 불필요한 추가 커밋을 생성하지 않고 깔끔한 커밋 히스토리를 유지하기 위해 사용했다.

### 주의점

원격 저장소(GitHub)에 이미 push된 커밋을 amend하면 커밋 해시가 변경되어 원격과 충돌이 발생한다. 따라서 로컬에만 존재하는 커밋에 사용하는 것이 안전하다.


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
