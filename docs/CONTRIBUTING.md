# Contributing Guide

## 브랜치 네이밍 규칙

작업 목적을 식별할 수 있도록 다음 형식으로 브랜치 이름을 작성합니다.

`feature/<description>`

- 브랜치 이름은 소문자와 하이픈(-)을 사용합니다.
- `<description>`에는 해당 브랜치의 작업 내용을 간결하게 작성합니다.
- 하나의 Issue 를 여러 브랜치로 나누는 경우, 각 작업을 구분할 수 있도록 이름을 작성합니다.

### 예시
#### 하나의 Issue를 하나의 브랜치에서 해결하는 경우

- `feature/branch-naming`
- `feature/commit-convention`


#### 하나의 Issue를 여러 브랜치에서 해결하는 경우

Issue #10 - 팀원별 학습 노트 작성 및 README 목차 구성

- `feature/member-a-learning-note`
- `feature/member-b-learning-note`
- `feature/learning-notes-index`


## PR 규칙
- PR 타이틀
  - 의미없는 문구나 내용이 충분히 담기지 않은 제목 금지
  - PR에 포함된 commit들이 무엇인지 충분히 알 수 있는 내용으로 작성
- PR 본문
  - 필수 항목(What/Why/How)
  - 이슈 링크
    - 이슈 최종 해결인 경우 - Closes #issue
    - 이슈 부분 해결인 경우 - Part of #issue
- 병합 조건 (branch protection rule로 이미 강제된 규칙)
  - main branch에 대한 직접적인 Push 제한
  - PR을 통한 Merge 원칙
  - 리뷰 1명 승인

## 커밋 메시지 규칙
- 기본 형식: `<type>: <subject>`
- type 종류
  - `feat`: 새로운 기능 추가
  - `fix`: 오류 수정
  - `docs`: 문서 작성 또는 수정
  - `refactor`: 기능 변화 없는 코드 구조 개선
- 작성 원칙
  - subject에는 변경 대상과 내용을 구체적으로 작성
  - `update`, `fix`, `temp`, `wip`, `final`처럼 변경 내용을 알 수 없는 메시지 금지
  - `bug fix`, `edit file`처럼 변경 대상과 효과가 드러나지 않는 메시지 금지
- 좋은 예시
  - `feat: add user login validation`
  - `fix: prevent duplicate note creation`
  - `docs: add commit message convention`
  - `refactor: separate note storage logic`
- 나쁜 예시
  - `update`
  - `fix`
  - `wip`
  - `edit file`
    - `docs: update` (변경 대상과 내용이 모호함)
  - `fix: bug fix` (수정 대상과 결과가 모호함)


## 코드 리뷰 규칙

모든 Pull Request는 변경 사항의 품질을 검증하고 팀원 간 지식을 공유하기 위해 Code Review를 수행합니다.

### 리뷰 작성

- 모든 PR에는 최소 1개 이상의 실질적인 Review Comment를 작성합니다.
- 단순한 LGTM, 좋아요 등의 형식적인 의견만으로 리뷰를 완료하지 않습니다.
- 가능한 경우 특정 파일이나 라인을 근거로 질문, 오류 지적, 대안 또는 개선 사항을 제안합니다.
- 리뷰 의견은 변경 사항과 직접 관련된 내용을 중심으로 작성합니다.

### 리뷰 반영

- PR 작성자는 리뷰 의견을 확인하고 필요한 수정 사항을 반영합니다.
- 수정이 필요한 경우 추가 Commit을 작성하여 기존 PR에 반영합니다.
- 리뷰 의견에 답글을 작성하여 수정 내용이나 반영하지 않은 이유를 설명합니다.
- 논의가 완료된 Conversation은 Resolve 처리합니다.

### 리뷰 승인 및 병합

- PR 병합 전 최소 1명 이상의 Approve를 받아야 합니다.
- PR 작성자는 자신의 PR을 직접 승인할 수 없습니다.
- 리뷰에서 요청한 수정 사항이 해결되었는지 확인한 후 병합 합니다.
- 승인 이후 변경 사항이 추가된 경우 필요한 재검토를 진행합니다.

## 충돌 발생 시 기본 대응 흐름

협업 과정에서 브랜치 병합 시 충돌(Conflict)이 발생할 경우, 다음 기본 대응 흐름에 따라 해결합니다.

### 1. 기본 대응 흐름

#### 해결 주체 (누가)

- **PR 작성자 주도**: 충돌이 발생한 Pull Request의 작성자가 주도적으로 해결합니다.
- **상대 작업자와 협의**: 충돌 대상 코드를 작성한 팀원의 의도를 임의로 판단하기 어려운 경우, 해당 팀원에게 소통(코멘트/메신저)하여 함께 협의 후 해결합니다.

#### 해결 절차 (어떻게)

1. **최신 대상 브랜치 병합**: 작업 브랜치에서 대상 브랜치(보통 `main`)의 최신 상태를 병합하여 로컬에서 충돌 상황을 재현합니다.
   ```bash
   git fetch origin
   git merge origin/main
   ```
2. **충돌 파일 식별 및 검토**: `git status`로 충돌 파일(`both modified`)을 확인하고, 파일 내 충돌 마커(`<<<<<<< HEAD`, `=======`, `>>>>>>>`)를 검토합니다.
3. **수동 병합(Manual Resolution)**: 상대방의 작업 내용을 일방적으로 삭제하거나 덮어쓰지 않고, 양쪽 변경 사항의 맥락을 고려하여 하나의 완성된 형태로 수동 편집합니다.
4. **마커 제거 및 검증**: 모든 충돌 마커를 완전히 제거하고, 문법 오류나 누락된 내용이 없는지 확인합니다.
5. **커밋 및 푸시**: 해결된 파일을 스테이징하고 머지 커밋을 작성한 뒤 원격 브랜치로 푸시합니다.
   ```bash
   git add <충돌_해결_파일>
   git commit -m "Merge remote-tracking branch 'origin/main' into <작업_브랜치>"
   git push origin <작업_브랜치>
   ```

#### 기록 및 공유 (어디에)

- **PR 본문**: 충돌이 발생한 파일 목록과 해결 방식(어떤 기준으로 병합했는지, 특이사항)을 명시합니다.
- **충돌 해결 기록 문서 ([docs/conflict-resolution.md](conflict-resolution.md))**:
  - 팀 과제 요구사항(팀 전체 최소 2회 이상, 비자명 충돌 1회 이상 필수)에 따라 충돌 상황, 마커 내용, 해결 과정, 배운 점을 양식에 맞춰 상세히 기록합니다.
  - 현재 1차 비자명 충돌 해결 사례(사례 1: `@wow2658`)가 기록되어 있으며, 2차 사례는 팀원이 추가 작성할 예정입니다.

---

### 2. 충돌 해결 사례 (Case Study)

팀 과제 요구사항에 따라 총 2회 이상의 충돌 해결 사례를 기록하며, 상세한 해결 과정은 [docs/conflict-resolution.md](conflict-resolution.md)를 참조합니다.

#### 사례 1 (비자명 충돌: 동일 파일 동일 라인 동시 수정)
- **작성자**: `@wow2658` (참여자: `@hyojun-edu`, `@greenable-7`)
- **발생 배경**: `feature/wow2658-amend-practice` 브랜치 작업 중, 다른 팀원의 PR이 `main`에 먼저 머지되어 공통 문서(`README.md`, `docs/troubleshooting-log.md`)의 동일한 라인에서 비자명 충돌 발생
- **해결 요약**: 수동 3-way 병합을 통해 어느 한쪽도 삭제하지 않고 팀원 전체의 작업 내역을 100% 보존하며 순서 정렬(1st amend -> 2nd stash -> 3rd reset) 후 머지 커밋 생성
- **상세 내역**: [docs/conflict-resolution.md - 충돌 기록 1](conflict-resolution.md#충돌-기록-1-비자명-충돌-동일-파일-동일-라인-동시-수정) 참고

#### 사례 2 (팀원 작성 예정)
- **작성자**: (팀원 배정 예정)
- **내용**: 과제 요구사항에 맞추어 팀원이 2번째 충돌 실습을 진행한 후 `docs/conflict-resolution.md`에 추가 작성 예정


