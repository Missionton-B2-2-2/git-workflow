# Git 트러블슈팅 기록

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