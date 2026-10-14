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
