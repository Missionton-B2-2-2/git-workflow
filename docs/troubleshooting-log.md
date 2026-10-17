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

## 기존 담당자 작업 중단에 따른 Feature Branch 및 PR 인계

### 참여자
- @hyojun-edu: 기존 작업 및 PR #21 생성
- @jangsoopark-codyssey: 후속 작업 인계 및 Merge Conflict 해결

### 상황
- Issue #13은 GitHub Flow를 선택한 이유를 `README.md` 또는 `docs/CONTRIBUTING.md`에 3줄 이내로 기록하는 작업임.
- 기존 담당자가 개인 사정으로 작업을 지속하기 어려워져 PR #21이 미완료 상태로 남음.
- PR #21의 작업 브랜치 `feature/why-gitflow-doc`은 원격에 보존되어 있었으며, 최신 `main`과 `README.md` 충돌이 발생한 상태였음.
- 새 PR을 생성하거나 기존 커밋을 재작성하는 대신, 다른 팀원이 기존 브랜치에서 작업을 계속하기로 결정함.

### 시도한 명령 및 절차
1. 원격 Feature Branch를 로컬에서 Checkout하고 Tracking 상태 및 기존 Commit을 확인함.

```bash
git branch -vv
git log -5 --oneline
# feature/why-gitflow-doc: c752367
```

2. Working Tree가 깨끗한 상태임을 확인한 후 최신 `main`을 병합함.

```bash
git status
git fetch origin
git merge origin/main
# CONFLICT (content): Merge conflict in README.md
```

3. `git status`와 `git diff -- README.md`로 충돌을 확인한 뒤, VS Code에서 기존 작업자의 설명과 `main`의 학습 노트 목차를 통합함.
4. README의 `Gitflow` 표현과 선택 이유를 과제에서 사용하는 `GitHub Flow`에 맞게 수정함.
5. `git add README.md`로 충돌 해결 내용을 Staging하고, 해결 내역은 `docs/conflict-resolution.md`의 충돌 기록 3에 분리하여 기록함.

### 결과
- 기존 작성자의 원격 브랜치와 Commit `c752367`을 유지한 채 후속 작업을 완료함.
- 기존 Issue #13과 PR #21의 연결 관계를 유지하여 작업 이력을 보존함.
- `README.md`의 충돌 내용을 수동으로 수정하고 Staging을 완료함.
- Merge Commit `b4bebda`를 생성하고 `git push origin feature/why-gitflow-doc`을 통해 원격 브랜치에 반영하여 PR #21의 충돌을 해결함.
- PR #21의 Review 의견을 반영하여 GitHub Flow 설명 및 작업 인계 기록을 보완함.

### 왜 이 방법을 선택하였는가?
- 기존 Feature Branch를 이어받으면 이전 담당자의 Commit과 PR 논의가 그대로 보존됨.
- 별도의 PR을 생성하는 것보다 기존 작업의 목적, 검토 과정 및 변경 이력을 추적하기 쉬움.
- 최신 `main`을 병합하는 방식은 공유된 기존 Commit History를 재작성하지 않으므로 협업 중 안전성이 높음.

### 주의사항
- 동일 브랜치에 Push하기 전에 원격 Write 권한과 다른 팀원의 동시 작업 여부를 확인해야 함.
- 공유 브랜치에 무단 Force Push 또는 History Rewriting을 수행하지 않음.
- 기존 PR 작성자와 후속 작업자의 기여를 구분하고, PR 코멘트에 인계 사실을 남기는 것이 바람직함.
- 작업 인계 사유는 개인정보를 공개하지 않는 범위에서 기록함.
- 이 사례는 과제의 Git 명령어 Troubleshooting 4종과 별개의 실제 협업 대응 사례임.

### 증빙
- [Issue #13](https://github.com/Missionton-B2-2-2/git-workflow/issues/13)
- [PR #21](https://github.com/Missionton-B2-2-2/git-workflow/pull/21)
- [충돌 해결 기록 3](conflict-resolution.md)

