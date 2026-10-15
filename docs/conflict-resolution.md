# Git 충돌 해결 기록 (Conflict Resolution Log)

본 문서는 팀 협업 과정에서 발생한 충돌(Conflict) 상황과 해결 과정을 기록하는 문서입니다.  
과제 요구사항에 따라 팀 전체 기준 **최소 2회 이상**의 충돌 해결 기록을 작성하며, 최소 1회는 동일 파일의 동일 라인(hunk)을 동시 수정한 **비자명 충돌**을 포함합니다.

---

## 충돌 기록 1 (비자명 충돌: 동일 파일 동일 라인 동시 수정)

### 1. 개요 및 비자명 충돌 판정 이유
- **해결 주체 (PR 작성자)**: `@wow2658`
- **충돌 대상 커밋 작성자**: `@hyojun-edu`, `@greenable-7`
- **관련 브랜치 및 PR**: `feature/wow2658-amend-practice` (PR #17)
- **비자명 충돌(Non-trivial Conflict) 판정 이유**:  
  단순히 파일 위치가 다른 곳을 수정한 것이 아니라, 공통 문서인 `README.md`의 목차 섹션과 `docs/troubleshooting-log.md`의 본문 동일 위치(hunk)를 서로 다르게 수정하여 Git의 자동 병합(3-way merge) 알고리즘이 스스로 해결하지 못하고 사람이 직접 개입하여 맥락을 판단해야 했던 전형적인 비자명 충돌 사례입니다.

---

### 2. 상황 및 충돌 발생 원인 (What happened)

#### 브랜치 흐름도 (상황 재현)
```text
           [공통 베이스]
                 │
                 ├───> [feature/git-reset-study-note (@hyojun-edu)]
                 │        └── README.md에 'git reset' 추가
                 │        └── PR #19로 main에 먼저 병합 완료! (origin/main)
                 │
                 └───> [feature/wow2658-amend-practice (@wow2658)]
                          └── README.md에 'git commit --amend' 추가
                          └── 로컬 작업 중 최신 main과 충돌 발생! (CONFLICT)
```

#### 발생 배경
- `@wow2658`이 `feature/wow2658-amend-practice` 브랜치에서 `git commit --amend` 실습 및 문서 작업을 진행하고 있었습니다.
- 작업 도중 다른 팀원(@hyojun-edu)의 PR이 `main` 브랜치에 먼저 머지되었습니다.
- `@wow2658`의 브랜치에서 최신 `main`의 변경 사항을 동기화하기 위해 `git merge origin/main`을 실행했을 때, 두 작업이 공통 파일(`README.md`, `docs/troubleshooting-log.md`)의 동일한 인접 라인을 동시에 건드렸기 때문에 `CONFLICT (content): Merge conflict in ...` 에러가 발생했습니다.

---

### 3. 충돌 내용 및 충돌 마커 분석 (Conflict Markers)

Git은 충돌이 난 부분을 다음과 같이 충돌 마커로 감싸서 표시합니다.

#### 📌 충돌 마커 읽는 법 (팀원 참고용)
- `<<<<<<< HEAD`: 현재 내가 작업 중인 로컬 브랜치(`feature/wow2658-amend-practice`)의 변경 내용 시작점
- `=======`: 두 변경 사항의 경계 구분선 (위쪽: 내 작업 / 아래쪽: 병합 대상 작업)
- `>>>>>>> origin/main`: 가져오려는 대상 브랜치(`origin/main`, 최신 main에 머지된 팀원의 작업)의 끝점

#### 1) `README.md` 실제 충돌 화면
```markdown
## 목차

- [greenable-7: git stash / git stash pop](greenable-7/notes/git-stash.md)
<<<<<<< HEAD
- [wow2658: git commit --amend](wow2658/notes/git-commit-amend.md)
=======
- [hyojun-edu: git reset](hyojun-edu/notes/git-reset.md)
>>>>>>> origin/main
```
> **분석**: `greenable-7`의 stash 항목 바로 아랫줄에 `@wow2658`은 `amend` 항목을, 최신 main(`hyojun-edu`)은 `reset` 항목을 각자 추가하여 충돌이 발생함.

#### 2) `docs/troubleshooting-log.md` 실제 충돌 화면
```markdown
# Git 트러블슈팅 기록

<<<<<<< HEAD
## git commit --amend (최근 커밋 메시지 수정)
- 참여자: wow2658
...
=======
## git stash 및 git stash pop
- 참여자: greenable-7
...

## git reset --soft HEAD~1
- 참여자: hyojun-edu
...
>>>>>>> origin/main
```
> **분석**: 문서 최상단 제목 바로 아랫줄에 `@wow2658`은 `amend` 섹션을 추가했고, 최신 main에는 `stash`와 `reset` 섹션이 먼저 들어가 있어 시작 위치가 충돌함.

---

### 4. 수동 병합(Manual Resolution) 판단 기준 및 해결 과정 (How)

#### 💡 해결 시 고려한 원칙과 판단 기준
1. **절대 원칙 (상호 작업 100% 보존)**:  
   충돌 해결 시 상대방의 코드를 지우거나 내 코드만 남기는 것은 팀 협업에서 가장 피해야 할 행동입니다. 따라서 모든 팀원의 작업 내용을 온전히 살리기로 결정했습니다.
2. **배치 순서의 논리적 기준**:  
   과제 안내서의 4종 트러블슈팅 시나리오 공식 순서(`1. amend` → `2. reset` → `3. stash` → `4. revert`)를 참고하여, 첫 번째 항목인 `amend`를 최상단에 배치하고 기존 팀원들의 항목(`stash`, `reset`)을 자연스럽게 이어지도록 정렬했습니다.

#### 🛠 단계별 해결 절차 (Step-by-Step)

1. **최신 원격 main 브랜치 가져오기 및 머지 시도**:
   ```bash
   git fetch origin
   git merge origin/main
   # CONFLICT (content): Merge conflict in README.md
   # CONFLICT (content): Merge conflict in docs/troubleshooting-log.md
   # Automatic merge failed; fix conflicts and then commit the result.
   ```
2. **충돌 파일 상태 확인 (`git status`)**:
   ```bash
   git status
   # Unmerged paths:
   #   both modified:   README.md
   #   both modified:   docs/troubleshooting-log.md
   ```
3. **에디터(VS Code 등)에서 수동 편집 (마커 제거 및 내용 통합)**:
   - **`README.md` 최종 병합 결과**:
     ```markdown
     ## 목차

     - [wow2658: git commit --amend](wow2658/notes/git-commit-amend.md)
     - [greenable-7: git stash / git stash pop](greenable-7/notes/git-stash.md)
     - [hyojun-edu: git reset](hyojun-edu/notes/git-reset.md)
     ```
   - **`docs/troubleshooting-log.md` 최종 병합 결과**:
     - 최상단에 `## git commit --amend` 섹션을 배치하고, 그 아래에 기존 팀원들의 `## git stash` 및 `## git reset` 섹션을 그대로 유지.
4. **마커 제거 검증 및 머지 커밋 생성**:
   - 파일 내에 `<<<<<<<`, `=======`, `>>>>>>>` 잔여 마커가 없는지 꼼꼼히 확인.
   - 스테이징 후 머지 커밋 작성 (실제 생성된 커밋 해시: `5bfa4d4`):
     ```bash
     git add README.md docs/troubleshooting-log.md
     git commit -m "Merge remote-tracking branch 'origin/main' into feature/wow2658-amend-practice"
     ```
5. **원격 푸시 및 PR 공유**:
   - 원격 브랜치에 푸시한 후, PR 본문(`## How`)에 "팀원들의 작업을 모두 보존하면서 시나리오 순서에 맞춰 최상단에 amend를 배치하여 충돌 해결"했음을 명시하여 리뷰어가 안심하고 승인할 수 있도록 소통.

---

### 5. 결과 (Outcome)
- `origin/main`의 최신 변경 사항이 충돌 없이 안전하게 통합되었습니다.
- GitHub PR 페이지에서 충돌 경고(`Can't automatically merge`)가 사라지고 **`Able to merge`** 상태로 전환되었습니다.
- 모든 팀원의 링크와 트러블슈팅 문서가 단 1줄의 유실도 없이 완벽하게 보존되었습니다.

---

### 6. 팀원들을 위한 핵심 팁 및 배운 점 (Learnings & Tips)
1. **충돌은 에러가 아니라 협업의 자연스러운 과정입니다**:  
   충돌이 났다고 해서 작업을 되돌리거나 브랜치를 버릴 필요가 전혀 없습니다.
2. **상대방의 작업 의도를 먼저 존중하기**:  
   충돌이 발생했을 때 `HEAD`(내 작업)만 고집하지 않고, 상대방이 무엇을 왜 추가했는지 확인한 뒤 **"양쪽 모두를 살리는 방법"**을 찾는 것이 올바른 팀 협업 태도입니다.
3. **공통 문서 수정 시 주기적인 최신화 습관화**:  
   `README.md`나 `CONTRIBUTING.md`처럼 모두가 함께 쓰는 공통 문서를 작업할 때는, 작업 전후로 `git fetch origin`을 수시로 확인하여 최신 베이스 위에서 작업하면 충돌의 크기를 대폭 줄일 수 있습니다.

---

## 충돌 기록 2 (비자명 충돌: 동일 파일 동일 위치 수정)

### 참여자
- **해결 주체 (PR 작성자)**: @jangsoopark-codyssey
- **충돌 대상 커밋 작성자**: @wow2658

### 상황 (What happened)
- **관련 브랜치**: `feature/jangsoopark-revert-practice` (PR#24)
- **발생 배경**: 
   - Git Revert 실습 기록을 작성하던 중, 다른 팀원의 Git Amend 실습 기록이 main에 먼저 병합됨
   - 최신 main을 병합하기 위해 git merge origin/main을 실행하였으나, 두 브랜치가 문서 상단의 동일한 위치에 서로 다른 내용을 추가하여 Content Conflict가 발생함

### 충돌 내용 (Conflict markers)
- 충돌 파일: `docs/troubleshooting-log.md`
- 충돌 유형: 동일 파일의 동일 위치에 서로 다른 실습 기록을 추가하여 발생한 Content Conflict

```plaintext
<<<<<<< HEAD
## Git Revert — 원격에 Push된 Commit 취소
...
=======
## git commit --amend
...
>>>>>>> origin/main
```

- HEAD: @jangsoopark-codyssey의 Git Revert 실습 기록
- origin/main: @wow2658의 Git Amend 실습 기록
- 두 브랜치가 문서 제목 바로 아래 동일한 위치에 내용을 추가하여 Git이 자동으로 병합하지 못함

### 해결 과정 (How)
1. 최신 main을 병합하고 git status로 충돌 파일 확인
```bash
git fetch origin
git merge origin/main
git status
```

2. docs/troubleshooting-log.md에서 충돌 마커를 확인하고 Manual Resolution (Keep Both) 방식으로 수동 병합함
   - <<<<<<< HEAD, =======, >>>>>>> origin/main 제거
   - Git Revert와 Git Amend 기록 모두 유지
   - 기존 Git Stash 및 Git Reset 기록도 보존

3. 충돌 마커 제거 및 문서 검증
```bash
grep -n -E '^(<<<<<<<|=======|>>>>>>>)' docs/troubleshooting-log.md
grep -n '^## ' docs/troubleshooting-log.md
git diff --check
```

4. 충돌 해결 파일을 Staging하고 Merge Commit 생성 후 Push
```bash
git add docs/troubleshooting-log.md
git commit -m "docs: 트러블 슈팅 로그 충돌 해결"
git push origin feature/jangsoopark-revert-practice
```

### 결과 (Outcome)
```bash
git log -1 --oneline feature/jangsoopark-revert-practice
0ddcb9f (origin/feature/jangsoopark-revert-practice, feature/jangsoopark-revert-practice) docs: 트러블 슈팅 로그 충돌 해결
```
- Content Conflict를 수동으로 해결하고 PR #24에 반영함
- Git Revert, Amend, Stash, Reset의 네 가지 실습 기록을 모두 보존함
- Conflict Marker가 제거되었으며 git diff --check에서 오류가 발생하지 않음을 확인함
- 기존 Commit History를 유지하면서 최신 main의 변경 사항을 병합함

### 배운 점 (Learnings)
- 서로 다른 브랜치에서 동일 파일의 동일 위치를 수정하면 Content Conflict가 발생할 수 있음
- 충돌 해결 시 한쪽 변경 사항을 선택하기보다 양쪽 작업의 목적을 확인하고 보존하는 것이 중요함
- 공통 문서를 수정할 때 최신 main을 확인하고 팀원 간 작업 범위를 조율하면 충돌 발생 가능성을 줄일 수 있음

## 충돌 기록 3 (팀원 작성 예정)

> [!NOTE]  
> 본 영역은 과제 필수 요구사항(팀 전체 충돌 해결 실습 최소 2회)에 따라 다음 충돌 실습을 진행하는 팀원이 작성할 수 있도록 마련된 템플릿입니다.

### 참여자
- **해결 주체 (PR 작성자)**: 
- **충돌 대상 커밋 작성자**: 

### 상황 (What happened)
- **관련 브랜치**: 
- **발생 배경**: 

### 충돌 내용 (Conflict markers)
- 충돌이 발생한 파일 및 충돌 마커 코드 블록 작성

### 해결 과정 (How)
1. 
2. 
3. 

### 결과 (Outcome)
- 

### 배운 점 (Learnings)
- 

