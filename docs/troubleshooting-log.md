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
- 새로운 커밋이 쌓이지 않고 직전 커밋의 해시(Hash)가 갱신되면서 덮어씌워졌다.
- `git log -1`을 통해 커밋 메시지와 변경 사항이 정상 반영된 것을 확인했다.

![01-초기 커밋](../wow2658/images/01-initial-commit-typo.png)
![02-메시지 수정](../wow2658/images/02-amend-commit-message.png)
![03-no-edit 반영](../wow2658/images/03-amend-no-edit.png)

### 선택 이유

사소한 오타나 파일 누락 때문에 불필요한 추가 커밋을 생성하지 않고 깔끔한 커밋 히스토리를 유지하기 위해 사용했다.

### 주의점

원격 저장소(GitHub)에 이미 push된 커밋을 amend하면 커밋 해시가 변경되어 원격과 충돌이 발생한다. 따라서 로컬에만 존재하는 커밋에 사용하는 것이 안전하다.


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


## Merge Conflict (협업 브랜치 병합 충돌 해결)

### 참여자

- wow2658: main 브랜치 병합 충돌(Conflict) 해결 및 문서 재배치

### 상황

내 기능 브랜치(`feature/wow2658-amend-practice`)를 원격에 푸시하고 PR을 생성하려 했으나, 그사이 팀원들의 PR이 `main` 브랜치에 먼저 머지되면서 공통 문서(`README.md`, `docs/troubleshooting-log.md`)에서 충돌(`Can't automatically merge`)이 발생했다.

### 충돌 원인

기준 커밋(`969f6ca`) 이후, 원격 `main`과 내 로컬 브랜치 양쪽에서 동일한 파일들의 동일한 라인을 동시에 수정했기 때문에 Git이 자동으로 병합하지 못하고 3-way merge 충돌을 발생시켰다.

### 실행 명령

```bash
# 1. 원격 최신 변경사항 확인 및 로컬 브랜치로 병합 시도
git fetch origin
git merge origin/main

# 2. 충돌 파일 확인
git status

# 3. 충돌 마커(<<<<<<<, =======, >>>>>>>)를 확인하고 수동 병합 (Manual Merge)
# - 팀원들의 작업 내용을 모두 보존하면서 이슈 #6 번호 순서에 맞게 문단 재배치

# 4. 해결된 파일 스테이징 및 머지 커밋 생성
git add README.md docs/troubleshooting-log.md
git commit -m "Merge remote-tracking branch 'origin/main' into feature/wow2658-amend-practice"

# 5. 원격 브랜치로 푸시
git push origin feature/wow2658-amend-practice
```

### 실제 결과 및 증거

- `git merge origin/main` 실행 시 `README.md`와 `docs/troubleshooting-log.md`에서 충돌(`CONFLICT`)이 감지됐다.
- 수동으로 파일을 열어 충돌 마커를 제거하고 모든 팀원의 내용을 살려 이슈 번호 순서(amend -> reset -> stash)대로 재정렬했다.
- 머지 커밋(`5bfa4d4`)이 생성되었으며, `git log --graph`를 통해 두 브랜치가 성공적으로 합류한 것을 확인했다.
- GitHub PR 상태가 `Can't automatically merge`에서 `Able to merge`로 전환됐다.

![04-충돌 발생 감지](../wow2658/images/04-merge-conflict-detected.png)
![05-충돌 해결 및 머지 그래프](../wow2658/images/05-conflict-resolution-graph.png)

### 선택 이유

한쪽의 코드를 덮어쓰거나 강제 푸시(`--force`)하지 않고, 팀원들의 작업 성과를 온전히 보존하면서 공통 문서를 조화롭게 통합하기 위해 수동 3-way merge 방식을 선택했다.

### 주의점

충돌 마커(`<<<<<<< HEAD`, `=======`, `>>>>>>>`)를 하나라도 남겨두면 문서나 코드에 문법 오류가 발생할 수 있으므로 꼼꼼히 확인하고 제거해야 한다. 또한 내 코드뿐만 아니라 팀원의 코드 맥락도 함께 검토하여 누락되는 내용이 없도록 해야 한다.
